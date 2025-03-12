local wezterm = require "wezterm"


local module = {}

local data_dir = (os.getenv("XDG_DATA_HOME") or wezterm.home_dir .. "/.local/share") .. "/wezterm/"
local pidfile_path = data_dir .. "wuake_pid"
local last_exit_path = data_dir .. "wuake_last_exit"
local pid = wezterm.procinfo.pid()


-- returns file content as string or nil if file doesn't exist
local function read_file(file_path)
  local f = io.open(file_path)
  if f ~= nil then
    local s = f:read()
    f:close()
    return s
  end
end


local function write_file(file_path, s)
  local f = io.open(file_path, "w")
  f:write(s)
  f:close()
end


local function read_pidfile()
  return read_file(pidfile_path)
end


local function log_pidfile()
  wezterm.log_info("pid: " .. (read_pidfile() or "nil"))
end


local function write_pidfile()
  return write_file(pidfile_path, pid)
end


function module.setup(params)
  local default_params = {
    margin_left = 0,
    margin_top = 0,
    -- it is recommended to set either these two or width_factor and height_factor, otherwise
    -- they might not behave in the way you expect.
    margin_right = 0,
    margin_bottom = 0,
    -- width multiplier (1 = 100%)
    width_factor = 1,
    -- height multiplier default: (50% if margin_bottom is unset, else 100%)
    height_factor = params.margin_bottom and 1 or 0.5,
    -- name of the unix domain that wuake is associated with
    domain = "wuake",
    -- whether to create a unix domain. defaults to true except if domain was explicitly set
    create_unix_domain = not params.domain,
    -- config overrides for the dropdown window
    config_overrides = {},
  }

  for key, value in pairs(default_params) do
    params[key] = params[key] or value
  end

  if params.create_unix_domain then
    params.config.unix_domains = params.config.unix_domains or {}
    table.insert(params.config.unix_domains, {
      name = params.domain
    })
  end

  local function close_dropdown()
    log_pidfile()
    wezterm.log_info("wuake done")
    -- write unix timestamp with high precision to file so we can check if wuake just exited
    -- because the new invocation stole focus
    write_file(last_exit_path, wezterm.time.now():format("%s%.f"))
    -- faster and more reliable than wezterm.mux.get_domain(params.domain):detach():
    os.exit()
  end

  -- update-status is fired earlier than gui-attached and thus is a tiny bit faster
  -- also it directly gives us access to the window object
  wezterm.on("update-status", function(window)
    -- wezterm.log_info("update status: " .. wezterm.procinfo.pid() .. " " .. window:active_pane():get_domain_name())
    -- run setup once per process
    if wezterm.GLOBAL.wuake_setup_done then return end
    -- don't run on normal windows
    -- checking argv is faster than checking window:active_pane():get_domain_name()
    local this_proc_info = wezterm.procinfo.get_info_for_pid(pid)
    if this_proc_info.argv[2] ~= "connect" or this_proc_info.argv[3] ~= params.domain then
      wezterm.log_info("not a wuake window")
    else
      local now = tonumber(wezterm.time.now():format("%s%.f"))
      local pid_info = wezterm.procinfo.get_info_for_pid(read_pidfile() or 0)
      -- wezterm.log_info(pid_info or "pid_info: nil")
      local last_exit = read_file(last_exit_path)
      -- wezterm.log_info("now: " .. now .. " last exit: " .. (last_exit or "nil"))
      -- if no dropdown is open or was open in the last 500ms
      if (
        not (
          pid_info
          and pid_info.name == "wezterm-gui"
        ) and (
          last_exit
          and now - 0.5 > tonumber(last_exit)
        )
      ) then
        wezterm.log_info("starting wuake...")
        write_pidfile()

        local screens = wezterm.gui.screens()
        window:set_position(screens.active.x + params.margin_right, screens.active.y + params.margin_top)
        window:set_inner_size(
          screens.active.width * params.width_factor - params.margin_right - params.margin_left,
          screens.active.height * params.height_factor - params.margin_bottom - params.margin_top
        )

        window:set_config_overrides(params.config_overrides)
      else
        os.remove(pidfile_path)
        close_dropdown()
      end
    end

    wezterm.GLOBAL.wuake_setup_done = true
  end)

  wezterm.on("window-focus-changed", function(window, pane)
    if pane:get_domain_name() == params.domain and not window:is_focused() then
      wezterm.log_info("wuake: focus lost")
      close_dropdown()
    end
  end)
end

return module

