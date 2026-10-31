-- Rex keybindings, ported from config/kitty/kitty.conf.
-- Fonts, theme and tab style are app settings (Settings…), not init.lua.
-- Apply changes with ctrl+y>R or `rex config reload`.

local panes = require("panes")

-- ─── Pane navigation (Ctrl + j/k/l/;) ────────────────────────────────────────
-- j=left, k=bottom, l=top, ;=right
-- In nvim the key passes through to smart-splits.nvim, which runs `rex focus`
-- once it hits the edge of its own splits (config/nvim/lua/config/init.lua).
local nav_keys = { ["ctrl+j"] = "left", ["ctrl+k"] = "down", ["ctrl+l"] = "up", ["ctrl+;"] = "right" }
for key, direction in pairs(nav_keys) do
  rex.bind(key, function(ctx)
    if panes.focused_nvim(ctx.block_id) then
      return false
    end
    rex.session.focus_direction{ direction = direction }
    return true
  end)
end

-- ─── Pane resize (Alt + j/k/l/;) ─────────────────────────────────────────────
-- Passes through to smart-splits.nvim in nvim, like navigation.
-- alt+l: with no split to resize, type ł instead (Option+l on the Polish layout)
local resize_keys = { ["alt+j"] = "left", ["alt+k"] = "down", ["alt+l"] = "up", ["alt+;"] = "right" }
local fallback_text = { ["alt+l"] = "ł" }
for key, direction in pairs(resize_keys) do
  rex.bind(key, function(ctx)
    if panes.focused_nvim(ctx.block_id) then
      return false
    end
    if not panes.resize(ctx.block_id, direction, 3) and fallback_text[key] then
      rex.block.call(panes.terminal, "write", { block_id = ctx.block_id, data = fallback_text[key] })
    end
    return true
  end)
end

-- ─── Actions ─────────────────────────────────────────────────────────────────

rex.action{
  name  = "split_here",
  title = "Split Pane in Current Directory",
  args  = { direction = "string", size = "number?" },
  run   = function(ctx, args)
    local axis = (args.direction == "left" or args.direction == "right") and "horizontal" or "vertical"
    local side = (args.direction == "right" or args.direction == "down") and "after" or "before"
    -- size is the new pane's share; ratio is the before part's share
    local size = args.size or 0.5
    local _, err = rex.session.new_split{
      anchor_id = ctx.block_id,
      direction = axis,
      side      = side,
      ratio     = side == "after" and 1 - size or size,
      focus     = true,
      layout    = rex.layout.block{
        flavor  = panes.shell,
        options = { cwd = panes.cwd(ctx.block_id) },
      },
    }
    if err ~= nil then error(err, 0) end
  end,
}

-- Floating lazygit; closes when lazygit exits
rex.action{
  name  = "lazygit",
  title = "Lazygit",
  run   = function(ctx)
    local _, err = rex.session.new_layer{
      bounds = { 0.05, 0.05, 0.9, 0.9 },
      focus  = true,
      layout = rex.layout.block{
        flavor  = panes.shell,
        options = { command = { "lazygit" }, cwd = panes.cwd(ctx.block_id) },
      },
    }
    if err ~= nil then error(err, 0) end
  end,
}

-- Scrollback in nvim, replacing kitty-scrollback.nvim
rex.action{
  name  = "scrollback_nvim",
  title = "Browse Scrollback in Neovim",
  run   = function(ctx)
    local text, err = panes.scrollback(ctx.block_id)
    if text == nil then error(err, 0) end
    local id = (ctx.block_id or "pane"):gsub("^block:", "")
    local path = (os.getenv("TMPDIR") or "/tmp/") .. "rex-scrollback-" .. id .. ".txt"
    local f = assert(io.open(path, "w"))
    f:write(text)
    f:close()

    local _, err2 = rex.session.new_layer{
      bounds = { 0, 0, 1, 1 },
      focus  = true,
      layout = rex.layout.block{
        flavor  = panes.shell,
        options = { command = { "nvim", "+", path }, cwd = panes.cwd(ctx.block_id) },
      },
    }
    if err2 ~= nil then error(err2, 0) end
  end,
}

-- Rex's session.previous goes by list order. Remember the session we left
-- instead, like kitty's goto_session -1 (only switches made with these keys).
local last_session
rex.action{
  name  = "switch_session",
  title = "Change Session (Remember Last)",
  run   = function(ctx)
    last_session = ctx.session_id
    rex.client.queue("session.switch")
  end,
}
rex.action{
  name  = "last_session",
  title = "Go to Last Session",
  run   = function(ctx)
    if last_session == nil or last_session == ctx.session_id then
      return
    end
    local target = last_session
    last_session = ctx.session_id
    rex.client.queue("session.select", { session_id = target })
  end,
}

-- ─── Leader key bindings (Ctrl+Y prefix) ─────────────────────────────────────

-- Pane splitting (in the current directory)
rex.bind("ctrl+y>v", "split_here", { direction = "right" })
rex.bind("ctrl+y>h", "split_here", { direction = "down" })
rex.bind("ctrl+y>shift+h", "split_here", { direction = "down", size = 0.3 })

-- Pane zoom
rex.bind("ctrl+y>z", "pane.zoom")

-- Close pane / tab
rex.bind("ctrl+y>w", "pane.close")
rex.bind("ctrl+y>shift+w", "client.tab.close")

-- Config reload
rex.bind("ctrl+y>shift+r", "client.config.reload")

-- Sessions
rex.bind("ctrl+y>s", "switch_session")
rex.bind("ctrl+y>-", "last_session")

-- Scrollback in nvim
rex.bind("ctrl+y>enter", "scrollback_nvim")
rex.bind("ctrl+shift+h", "scrollback_nvim")

-- Lazygit
rex.bind("ctrl+y>g", "lazygit")

-- Rotate through panes
rex.bind("ctrl+y>space", "pane.focus_next")

-- Send Ctrl+A (e.g. for nested tmux)
rex.bind("ctrl+y>ctrl+a", "pane.send_key", { key = "ctrl+a" })

-- Command palette
rex.bind("cmd+shift+p", "client.palette.toggle")
