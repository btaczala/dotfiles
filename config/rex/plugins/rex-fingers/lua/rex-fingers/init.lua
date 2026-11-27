-- rex-fingers: letter hints over the paths, URLs, hashes, and other strings
-- on a pane. Press the hint to copy the match, Shift+hint to paste it into
-- the pane, Ctrl+hint to open it.
--
-- With overlay = "float", the action opens a floating pane exactly over the
-- focused pane and runs the rex-fingers program in it. That program redraws
-- the captured pane with hints and closes itself once a hint is pressed.
--
-- With overlay = "pane", the program draws the hints into the focused
-- pane's own tty. The hint letters are function key bindings, bound once
-- when the config loads. While a run is active on the focused pane they take
-- the key; otherwise they return nothing and the key goes on to the pane.
-- The pane is repainted from the capture when a hint is picked or the run is
-- cancelled. There is no key mode, so Rex for Mac shows no key list.
--
-- On a pane of a Rex host the tty and those key bindings are out of reach:
-- the session runs on the host, this plugin on the app's machine. The
-- host's own rex runs a script there, the agent, in a hidden block: it
-- draws the frames into the pane's tty, and a small floating pane takes
-- the focus and gives it the keys. See host_run and agent_run.
local M = {}

local terminal = "com.superlogical.terminal"

-- The protocol this plugin needs from the program: `rex-fingers protocol`
-- prints the one the binary speaks. A binary built before the plugin was
-- updated rejects the flags it does not know, so setup warns.
local protocol = 7
-- The protocol the configured binary reported, read by setup. A flag it
-- does not know is not sent; without a check it is taken to be current.
local program_protocol = protocol

-- Every option, with its default. The names and defaults follow
-- tmux-fingers where Rex allows it.
local defaults = {
  -- Absolute path of the rex-fingers binary. Empty looks it up on PATH:
  -- the float through the login shell, which is slower to start; the
  -- in-pane runs on the Rex server's PATH, /usr/bin:/bin:/usr/sbin:/sbin
  -- on a Mac, which holds no rex-fingers.
  binary = "",
  -- Key to bind, or false to bind nothing. tmux-fingers' key is
  -- "ctrl+b>shift+f".
  key = "alt+f",
  -- Built-in pattern names to enable. Empty enables all but digit.
  patterns = {},
  -- Extra regular expressions, Go syntax.
  extra = {},
  -- What a hint does: ":copy:", ":paste:", ":open:", ":reveal:", or a shell command
  -- that reads the match on stdin. Every pick is copied first.
  main_action = ":copy:",
  shift_action = ":paste:",
  ctrl_action = ":open:",
  alt_action = "",
  -- Command that :copy: runs with the match on stdin. Empty picks pbcopy,
  -- wl-copy, xclip, or xsel.
  copy_command = "",
  -- Keyboard layout that picks the hint letters: qwerty, qwerty-homerow,
  -- colemak, dvorak, ... `rex-fingers layouts` lists them.
  keyboard_layout = "qwerty",
  -- Hint letters, overriding the layout.
  alphabet = "",
  -- Where the hint sits: "left" or "right" covers that end of the match;
  -- "gutter" uses the blank cells before it and falls back to "right".
  hint_position = "left",
  -- SGR parameters for the hint letters and the rest of the match. The
  -- defaults name theme palette slots, so they follow the theme.
  hint_style = "",
  highlight_style = "",
  -- Dim everything that is not a match, so the hints stand out.
  dim = true,
  -- Show the picked match in reverse video for a moment before the pane
  -- comes back, as feedback that it was copied.
  flash = false,
  -- Where the hints are drawn: "pane", the pane itself, or "float", a
  -- floating pane over the pane, two rows shorter.
  overlay = "pane",
  -- Key that hints every pane of the window at once, or false to bind
  -- nothing. Always draws in the panes, whatever overlay says. A pick
  -- pastes into the pane the key was pressed in.
  window_key = "alt+shift+f",
  -- Hint the rows a pane shows when it is scrolled up, not its live
  -- screen. In-pane drawing only. Rex reports no scroll position, so each
  -- trigger has the app copy the visible rows in copy mode: copy mode
  -- flashes, and the clipboard is saved and put back, text only.
  follow_scroll = false,
  -- The same on a pane of a Rex host, off unless set. There the app is
  -- asked for each copy-mode step in turn: the selection shows for about
  -- a second, and the hints come about 1.4 s later.
  host_follow_scroll = false,
  -- How a run on a pane of a Rex host reads the hint keys. "reader"
  -- opens a small floating pane on the host that takes the focus.
  -- "substitute" opens the same pane, and once the app has loaded it,
  -- it takes the pane's own place with the same hints, so the small
  -- pane shows only for a second or so at each end of a run. "mode"
  -- turns on a key mode of the app, rex_fingers, for the run: no pane,
  -- but the app shows a panel that lists every key of the mode. The app
  -- must allow remote control, or the run uses "reader".
  host_keys = "reader",
}

-- rect_of walks a window's layout tree to the block and returns its
-- rectangle as [x, y, w, h] fractions of the window.
local function rect_of(node, block_id)
  if node == nil then return nil end
  if node.block_id == block_id then return node.rect end
  if node.split then
    return rect_of(node.split.before, block_id) or rect_of(node.split.after, block_id)
  end
  return nil
end

-- locate returns the window ID and rectangle of a block in the session.
local function locate(session_id, block_id)
  local view, err = rex.session.view{ session_id = session_id }
  if not view then error(err, 0) end
  for _, w in ipairs(view.windows or {}) do
    for _, layer in ipairs(w.layers or {}) do
      local r = rect_of(layer.layout, block_id)
      if r then
        -- A floating layer's layout is relative to the layer's bounds.
        if layer.kind ~= "tiled" and layer.bounds then
          local b = layer.bounds
          r = { b[1] + r[1] * b[3], b[2] + r[2] * b[4], r[3] * b[3], r[4] * b[4] }
        end
        return w.window_id, r
      end
    end
  end
  error("rex-fingers: pane not found in the session", 0)
end

-- open_floats returns the fingers floating panes in the window that holds
-- block_id, which may be one of them.
local function open_floats(session_id, block_id)
  local view, err = rex.session.view{ session_id = session_id }
  if not view then error(err, 0) end
  for _, w in ipairs(view.windows or {}) do
    local ids, found = {}, false
    for _, layer in ipairs(w.layers or {}) do
      for _, b in ipairs(layer.blocks or {}) do
        if b.block_id == block_id then found = true end
        if layer.kind ~= "tiled" and b.label == "fingers" and b.creator_name == terminal then
          ids[#ids + 1] = b.block_id
        end
      end
    end
    if found then return ids end
  end
  return {}
end

-- The most a format or blob_read reply holds. Without max_bytes a
-- blob_read reply holds 48 KiB, twenty calls where one does.
local reply_limit = 983040

-- read_blob returns a format result from byte offset to its end.
local function read_blob(target, id, offset)
  local parts = {}
  while true do
    local r, err = rex.block.call(terminal, "blob_read", { session_id = target.session_id, block_id = target.block_id, id = id, offset = offset, max_bytes = reply_limit })
    if not r then error(err, 0) end
    parts[#parts + 1] = r.data
    offset = offset + #r.data
    if r.eof or #r.data == 0 then return table.concat(parts) end
  end
end

-- read_format returns one format call on a pane, read in blobs if it is
-- large. target holds session_id and block_id.
--
-- With tail, it returns only the end of the output. The output holds the
-- whole scrollback, megabytes on a pane in use, and the program reads the
-- screen alone, the last rows of it. On a Rex host every call is a round
-- trip, so the first reply asks for tail.bytes: a short output arrives
-- whole, in one call, and of a long one only the last tail.bytes are read.
-- With tail.rows, the VT format, that grows until it holds as many whole
-- rows. A row of the VT starts with its own SGR reset, so one cut from the
-- rows above it draws the same; the row the cut falls in is dropped by the
-- program, which keeps the last rows.
local function read_format(target, format_args, tail)
  local args = { session_id = target.session_id, block_id = target.block_id, max_bytes = tail and tail.bytes or reply_limit }
  for k, v in pairs(format_args) do args[k] = v end
  local r, err = rex.block.call(terminal, "format", args)
  if not r then error(err, 0) end
  if not r.id or r.eof then return r.content end
  if not tail or not r.total then return r.content .. read_blob(target, r.id, #r.content) end
  while true do
    local offset = math.max(0, r.total - tail.bytes)
    local data = read_blob(target, r.id, offset)
    local _, breaks = data:gsub("\r\n", "")
    if offset == 0 or not tail.rows or breaks >= tail.rows then return data end
    tail.bytes = tail.bytes * 4
  end
end

-- dump writes one format call on a pane to a temp file and returns the
-- path. tail is as in read_format.
local function dump(target, format_args, tail)
  local data = read_format(target, format_args, tail)
  local path = os.tmpname()
  local f = assert(io.open(path, "w"))
  f:write(data)
  f:close()
  return path
end

-- capture writes the pane's screen to temporary files before the program
-- starts, so the program draws as soon as it starts. On a pane of a Rex
-- host it reads only the end of the scrollback, and also returns the tail
-- that held the screen, for the later captures of the run.
local function capture(ctx, host)
  local size, err = rex.block.call(terminal, "size", { session_id = ctx.session_id, block_id = ctx.block_id })
  if not size then error(err, 0) end
  -- Eight bytes a cell holds most screens, colours included.
  local tail = host and { rows = size.rows, bytes = math.min(reply_limit, math.max(32768, size.rows * size.columns * 8)) }
  -- The VT dump redraws the screen row by row. The unwrapped text says
  -- which rows the terminal wrapped, so a match can span them. The text
  -- of the screen is no longer than its VT, so the same bytes hold it.
  local vt = dump(ctx, { format = "vt" }, tail)
  local text = dump(ctx, { format = "text", unwrap = true, trim = true }, tail and { bytes = tail.bytes })
  return vt, text, size, tail
end

-- currents captures every pane of a run as VT, as it is now, so the
-- program can tell whether a pane wrote output since the hints went up.
-- The text format drops blank rows at the foot of the screen; the VT keeps
-- every screen row. Returns one path per block of the run.
local function currents(run)
  local paths = {}
  for i, id in ipairs(run.blocks) do
    paths[i] = dump({ session_id = run.session_id, block_id = id }, { format = "vt" }, run.tails and run.tails[id])
  end
  return paths
end

-- option_flags appends the flags that pick and style the hints and say what
-- a hint does. args are the action's own arguments, which override the
-- setup options for one run.
local function option_flags(argv, opts, args)
  args = args or {}
  local function pick(name)
    local v = args[name]
    if v == nil or v == "" then v = opts[name] end
    return v
  end
  argv[#argv + 1] = "--hint-position"
  argv[#argv + 1] = opts.hint_position
  if not opts.dim then argv[#argv + 1] = "--no-dim" end
  if opts.flash then
    argv[#argv + 1] = "--flash"
    argv[#argv + 1] = "150"
  end
  local patterns = args.patterns or (#opts.patterns > 0 and table.concat(opts.patterns, ",")) or ""
  local flags = {
    ["--patterns"] = patterns,
    ["--main-action"] = pick("main_action"),
    ["--shift-action"] = pick("shift_action"),
    ["--ctrl-action"] = pick("ctrl_action"),
    ["--alt-action"] = pick("alt_action"),
    ["--copy-command"] = pick("copy_command"),
    ["--keyboard-layout"] = opts.keyboard_layout,
    ["--alphabet"] = opts.alphabet,
    ["--hint-style"] = opts.hint_style,
    ["--highlight-style"] = opts.highlight_style,
  }
  for flag, value in pairs(flags) do
    if value ~= nil and value ~= "" then
      argv[#argv + 1] = flag
      argv[#argv + 1] = value
    end
  end
  for _, re in ipairs(opts.extra) do
    argv[#argv + 1] = "--extra"
    argv[#argv + 1] = re
  end
  return argv
end

local function binary(opts)
  return opts.binary ~= "" and opts.binary or "rex-fingers"
end

-- command builds the argument list of the program in the floating pane.
local function command(opts, ctx, args)
  local path, text, size = capture(ctx)
  local argv = { binary(opts), "show", "--session", ctx.session_id, "--block", ctx.block_id,
                 "--vt-file", path, "--text-file", text, "--rows", tostring(size.rows),
                 "--cols", tostring(size.columns) }
  return option_flags(argv, opts, args)
end

-- The in-pane run. state holds one run per block: the argv the program
-- needs on every call, and the hint letters typed so far.
local state = {}

local function mode_set(modes, number)
  for _, m in ipairs(modes.modes or {}) do
    if m.number == number then return m.set end
  end
  return true
end

-- exec runs the program with argv and the extra flags, and decodes the
-- JSON object it prints.
local function exec(argv, ...)
  local full = {}
  for _, a in ipairs(argv) do full[#full + 1] = a end
  for _, a in ipairs({ ... }) do full[#full + 1] = a end
  -- A key function may run 5 seconds; after that Rex drops the key.
  local r, err = rex.exec(full, { timeout = 4 })
  if not r then return nil, err end
  if not r.ok then return nil, "rex-fingers: " .. (r.stderr ~= "" and r.stderr or ("exit " .. tostring(r.code))) end
  return rex.json.decode(r.stdout)
end

-- Panes on another machine. A session on a Rex host runs there, but this
-- Lua and the program run here, on the app's machine: the pane's tty and
-- process are out of reach. So the program writes each frame to a local
-- file (--remote), and a writer block on the host copies what it is sent
-- to the pane's tty. The program gives the writer's argv in draw's reply.

-- this_host_id returns the ID of this machine's Rex server, read from the
-- file Rex keeps it in, or false when there is none.
local this_host
local function this_host_id()
  if this_host == nil then
    this_host = false
    local home = os.getenv("HOME") or ""
    local paths = {
      home .. "/Library/Application Support/rex/host-id",
      (os.getenv("XDG_STATE_HOME") or (home .. "/.local/state")) .. "/rex/host-id",
    }
    for _, path in ipairs(paths) do
      local f = io.open(path)
      if f then
        local id = (f:read("*l") or ""):gsub("%s", "")
        f:close()
        if id ~= "" then
          this_host = id
          break
        end
      end
    end
  end
  return this_host
end

-- remote_host returns the host ID of the server that runs the session,
-- when that server is on another machine, or nil. A session stays on its
-- server, so the answer is kept per session. Without this machine's ID,
-- or when the call fails, the pane counts as local, as before this check.
local session_hosts = {}
-- The address a host's server listens on, as a program on the host
-- reaches it, per host ID.
local host_endpoints = {}
local function remote_host(session_id)
  local known = session_hosts[session_id]
  if known ~= nil then return known or nil end
  local mine = this_host_id()
  local host = false
  if mine and rex.call then
    local ok, status = pcall(rex.call, "server.status")
    if ok and type(status) == "table" and status.host_id and status.host_id ~= mine then
      host = status.host_id
      for _, l in ipairs(status.listeners or {}) do
        if l.primary and l.transport == "unix" then host_endpoints[host] = l.endpoint end
      end
    end
  end
  session_hosts[session_id] = host
  return host or nil
end

-- Programs that show another machine's shell in a local pane. Their
-- pane's tty is here, so hints draw as usual, but the paths on screen are
-- the other machine's: the program copies them instead of opening them.
local remote_shells = { ssh = true, ["mosh-client"] = true, et = true }

-- A binary before protocol 3 does not know the flag, so it is not sent.
local function shows_remote_paths(fg)
  return remote_shells[fg.name] and program_protocol >= 3
end

-- remote_file names the local file the program writes a remote pane's
-- frames to. The same pane gets the same name, so a run left without
-- restore is found again, as a tty's is.
local function remote_file(host, block_id)
  local dir = os.getenv("TMPDIR") or "/tmp"
  if dir:sub(-1) ~= "/" then dir = dir .. "/" end
  return dir .. "rex-fingers-host-" .. host:sub(1, 8) .. "-" .. block_id:gsub("[^%w]", "") .. ".out"
end

-- close_leftover_writers closes the writers of runs that ended without
-- finish, such as when the config reloaded during a run. They are hidden,
-- so nothing else would.
local function close_leftover_writers(session_id)
  local live = {}
  for _, run in pairs(state) do
    for _, w in pairs(run.writers or {}) do live[w.block] = true end
  end
  local r = rex.call("session.list_blocks", { session_id = session_id })
  for _, b in ipairs((r and r.blocks) or {}) do
    if b.label == "fingers-writer" and not live[b.block_id] then
      pcall(rex.call, "block.close", { session_id = session_id, block_id = b.block_id })
    end
  end
end

-- writer_deadline is the time start_writer stops waiting, set by a host
-- run so that no wait passes the run's limit.
local writer_deadline

-- start_writer starts the writer for a pane on the host, with the pane's
-- process appended to the argv draw gave, and waits until it reports that
-- it reached the pane's tty. It returns the writer's block ID.
local function start_writer(session_id, pid, reply)
  local argv = {}
  for _, a in ipairs(reply.writer) do argv[#argv + 1] = a end
  argv[#argv + 1] = tostring(pid)
  local b, err = rex.call("session.new_block", {
    session_id = session_id,
    flavor = terminal .. ".shell",
    label = "fingers-writer",
    options = { shell = "none", command = argv, exit = { on_completion = false } },
  })
  if not b then return nil, err end
  -- About 3 s on this machine. An action has no rex.sleep, only scripts
  -- do, so the pause runs sleep.
  for _ = 1, 40 do
    if writer_deadline and os.time() >= writer_deadline then break end
    local r = rex.block.call(terminal, "format", { session_id = session_id, block_id = b.block_id, format = "text" })
    local text = (r and r.content) or ""
    if text:find(reply.writer_ready, 1, true) then return b.block_id end
    if text:find(reply.writer_failed, 1, true) then break end
    if rex.sleep then rex.sleep(0.05) else rex.exec({ "sleep", "0.05" }, { timeout = 1 }) end
  end
  rex.call("block.close", { session_id = session_id, block_id = b.block_id })
  return nil, "Fingers: could not reach the pane's terminal on the host"
end

-- forward sends what the program wrote for each remote pane of a run to
-- its writer, and empties the file. Rex takes requests up to 1 MiB, so a
-- large frame goes in parts, cut between UTF-8 characters.
local function forward(run)
  for _, w in pairs(run.writers or {}) do
    local f = io.open(w.file, "rb")
    if f then
      local data = f:read("*a")
      f:close()
      os.remove(w.file)
      local i = 1
      while i <= #data do
        local j = math.min(#data, i + 262143)
        while j > i and j < #data and data:byte(j + 1) >= 0x80 and data:byte(j + 1) < 0xC0 do j = j - 1 end
        local ok, err = rex.block.call(terminal, "write", { session_id = run.session_id, block_id = w.block, data = data:sub(i, j) })
        if not ok then error(err, 0) end
        i = j + 1
      end
    end
  end
end

-- close_writers ends a run's writers. A writer stays open after it exits,
-- so its result can be read; it is closed here either way.
local function close_writers(run)
  for _, w in pairs(run.writers or {}) do
    pcall(rex.call, "block.close", { session_id = run.session_id, block_id = w.block })
    os.remove(w.file)
  end
  run.writers = nil
end

-- finish forgets the run. With restore, it also repaints the pane as it
-- was. A remote run's last bytes are sent and its writers closed.
local function finish(block_id, run, restore)
  state[block_id] = nil
  for _, id in ipairs((run and run.blocks) or {}) do state[id] = nil end
  if not run then return end
  local ok, err = true, nil
  if restore then
    ok, err = pcall(function() exec(run.argv("restore", currents(run))) end)
  end
  if run.writers then
    pcall(forward, run)
    -- A host run closes them itself, after it has given the focus back.
    if not run.keep_writers then close_writers(run) end
  end
  if not ok then error(err, 0) end
end

-- recover_pane puts a pane back when a run was left on it without
-- restore, such as after a config reload, and the pane still shows the
-- hints. The record of the run here is gone, so the program decides from
-- the state it kept beside the capture.
local function recover_pane(opts, ctx)
  -- A remote pane's leftover run is picked up by the next draw instead,
  -- which has a writer to send the restore through.
  if remote_host(ctx.session_id) then return end
  local target = { session_id = ctx.session_id, block_id = ctx.block_id }
  local process = rex.block.call(terminal, "process", target)
  local fg = process and (process.foreground or process.child)
  if not fg then return end
  local path, text, size = capture(ctx)
  exec({ binary(opts), "restore", "--recover", "--pid", tostring(fg.pid), "--vt-file", path,
         "--text-file", text, "--rows", tostring(size.rows), "--cols", tostring(size.columns) })
  os.remove(path)
  os.remove(text)
end

-- remote_run gives a run on a remote pane its writer, once draw has
-- written to the pane's file, and sends the frame. pid is a process on the
-- pane's tty, on the host. A draw that wrote nothing needs no writer.
local function remote_run(run, reply, block_id, pid, file)
  local f = io.open(file, "rb")
  local size = f and f:seek("end") or 0
  if f then f:close() end
  if size == 0 then return end
  local writer, err = start_writer(run.session_id, pid, reply)
  if not writer then
    os.remove(file)
    error(err, 0)
  end
  run.writers = run.writers or {}
  run.writers[block_id] = { block = writer, file = file }
  forward(run)
end

local function start_in_pane(opts, ctx, args, host)
  local target = { session_id = ctx.session_id, block_id = ctx.block_id }
  local modes, err = rex.block.call(terminal, "modes", target)
  if not modes then error(err, 0) end
  local process
  process, err = rex.block.call(terminal, "process", target)
  if not process then error(err, 0) end
  local fg = process.foreground or process.child
  if not fg then error("Fingers: no process in the pane", 0) end
  -- A host's directory is no directory of this machine, where an action
  -- command runs, so it is not asked for: one round trip less.
  local pwd = not host and rex.block.call(terminal, "pwd", target)
  local path, text, size, capture_tail = capture(ctx, host)
  local cursor = mode_set(modes, 25) and "true" or "false"
  local wrap = mode_set(modes, 7) and "true" or "false"
  -- Flags that draw, press, and restore all take.
  local tail = { "--vt-file", path, "--text-file", text, "--rows", tostring(size.rows), "--cols", tostring(size.columns),
                 "--cursor-visible=" .. cursor, "--wraparound=" .. wrap,
                 "--cwd", (pwd and pwd.pwd) or "" }
  option_flags(tail, opts, args)
  -- A remote pane is named by its file from the start; its pid is a
  -- process on the host.
  local file = host and remote_file(host, ctx.block_id)
  local pane = { "--pid", tostring(fg.pid) }
  if file then
    os.remove(file)
    tail[#tail + 1] = "--remote"
    pane = { "--tty", file }
  elseif shows_remote_paths(fg) then
    tail[#tail + 1] = "--remote-paths"
  end
  local r
  r, err = exec({ binary(opts), "draw", "--begin", pane[1], pane[2] }, unpack(tail))
  if not r then
    os.remove(path)
    os.remove(text)
    if file then os.remove(file) end
    error(err, 0)
  end
  -- argv builds a press or restore call; current is the pane's text
  -- captured now, one path per block.
  local function argv(sub, current)
    local a = { binary(opts), sub, "--tty", r.tty }
    for _, x in ipairs(tail) do a[#a + 1] = x end
    if current and current[1] then
      a[#a + 1] = "--current-file"
      a[#a + 1] = current[1]
    end
    return a
  end
  local run = { typed = "", busy = false,
                session_id = ctx.session_id, origin = ctx.block_id, blocks = { ctx.block_id },
                tails = capture_tail and { [ctx.block_id] = capture_tail } }
  if file then
    -- The shell, not the foreground program: it lives as long as the pane.
    local ok, rerr = pcall(remote_run, run, r, ctx.block_id, (process.child or fg).pid, file)
    if not ok then
      -- No writer, so nothing reaches the pane. The restore still drops
      -- the captures and the program's record of the run.
      pcall(exec, argv("restore"))
      os.remove(file)
      error(rerr, 0)
    end
  end
  if r.hints == 0 then
    os.remove(path)
    os.remove(text)
    if run.writers then close_writers(run) end
    return { hints = 0 }
  end
  run.argv = argv
  state[ctx.block_id] = run
  return { hints = r.hints }
end

-- window_blocks lists the terminal blocks of the window that holds
-- block_id, that block first. Layout nodes carry no flavor, so the
-- layers' block lists are read instead.
local function window_blocks(session_id, block_id)
  local view, err = rex.session.view{ session_id = session_id }
  if not view then error(err, 0) end
  for _, w in ipairs(view.windows or {}) do
    local ids, found = {}, false
    for _, layer in ipairs(w.layers or {}) do
      for _, b in ipairs(layer.blocks or {}) do
        -- The reader of a host run is a terminal too, and is no pane.
        if b.creator_name == terminal and b.label ~= "fingers-reader" then
          if b.block_id == block_id then found = true else ids[#ids + 1] = b.block_id end
        end
      end
    end
    if found then
      table.insert(ids, 1, block_id)
      return ids
    end
  end
  error("rex-fingers: pane not found in the session", 0)
end

-- pane_spec captures one pane and returns its --pane value for draw and
-- the capture's path, or nil when the pane has no process to draw into.
-- On a remote pane, given host, the spec names the pane's file and is
-- marked remote, and it also returns the file and the pid for the writer,
-- and the tail its capture read.
local function pane_spec(session_id, block_id, host)
  local target = { session_id = session_id, block_id = block_id }
  local process = rex.block.call(terminal, "process", target)
  local fg = process and (process.foreground or process.child)
  if not fg then return nil end
  local modes = rex.block.call(terminal, "modes", target) or {}
  local path, text, size, tail = capture(target, host)
  local pane = "pid=" .. fg.pid
  local file = host and remote_file(host, block_id)
  if file then
    os.remove(file)
    pane = "tty=" .. file .. ",remote=true"
  elseif shows_remote_paths(fg) then
    pane = pane .. ",remote_paths=true"
  end
  local spec = string.format("%s,vt=%s,text=%s,rows=%d,cols=%d,cursor=%s,wrap=%s",
    pane, path, text, size.rows, size.columns,
    mode_set(modes, 25) and "true" or "false", mode_set(modes, 7) and "true" or "false")
  return spec, path, text, file, (process.child or fg).pid, tail
end

-- start_panes draws hints into the terminal panes in blocks at once. The
-- panes share one hint list. The pane the key was pressed in comes first:
-- a paste lands there and a command runs in its directory.
--
-- With await, a count, the program does not draw yet. It returns the ttys
-- and waits in the background for the app to copy the rows the first
-- await panes show, in the order of blocks, then draws the page each of
-- them is scrolled to. The caller queues those copies. It returns the
-- result and the blocks that take part.
local function start_panes(opts, ctx, args, blocks, await, host)
  local pwd = not host and rex.block.call(terminal, "pwd", { session_id = ctx.session_id, block_id = ctx.block_id })
  local specs, paths, members, remotes, tails = {}, {}, {}, {}, {}
  for _, id in ipairs(blocks) do
    local spec, path, text, file, pid, tail = pane_spec(ctx.session_id, id, host)
    if spec then
      specs[#specs + 1] = spec
      paths[#paths + 1] = path
      paths[#paths + 1] = text
      members[#members + 1] = id
      tails[id] = tail
      if file then remotes[#remotes + 1] = { block = id, file = file, pid = pid } end
    end
  end
  if #specs == 0 then error("Fingers: no process in the panes", 0) end
  local function cleanup() for _, p in ipairs(paths) do os.remove(p) end end
  local tail = { "--cwd", (pwd and pwd.pwd) or "" }
  option_flags(tail, opts, args)
  local argv = { binary(opts), "draw", "--begin" }
  if await then
    argv[#argv + 1] = "--await-views"
    argv[#argv + 1] = tostring(await)
  end
  for _, s in ipairs(specs) do
    argv[#argv + 1] = "--pane"
    argv[#argv + 1] = s
  end
  local r, err = exec(argv, unpack(tail))
  if not r then
    cleanup()
    for _, m in ipairs(remotes) do os.remove(m.file) end
    error(err, 0)
  end
  -- Later calls name each pane by the tty draw found, not by pid, and
  -- carry each pane's text captured now when current is given. A remote
  -- pane's spec already names its file.
  local function argv(sub, current)
    local a = { binary(opts), sub }
    for i, s in ipairs(specs) do
      local spec = s:gsub("^pid=%d+", "tty=" .. r.panes[i].tty)
      if current and current[i] then spec = spec .. ",current=" .. current[i] end
      a[#a + 1] = "--pane"
      a[#a + 1] = spec
    end
    for _, x in ipairs(tail) do a[#a + 1] = x end
    return a
  end
  local run = { argv = argv, typed = "", busy = false,
                session_id = ctx.session_id, origin = ctx.block_id, blocks = members,
                tails = host and tails or nil }
  for _, m in ipairs(remotes) do
    local ok, rerr = pcall(remote_run, run, r, m.block, m.pid, m.file)
    if not ok then
      -- Put back the panes already drawn, then give up.
      pcall(function() exec(argv("restore")) end)
      pcall(forward, run)
      close_writers(run)
      cleanup()
      for _, x in ipairs(remotes) do os.remove(x.file) end
      error(rerr, 0)
    end
  end
  -- A waiting draw has no count yet; the program deletes the captures
  -- itself when it finds no hints.
  if not await and r.hints == 0 then
    cleanup()
    if run.writers then close_writers(run) end
    return { hints = 0 }, {}
  end
  for _, id in ipairs(members) do state[id] = run end
  return { hints = r.hints, waiting = r.waiting, panes = #members }, members
end

function M.setup(user)
  local opts = {}
  for k, v in pairs(defaults) do opts[k] = v end
  for k, v in pairs(user or {}) do
    if defaults[k] == nil then error("rex-fingers: unknown option " .. tostring(k), 0) end
    opts[k] = v
  end
  if opts.overlay ~= "float" and opts.overlay ~= "pane" then
    error("rex-fingers: overlay must be \"float\" or \"pane\"", 0)
  end
  if opts.host_keys ~= "mode" and opts.host_keys ~= "reader" and opts.host_keys ~= "substitute" then
    error("rex-fingers: host_keys must be \"mode\", \"reader\", or \"substitute\"", 0)
  end
  -- A binary older than the plugin fails on flags it does not know, on
  -- the first key, with no hint why. Say it once, when the config loads.
  -- Without an absolute binary the PATH here may not be the one the runs
  -- see, so nothing is checked.
  if opts.binary ~= "" then
    local ok, r = pcall(rex.exec, { opts.binary, "protocol" }, { timeout = 2 })
    local have = ok and r and r.ok and tonumber((r.stdout or ""):match("%d+"))
    -- No protocol command at all: version 1, up to v0.4.2.
    program_protocol = have or 1
    if not have or have < protocol then
      rex.log("warn", string.format("Fingers: %s speaks protocol %s and the plugin needs %d; build it again",
        opts.binary, have and tostring(have) or "1 or none", protocol))
    end
  end
  -- The in-pane keys are bound only when a run can draw in a pane.
  local in_pane_keys = opts.overlay == "pane" or opts.window_key

  local function start(ctx, args, scope, host)
    if scope == "window" then
      return (start_panes(opts, ctx, args, window_blocks(ctx.session_id, ctx.block_id), nil, host))
    end
    return start_in_pane(opts, ctx, args, host)
  end

  -- follow_scroll hints the page each pane is scrolled to. Rex reports no scroll
  -- position, so the app copies the rows each pane shows, in copy mode,
  -- and the program takes them from the clipboard. The program is started
  -- first: it saves the clipboard, returns, and waits in the background.
  -- Then the copies are queued; the app runs them after this action
  -- returns. Nothing calls back into Lua, because the one way the app has,
  -- a key sent to the pane, moves a scrolled pane to its last row.
  --
  -- Copy mode acts on the focused pane alone, so only that pane's page is
  -- read. In window scope the other panes are hinted on their live
  -- screens. Reading them in turn with pane.focus_next between the copies
  -- worked when the rex CLI ran the queue, one action per call. On a key
  -- press the app runs the whole queue at once, and the focus has not
  -- moved by the time the next copy runs: every copy was of the first
  -- pane.
  local function follow_scroll(ctx, args, scope)
    local blocks = { ctx.block_id }
    if scope == "window" then blocks = window_blocks(ctx.session_id, ctx.block_id) end
    local result = start_panes(opts, ctx, args, blocks, 1)
    rex.client.queue("pane.copy_mode.enter")
    rex.client.queue("pane.copy_mode.move", { to = "screen_top" })
    rex.client.queue("pane.copy_mode.select", { mode = "line" })
    rex.client.queue("pane.copy_mode.move", { to = "screen_bottom" })
    rex.client.queue("pane.copy_mode.yank")
    -- The yank leaves copy mode but keeps its selection on screen, a grey
    -- box over the whole pane. Starting a new selection in copy mode and
    -- leaving drops it; entering and leaving alone does not.
    rex.client.queue("pane.copy_mode.enter")
    rex.client.queue("pane.copy_mode.select", { mode = "char" })
    rex.client.queue("pane.copy_mode.exit")
    return result
  end

  -- host_run is a run on a pane of a Rex host; defined below, after press.
  local host_run

  rex.action{
    name = "rex_fingers",
    title = "Fingers: Copy by Hint",
    keywords = "copy hint path url sha tmux-fingers quick select",
    args = {
      patterns = "string?",
      main_action = "string?",
      shift_action = "string?",
      ctrl_action = "string?",
      alt_action = "string?",
      copy_command = "string?",
      scope = "string?",
      -- "mode", "reader", or "substitute": how a run on a host reads its
      -- keys, for a test; "mode" then runs with no app.
      keys = "string?",
      follow_scroll = "string?",
      -- "false" runs a pane of a Rex host without the agent, for a test.
      agent = "string?",
      -- A file with the rows a host's pane shows, for a test.
      view_file = "string?",
    },
    run = function(ctx, args)
      if not ctx.block_id then error("Fingers: no focused pane", 0) end
      local scope = args.scope or "pane"
      if scope ~= "pane" and scope ~= "window" then
        error("Fingers: scope must be \"pane\" or \"window\"", 0)
      end
      if scope == "window" and not in_pane_keys then
        error("Fingers: window scope needs overlay = \"pane\" or window_key", 0)
      end
      -- A pane on a Rex host: one guarded run per session.
      local host = remote_host(ctx.session_id)
      if host and (opts.overlay == "pane" or scope == "window") then
        return host_run(ctx, args, scope, host)
      end
      -- The key toggles: with hints already up in the pane, it puts the
      -- pane back.
      local active = state[ctx.block_id]
      if active then
        finish(ctx.block_id, active, true)
        return { closed = 1 }
      end
      -- With hints already up in a float, it sends that float Escape,
      -- which closes it and gives the pane focus back.
      local floats = open_floats(ctx.session_id, ctx.block_id)
      if #floats > 0 then
        for _, id in ipairs(floats) do
          rex.block.call(terminal, "write", { session_id = ctx.session_id, block_id = id, data = "\27" })
        end
        return { closed = #floats }
      end
      -- Window scope always draws in the panes: a float covers one pane,
      -- and only the in-pane keys let one key reach every pane.
      if opts.overlay == "pane" or scope == "window" then
        -- A run is left behind when the config reloads or the app
        -- restarts. draw --begin picks it up from the state the program
        -- kept, if the pane still shows its hints, and starts again from
        -- the pane as it was.
        -- rex do from a shell has origin "api" and no app to copy the
        -- rows, so it hints the live screen. follow_scroll = "true" on the
        -- call says an app is there, as with rex -C; "false" turns it
        -- off for one binding.
        local follow = opts.follow_scroll and ctx.origin ~= "api" and ctx.origin ~= "cli"
        if args.follow_scroll == "true" then follow = opts.follow_scroll end
        if args.follow_scroll == "false" then follow = false end
        -- A machine with no command that reads the clipboard cannot
        -- follow; the live screen is hinted then.
        if follow then
          local ok, result = pcall(follow_scroll, ctx, args, scope)
          if ok then return result end
          rex.log("warn", "Fingers: follow_scroll: " .. tostring(result))
        end
        return start(ctx, args, scope)
      end
      -- The float runs the program on the session's machine, where the
      -- binary path set here may not exist.
      if remote_host(ctx.session_id) then
        error("Fingers: overlay = \"float\" does not reach panes on a Rex host; use overlay = \"pane\"", 0)
      end
      local window_id, rect = locate(ctx.session_id, ctx.block_id)
      local layer, err = rex.session.new_layer{
        session_id = ctx.session_id,
        window_id = window_id,
        bounds = rect,
        focus = true,
        layout = rex.layout.block{
          flavor = terminal .. ".shell",
          label = "fingers",
          options = {
            command = command(opts, ctx, args),
            shell = opts.binary ~= "" and "none" or nil,
            exit = { on_completion = true },
          },
        },
      }
      if not layer then error(err, 0) end
      return { layer_id = layer.layer_id }
    end,
  }

  if opts.key then
    rex.bind(opts.key, "rex_fingers")
  end
  if opts.window_key then
    rex.bind(opts.window_key, "rex_fingers", { scope = "window" })
  end

  -- The in-pane keys, used by overlay = "pane" and by window scope under
  -- either overlay. They are function bindings with no key mode, so Rex
  -- lists no keys. Rex cannot bind a key while a run is active, so every
  -- key below is bound when the config loads. Each one checks for a run on
  -- the focused pane: with none it returns nothing, and Rex hands the key
  -- to the pane as if it were unbound.
  rex.action{
    name = "rex_fingers_cancel",
    title = "Fingers: Cancel",
    run = function(ctx)
      local run = state[ctx.block_id]
      if not run then pcall(recover_pane, opts, ctx) end
      finish(ctx.block_id, run, true)
    end,
  }

  -- handle sends one hint key to the program and acts on its answer.
  local function handle(ctx, run, key, mod)
    local argv = run.argv("press", currents(run))
    local r, err = exec(argv, "--typed", run.typed, "--key", key, "--modifier", mod,
                        "--session", run.session_id, "--block", run.origin)
    -- A program older than v0.4.2 rejects --session before it reads a
    -- file, so the same call without it still picks.
    if not r and tostring(err):find("flag provided but not defined: %-session") then
      rex.log("warn", "Fingers: rex-fingers is older than the plugin; build it again")
      r, err = exec(argv, "--typed", run.typed, "--key", key, "--modifier", mod)
    end
    if not r then error(err, 0) end
    -- A remote pane's repaint, or its restore and copy, reach it now.
    if run.writers then forward(run) end
    if not r.done then
      run.typed = r.typed or ""
      return
    end
    finish(ctx.block_id, run, false)
    if r.remote_path then rex.log("info", "Fingers: the path is on another machine; copied it instead") end
    if r.paste then
      local ok, perr = rex.block.call(terminal, "write",
        { session_id = ctx.session_id, block_id = run.origin or ctx.block_id, data = r.paste })
      if not ok then error(perr, 0) end
    end
    if r.error then error("Fingers: " .. r.error, 0) end
  end

  -- press runs a hint key and takes it. A key that lands while the
  -- previous one still runs is dropped, not raced, and also taken, so the
  -- letter does not reach the pane. A busy mark older than 5 seconds, the
  -- longest a key function runs, is stale.
  local function press(ctx, key, mod)
    local run = state[ctx.block_id]
    if not run then return nil end
    local now = os.time()
    if run.busy and now - run.busy < 5 then return true end
    run.busy = now
    local ok, err = pcall(handle, ctx, run, key, mod)
    run.busy = nil
    if not ok then
      rex.log("error", "Fingers: " .. tostring(err))
      if state[ctx.block_id] == run then pcall(finish, ctx.block_id, run, true) end
    end
    return true
  end

  -- A run on a pane of a Rex host. The app sends a host tab's plain keys
  -- to the host's server, where this plugin binds nothing. So a floating
  -- pane on the host, the reader, takes the focus and prints each key it
  -- is sent as two hex digits. The action stays alive, reads that pane,
  -- and presses each key as the key functions do on a local pane.
  --
  -- Rex stops an action after 30 seconds without running any more of it,
  -- so nothing here may count on its own cleanup:
  --   * a run ends by itself host_limit seconds after the trigger;
  --   * the reader ends itself after reader_lifetime seconds;
  --   * every trigger first closes the readers and writers it finds.
  -- Eight seconds: Rex for Mac snapshots 2107 and 2108 ended themselves
  -- each time a run on a host had been up for 10 to 14 seconds
  -- (2026-11-24).
  local host_limit, reader_lifetime = 8, 20
  -- The live run of each session, and when the last one ended.
  local host_runs, host_ended = {}, {}
  -- Readers of runs that ended. The app queues a trigger pressed during
  -- a run and sends it after the run, with the closed reader as its block.
  local closed_readers = {}
  -- Runs whose keys come from the key mode, per session; see agent_run.
  local host_modes = {}
  local host_mode = "rex_fingers"
  -- mode_off leaves the key mode. token names the file that tells the
  -- program's background copy the run is over.
  local function mode_off(client, token)
    if not client then return end
    local a = { binary(opts), "mode", "--client", client, "--off" }
    if token then a[#a + 1], a[#a + 2] = "--token", token end
    local ok, err = exec(a)
    if not ok then rex.log("warn", "Fingers: leaving the key mode: " .. tostring(err)) end
  end
  -- end_mode ends the run kept for a session, with a key or none.
  local function end_mode(sid, byte)
    local m = host_modes[sid]
    if not m then return nil end
    host_modes[sid] = nil
    local ok, result = pcall(m.finish, byte)
    mode_off(m.client, m.token)
    if not ok then error(result, 0) end
    return result
  end
  -- Sessions whose leftover writers were looked for since the config
  -- loaded. A writer is hidden, so finding one costs a round trip.
  local swept = {}

  -- host_scan reads the session once: its view, the layers that hold a
  -- reader, and whether block_id is a reader or a writer.
  local function host_scan(session_id, block_id)
    local view, err = rex.session.view{ session_id = session_id }
    if not view then error(err, 0) end
    local layers, ours = {}, false
    for _, w in ipairs(view.windows or {}) do
      for _, layer in ipairs(w.layers or {}) do
        for _, b in ipairs(layer.blocks or {}) do
          local mine = b.label == "fingers-reader" or b.label == "fingers-writer"
          if mine and b.block_id == block_id then ours = true end
          if b.label == "fingers-reader" and layer.kind ~= "tiled" then
            layers[#layers + 1] = layer.layer_id
          end
        end
      end
    end
    return view, layers, ours
  end

  -- rect_in finds a block's window and rectangle in a view already read.
  local function rect_in(view, block_id)
    for _, w in ipairs(view.windows or {}) do
      for _, layer in ipairs(w.layers or {}) do
        local r = rect_of(layer.layout, block_id)
        if r then
          if layer.kind ~= "tiled" and layer.bounds then
            local b = layer.bounds
            r = { b[1] + r[1] * b[3], b[2] + r[2] * b[4], r[3] * b[3], r[4] * b[4] }
          end
          return w.window_id, r
        end
      end
    end
  end

  -- reader_command asks the program for the reader's argv and the mark
  -- it prints first, once. The reader ends itself after reader_lifetime
  -- seconds, so one left behind does not keep the focus for good.
  local reader
  local function reader_command()
    if not reader then
      local r, err = exec({ binary(opts), "reader", "--lifetime", tostring(reader_lifetime) })
      if not r then error(err, 0) end
      reader = r
    end
    return reader
  end

  -- open_reader puts the reader at the pane's top right corner, a
  -- thousandth of the window in size: Rex refuses a float of no size or
  -- outside the window, and a minimized one loses the focus.
  local function open_reader(session_id, window_id, rect)
    local w, h = 0.001, 0.001
    local x = math.max(0, math.min(rect[1] + rect[3] - w, 1 - w))
    local y = math.max(0, math.min(rect[2], 1 - h))
    local layer, err = rex.session.new_layer{
      session_id = session_id,
      window_id = window_id,
      bounds = { x, y, w, h },
      focus = true,
      layout = rex.layout.block{
        flavor = terminal .. ".shell",
        label = "fingers-reader",
        options = {
          shell = "none",
          command = reader_command().command,
          exit = { on_completion = true },
        },
      },
    }
    if not layer then error(err, 0) end
    return layer
  end

  -- read_keys presses each key the reader shows, until the run ends, a
  -- second trigger cancels it, or the limit passes.
  local function read_keys(rec, run, pane)
    local sid = rec.session_id
    local target = { session_id = sid, block_id = pane }
    local seen = 0
    while state[pane] == run and not rec.cancel and os.time() < rec.deadline do
      local r = rex.block.call(terminal, "format",
        { session_id = sid, block_id = rec.reader, format = "text", unwrap = true, trim = true })
      -- The reader is gone: it ended itself, or somebody closed it.
      if not r then return end
      local hex = ((r.content or ""):match(reader.mark .. "(.*)") or ""):gsub("%s", "")
      local n = 0
      for pair in hex:gmatch("%x%x") do
        n = n + 1
        if n > seen then
          seen = n
          local b = tonumber(pair, 16)
          if b == 27 or b == 3 or b == 32 or b == 113 then
            return
          elseif b >= 97 and b <= 122 then
            press(target, string.char(b), "main")
          elseif b >= 65 and b <= 90 then
            press(target, string.char(b + 32), "shift")
          elseif b >= 1 and b <= 26 and b ~= 9 and b ~= 10 and b ~= 13 then
            press(target, string.char(b + 96), "ctrl")
          end
          if state[pane] ~= run or rec.cancel or os.time() >= rec.deadline then return end
        end
      end
      rex.exec({ "sleep", "0.05" }, { timeout = 1 })
    end
  end

  -- A run through the agent. Every call above is a round trip to the
  -- host, about ten before the hints show and five for a pick. The agent
  -- is a script the host's own rex runs, in a hidden block on the host,
  -- where its calls are local: it reads the panes, opens the reader,
  -- draws, reads the keys, and puts the panes back. This machine starts
  -- it, reads the panes from its screen, has the program make the frame,
  -- writes that to its terminal, and waits for the pick: three calls to
  -- the hints. internal/inpane/agent.lua is the script. Nothing is
  -- installed; a host whose blocks have no rex gets the run above.

  -- agent_command asks the program for the agent's argv and marks, once.
  local agent
  local function agent_command()
    if not agent then
      local r, err = exec({ binary(opts), "agent", "--lifetime", tostring(host_limit + 10) })
      if not r then error(err, 0) end
      agent = r
    end
    return agent
  end

  -- Hosts where the agent did not start.
  local no_agent = {}

  -- agent_message returns the message the agent printed under mark, or
  -- nil. The agent prints it as one word, each byte but letters and
  -- digits as %XX, so the terminal's wrapping cannot change it.
  local function agent_message(text, mark)
    local body = text:match(mark .. "<([^>]*)>")
    if not body then return nil end
    return rex.json.decode((body:gsub("%%(%x%x)", function(h) return string.char(tonumber(h, 16)) end)))
  end

  -- agent_send writes one message to the agent's terminal. Rex takes
  -- requests up to 1 MiB, so a large one goes in parts, cut between UTF-8
  -- characters.
  local function agent_send(sid, block, data)
    local i = 1
    while i <= #data do
      local j = math.min(#data, i + 262143)
      while j > i and j < #data and data:byte(j + 1) >= 0x80 and data:byte(j + 1) < 0xC0 do j = j - 1 end
      local ok, err = rex.block.call(terminal, "write", { session_id = sid, block_id = block, data = data:sub(i, j) })
      if not ok then error(err, 0) end
      i = j + 1
    end
  end

  local function temp_file(data)
    local path = os.tmpname()
    local f = assert(io.open(path, "w"))
    f:write(data)
    f:close()
    return path
  end

  -- host_view returns the rows the focused pane shows, or nil. The app
  -- copies them in copy mode, as for a local pane. There the copies are
  -- queued and run when the action has returned; on a host the action
  -- lives until the pick. And this action's Rex calls go to the host,
  -- where the app has another client ID. So the program asks the app, on
  -- this machine's server, and waits; it saves the clipboard and puts it
  -- back. The copy comes before the agent starts: its reader takes the
  -- focus, and copy mode acts on the focused pane.
  local function host_view(ctx)
    if not ctx.client_id then return nil end
    local path = os.tmpname()
    local t, err = exec({ binary(opts), "view", "--client", ctx.client_id, "--out", path })
    local text
    if t and t.view then
      local f = io.open(path, "rb")
      if f then
        text = f:read("*a")
        f:close()
      end
    end
    os.remove(path)
    if not t then error(err, 0) end
    if t.error then error(t.error, 0) end
    return text
  end

  -- agent_run returns the run's result, or nil when the host has no
  -- agent and the caller must run the reader and the writer.
  --
  -- With mode, the hint keys come from a key mode of the app, bound to
  -- rex_fingers_host_key below. The agent then opens no pane: its reader
  -- is a hidden block, and that action writes each key to it. The run is
  -- kept in host_modes, and this action returns once the hints are up.
  local function agent_run(ctx, args, scope, host, mode)
    local sid = ctx.session_id
    local command = agent_command()
    local argv = {}
    for _, a in ipairs(command.command) do argv[#argv + 1] = a end
    argv[#argv + 1] = host_endpoints[host] or ""
    argv[#argv + 1] = sid
    -- The rows a scrolled pane shows. The agent reads the pane's output
    -- down from that page, and the program draws the hints on it.
    local view
    local follow = opts.host_follow_scroll and ctx.origin ~= "api" and ctx.origin ~= "cli"
    if args.follow_scroll == "true" then follow = opts.host_follow_scroll end
    if args.follow_scroll == "false" then follow = false end
    if follow and not args.view_file and program_protocol >= 6 then
      local vok, v = pcall(host_view, ctx)
      if vok then view = v else rex.log("warn", "Fingers: follow_scroll on a host: " .. tostring(v)) end
    end
    if args.view_file then
      local vf = io.open(args.view_file, "rb")
      if vf then
        view = vf:read("*a")
        vf:close()
      end
    end
    -- The substitute, unless the call names another way to read the keys.
    local keys = mode and "hidden" or nil
    if not keys and (args.keys == "substitute" or (args.keys == nil and opts.host_keys == "substitute")) then
      keys = "substitute"
    end
    argv[#argv + 1] = rex.json.encode({ pane = ctx.block_id, scope = scope, limit = host_limit, reader = reader_command(), view = view, keys = keys })
    local b, err = rex.call("session.new_block", {
      session_id = sid,
      flavor = terminal .. ".shell",
      label = "fingers-agent",
      -- An agent that ends itself, at its lifetime, closes its block.
      options = { shell = "none", command = argv, exit = { on_completion = true } },
    })
    if not b then error(err, 0) end
    local block = b.block_id
    local function screen()
      local r = rex.block.call(terminal, "format", { session_id = sid, block_id = block, format = "text", unwrap = true, trim = true })
      return r and r.content
    end
    local function pause() rex.exec({ "sleep", "0.05" }, { timeout = 1 }) end

    -- Files of the run on this machine, removed when it ends.
    local files, keep = {}, false
    -- The agent's block is closed at the end, unless the agent still has
    -- panes to put back. It then ends itself, and its block with it: a
    -- close could come before it has written.
    local agent_ends_itself = false
    -- conclude waits for the agent's answer and ends the run; set once
    -- the frames are sent.
    local conclude
    local waiting = {}
    local function clear()
      if not keep then
        for _, path in ipairs(files) do os.remove(path) end
      end
      if not agent_ends_itself then pcall(rex.call, "block.close", { session_id = sid, block_id = block }) end
    end
    local ok, result = pcall(function()
      -- The panes, as the agent read them.
      local gathered
      local limit = os.time() + 3
      while not gathered do
        local text = screen()
        local early = text and agent_message(text, command.result)
        if early then
          if early.reader then closed_readers[early.reader] = true end
          if early.status == "failed" then error("Fingers: " .. tostring(early.error), 0) end
          return { ignored = 1 }
        end
        gathered = text and agent_message(text, command.gathered)
        if not gathered then
          -- No rex in the host's blocks, or one that cannot run the script.
          if not text or text:find(command.failed, 1, true) or text:find("Error:", 1, true) or os.time() > limit then
            rex.log("warn", "Fingers: no agent on the host, using the reader: " .. tostring(text):sub(1, 200))
            -- A block that is gone says nothing about the host.
            if text then no_agent[host] = true end
            return nil
          end
          pause()
        end
      end
      local origin = gathered.panes[1].block

      local specs, remotes = {}, {}
      for i, p in ipairs(gathered.panes) do
        local vt, text = temp_file(p.vt), temp_file(p.text)
        local file = remote_file(host, p.block)
        os.remove(file)
        files[#files + 1], files[#files + 2], files[#files + 3] = vt, text, file
        remotes[i] = file
        specs[i] = string.format("tty=%s,remote=true,vt=%s,text=%s,rows=%d,cols=%d,cursor=%s,wrap=%s",
          file, vt, text, p.rows, p.cols, tostring(p.cursor ~= false), tostring(p.wrap ~= false))
        if i == 1 and view then
          -- The program reads the file once, at the draw, and removes it.
          local page = temp_file(view)
          files[#files + 1] = page
          specs[i] = specs[i] .. ",view=" .. page
        end
      end
      local tail = { "--cwd", "" }
      option_flags(tail, opts, args)
      -- program_argv builds a call of the program on the run's panes;
      -- current is each pane's VT captured now, one path per pane.
      local function program_argv(sub, current)
        local a = { binary(opts), sub }
        for i, s in ipairs(specs) do
          a[#a + 1] = "--pane"
          a[#a + 1] = current and current[i] and (s .. ",current=" .. current[i]) or s
        end
        return a
      end
      local frames = os.tmpname()
      files[#files + 1] = frames
      local draw = program_argv("draw")
      table.insert(draw, 3, "--begin")
      table.insert(draw, 4, "--agent-file")
      table.insert(draw, 5, frames)
      local r, derr = exec(draw, unpack(tail))
      if not r or r.hints == 0 then
        -- The agent closes its reader a moment later and ends itself; a
        -- close of its block now would leave the reader up.
        agent_ends_itself = pcall(agent_send, sid, block, "END\n")
        if not r then error(derr, 0) end
        return { hints = 0 }
      end
      local f = assert(io.open(frames, "rb"))
      local data = f:read("*a")
      f:close()
      agent_send(sid, block, "RUN " .. #data .. "\n" .. data)
      -- From here the agent puts the panes back, closes its reader, and
      -- ends itself, also when this action fails or is stopped. A close
      -- of its block now could leave hints up, or a pane out of its
      -- window. A run in the key mode is ended by finish, below.
      if not mode then agent_ends_itself = true end
      conclude = function()
      -- The pick, or how the run ended. The agent ends the run by itself
      -- at host_limit.
      local res
      local deadline = os.time() + host_limit + 4
      if mode then deadline = os.time() + 3 end
      while not res and os.time() < deadline do
        local text = screen()
        if not text then break end
        res = agent_message(text, command.result)
        if not res then pause() end
      end
      if not res then
        -- No answer: the agent is gone with the hints up, or the calls to
        -- the host no longer pass. The files stay: the next draw --begin
        -- starts from the state the program kept. An agent still there
        -- puts the panes back at its limit.
        keep = true
        agent_ends_itself = true
        error("Fingers: the run on the host ended without an answer", 0)
      end

      -- The reader is closed. A trigger pressed during the run arrives
      -- now, with the reader as its block, and starts nothing.
      if res.reader then closed_readers[res.reader] = true end
      -- A substitute holds the pane's place. The agent puts the pane
      -- back and then ends itself; a close now would leave the pane out
      -- of its window.
      -- The same for a reader, which the agent closes a moment after
      -- its report. BYE tells the agent that the report was read; for a
      -- pane that wrote during the run it follows the rows, below.
      if res.returning then
        agent_ends_itself = true
        if not res.dirty then pcall(agent_send, sid, block, "BYE\n") end
      end
      -- The agent has put the panes back, unless one wrote during the
      -- run. Then it sent each pane's screen as it is now, the program
      -- works out the rows to repaint, and the agent writes them.
      local current
      if res.dirty and res.current then
        current = {}
        for i, vt in ipairs(res.current) do
          current[i] = temp_file(vt)
          files[#files + 1] = current[i]
        end
      end
      local out
      if res.status == "pick" and res.hint then
        out, derr = exec(program_argv("press", current), "--typed", res.hint:sub(1, -2), "--key", res.hint:sub(-1),
          "--modifier", res.modifier, "--session", sid, "--block", origin, unpack(tail))
      else
        out, derr = exec(program_argv("restore", current), unpack(tail))
      end
      if res.dirty then
        -- The agent waits for these. With none sent, it writes the
        -- restores it has when its wait is over.
        agent_ends_itself = true
        local sent = false
        for i, file in ipairs(remotes) do
          local rf = io.open(file, "rb")
          if rf then
            local bytes = rf:read("*a")
            rf:close()
            if #bytes > 0 then
              sent = pcall(agent_send, sid, block, "W " .. (i - 1) .. " " .. #bytes .. "\n" .. bytes) or sent
            end
          end
        end
        -- An agent with a pane to put back waits for this word before
        -- it does, also when no pane had rows to repaint.
        if sent or res.returning then pcall(agent_send, sid, block, "BYE\n") end
      end
      if not out then error(derr, 0) end
      if res.error then error("Fingers: " .. res.error, 0) end
      if out.remote_path then rex.log("info", "Fingers: the path is on another machine; copied it instead") end
      if out.paste and not res.pasted then
        local wrote, werr = rex.block.call(terminal, "write", { session_id = sid, block_id = origin, data = out.paste })
        if not wrote then error(werr, 0) end
      end
      if out.error then error("Fingers: " .. out.error, 0) end
      return { hints = r.hints, panes = #specs, status = res.status }
      end
      if mode then
        local hints = {}
        for _, t in ipairs((rex.json.decode(data) or {}).targets or {}) do hints[#hints + 1] = t.hint end
        waiting = { reader = gathered.reader, hints = hints, typed = "", deadline = os.time() + host_limit }
        return { hints = r.hints, panes = #specs, keys = "mode" }
      end
      -- The agent gave the reader the session's focus from its own
      -- connection, and the app has still sent the hint letters to the
      -- pane, on the first run in a new pane. This call goes through the
      -- app, as the reader's did when this plugin opened it, so the app
      -- makes the change itself. The hints are up by now; it adds no wait
      -- before them. A reader already closed makes it fail, which is fine.
      rex.session.focus_block{ session_id = sid, block_id = gathered.reader }
      return conclude()
    end)
    if ok and mode and waiting.reader then
      -- The run goes on without this action. finish ends it: with a
      -- key, the last of a hint or one that cancels, or with none when
      -- the run is over its limit.
      waiting.finish = function(byte)
        if byte then pcall(rex.block.call, terminal, "write", { session_id = sid, block_id = waiting.reader, data = byte }) end
        local fok, fres = pcall(conclude)
        clear()
        if not fok then error(fres, 0) end
        return fres
      end
      waiting.type = function(byte)
        rex.block.call(terminal, "write", { session_id = sid, block_id = waiting.reader, data = byte })
      end
      host_modes[sid] = waiting
      return result
    end
    clear()
    if not ok then error(result, 0) end
    return result
  end

  host_run = function(ctx, args, scope, host)
    local started = os.time()
    local sid, pane = ctx.session_id, ctx.block_id
    -- Rex runs one action of this config at a time: a trigger pressed
    -- during a run waits until the run has ended, and arrives then. In
    -- the app it carries the closed reader as its block. It starts
    -- nothing, or ten fast presses would give ten runs.
    -- The trigger closes a run whose keys come from the key mode: its
    -- action has ended, so this one is not held up behind it.
    if host_modes[sid] then
      end_mode(sid, "\27")
      return { closed = 1 }
    end
    if closed_readers[pane] or host_ended[sid] == started then return { ignored = 1 } end
    -- A binary without --remote would fail at the first draw, with a
    -- usage message.
    if program_protocol < 4 then
      error("Fingers: rex-fingers is older than the plugin and cannot reach panes on a Rex host; build it again", 0)
    end
    -- The agent first. A host without one gets the reader and the writer
    -- below, as does a program too old to make the agent's frames.
    if program_protocol >= 5 and not no_agent[host] and args.agent ~= "false" and not host_runs[sid] then
      -- The key mode, when the app can be asked for it: a key press has
      -- an app behind it, rex do from a shell has none. keys = "mode" on
      -- the call runs without the app, for a test.
      local mode, client, token = false, nil, nil
      if program_protocol >= 7 and args.keys ~= "reader" then
        if args.keys == "mode" then
          mode = true
        elseif opts.host_keys == "mode" and ctx.client_id and ctx.origin ~= "api" and ctx.origin ~= "cli" then
          -- First, so that a key typed before the hints show is taken.
          local m, merr = exec({ binary(opts), "mode", "--client", ctx.client_id, "--on", "--name", host_mode,
            "--limit", tostring(host_limit + 1) })
          if m and m.mode then
            mode, client, token = true, ctx.client_id, m.token
          else
            rex.log("warn", "Fingers: no key mode, using the reader: " .. tostring(merr))
          end
        end
      end
      local ok, result = pcall(agent_run, ctx, args, scope, host, mode)
      if mode then
        local m = host_modes[sid]
        if m then
          m.client, m.token = client, token
        else
          mode_off(client, token)
        end
      end
      -- A run in the key mode is still up, and the next trigger closes it.
      if not host_modes[sid] then host_ended[sid] = os.time() end
      if not ok then error(result, 0) end
      if result then return result end
    end
    -- Claim the session before the first call that waits.
    -- A record still here is of a run Rex stopped: past 30 seconds, or
    -- when the app went away. Its panes still show hints; draw --begin
    -- starts again from the state the program kept. Its reader may hold
    -- the focus, so the trigger arrives on the reader: the run is then
    -- for the pane the dead run was on.
    local dead = host_runs[sid]
    local rec = { session_id = sid, started = started, deadline = started + host_limit }
    host_runs[sid] = rec
    if dead then
      dead.cancel = true
      for _, id in ipairs((dead.run and dead.run.blocks) or {}) do state[id] = nil end
      if dead.reader == pane and dead.pane then
        pane = dead.pane
        ctx = { session_id = sid, block_id = pane, origin = ctx.origin }
      end
    end
    rec.pane = pane

    local run
    local ok, result = pcall(function()
      -- Leftovers of a run that died: readers first, as one may hold the
      -- focus.
      local view, layers, ours = host_scan(sid, pane)
      for _, id in ipairs(layers) do
        pcall(rex.session.close_layer, { session_id = sid, layer_id = id })
      end
      -- Never hint a reader or a writer.
      if ours then
        close_leftover_writers(sid)
        return { closed = #layers }
      end
      local window_id, rect = rect_in(view, pane)
      if not window_id then return { ignored = 1 } end
      -- The reader opens before the hints are drawn, so a key typed early
      -- waits in it and does not reach the pane's program.
      local layer = open_reader(sid, window_id, rect)
      rec.layer, rec.reader = layer.layer_id, layer.block_ids[1]
      -- A writer is left only by a run that died: one on record here, one
      -- whose reader was just found, or one from before the config loaded.
      if dead or #layers > 0 or not swept[sid] then close_leftover_writers(sid) end
      swept[sid] = true
      writer_deadline = rec.deadline - 3
      local drawn = start(ctx, args, scope, host)
      run = state[pane]
      rec.run = run
      if run then run.keep_writers = true end
      if run and (drawn.hints or 0) > 0 then read_keys(rec, run, pane) end
      return drawn
    end)

    -- The end of every run, also after an error. Each step is on its own,
    -- so one that fails does not skip the next.
    -- The order is what the user waits for: the pane as it was, then the
    -- focus, and last the hidden writers.
    if run and state[pane] == run then pcall(finish, pane, run, true) end
    if rec.layer then
      closed_readers[rec.reader] = true
      pcall(rex.session.close_layer, { session_id = sid, layer_id = rec.layer })
      pcall(rex.session.focus_block, { session_id = sid, block_id = pane })
    end
    if run and run.writers then close_writers(run) end
    if host_runs[sid] == rec then host_runs[sid] = nil end
    host_ended[sid] = os.time()
    if not ok then error(result, 0) end
    return result
  end

  -- The hint keys of a run on a host, bound in the key mode. The agent
  -- reads them from its hidden reader: a letter, a capital for Shift, a
  -- control byte for Ctrl. Only the last key of a hint and a key that
  -- cancels wait for the agent's answer; the copy, or whatever the
  -- action is, then runs here.
  rex.action{
    name = "rex_fingers_host_key",
    title = "Fingers: Hint Key on a Host",
    args = { key = "string", modifier = "string?" },
    run = function(ctx, args)
      local sid = ctx.session_id
      local m = host_modes[sid]
      if not m then
        -- The mode is on with no run here: the user went to another
        -- session, or the run was lost with the config. End what is up.
        local ended = 0
        for other in pairs(host_modes) do
          pcall(end_mode, other, "\27")
          ended = ended + 1
        end
        if ended == 0 then mode_off(ctx.client_id) end
        return { ignored = 1 }
      end
      if os.time() >= m.deadline then return end_mode(sid) end
      local key, mod = args.key, args.modifier or "main"
      if key == "escape" then return end_mode(sid, "\27") end
      local longer, final, continues = m.typed .. key, false, false
      for _, hint in ipairs(m.hints) do
        if hint == longer then final = true elseif hint:sub(1, #longer) == longer then continues = true end
      end
      if not final and not continues then return { ignored = 1 } end
      local byte = key
      if mod == "shift" then byte = key:upper() elseif mod == "ctrl" then byte = string.char(key:byte() - 96) end
      if final then return end_mode(sid, byte) end
      m.typed = longer
      m.type(byte)
      return { typed = longer }
    end,
  }

  -- cancel puts the pane back and takes the key.
  local function cancel(ctx)
    local run = state[ctx.block_id]
    if not run then return nil end
    pcall(finish, ctx.block_id, run, true)
    return true
  end

  -- swallow takes a key during a run, so it does not type into the pane.
  local function swallow(ctx)
    if state[ctx.block_id] then return true end
    return nil
  end

  -- A float with no window key reads its own keys, so nothing below is
  -- bound and no key the user types passes through Lua.
  if not in_pane_keys then return end

  -- Never bind a key that starts or ends a sequence: tmux's prefix, or the
  -- keys that open fingers.
  local reserved = { ["ctrl+b"] = true }
  if opts.key then reserved[opts.key] = true end
  if opts.window_key then reserved[opts.window_key] = true end
  local function bind_key(key, fn)
    if not reserved[key] then rex.bind(key, fn) end
  end

  -- A modifier gets a hint binding only when its action is set. Every
  -- layout leaves out c, i, m, q, and n. A key that is no hint is not
  -- bound: a bound key does not return a scrolled pane to its last row
  -- (REX-FACTS.md), so during a run it types into the pane instead.
  local mods = { { "", "main" } }
  for _, m in ipairs({ { "shift+", "shift" }, { "ctrl+", "ctrl" }, { "alt+", "alt" } }) do
    if opts[m[2] .. "_action"] ~= "" then mods[#mods + 1] = m end
  end
  local hinted = {}
  for key in (opts.alphabet ~= "" and opts.alphabet or "abdefghjkloprstuvwxyz"):gmatch("%w") do
    hinted[key:lower()] = true
  end
  for key in ("abcdefghijklmnopqrstuvwxyz"):gmatch(".") do
    if hinted[key] then
      for _, m in ipairs(mods) do
        if not (key == "q" and m[2] == "main") and not (key == "c" and m[2] == "ctrl") then
          bind_key(m[1] .. key, function(ctx) return press(ctx, key, m[2]) end)
        end
      end
    end
  end
  -- Space closes the hints too: typed during a run, it went to the
  -- program unseen under a scrolled page. Bound, it does not return a
  -- scrolled pane when no run is up.
  for _, key in ipairs({ "escape", "q", "ctrl+c", "space" }) do bind_key(key, cancel) end

  -- The same keys in the key mode of a run on a host. The mode is
  -- exclusive: a key it does not bind does nothing while the hints are
  -- up, so none reaches the pane's program. The trigger closes the hints.
  if opts.host_keys == "mode" then
    rex.mode(host_mode, { exclusive = true })
    local function mode_bind(key, name, modifier)
      rex.bind(host_mode .. "/" .. key, "rex_fingers_host_key", { key = name, modifier = modifier })
    end
    for key in ("abcdefghijklmnopqrstuvwxyz"):gmatch(".") do
      if hinted[key] then
        for _, m in ipairs(mods) do
          if m[2] ~= "alt" and not (key == "q" and m[2] == "main") and not (key == "c" and m[2] == "ctrl") then
            mode_bind(m[1] .. key, key, m[2])
          end
        end
      end
    end
    for _, key in ipairs({ "escape", "q", "ctrl+c", "space", opts.key, opts.window_key }) do
      if key then mode_bind(key, "escape") end
    end
  end
  -- Enter stays taken: one that reached the pane would run the prompt.
  bind_key("enter", swallow)
end

return M
