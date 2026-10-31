-- Helpers for init.lua that inspect and rearrange terminal panes.

local M = {}

M.terminal = "com.superlogical.terminal"
M.shell = "com.superlogical.terminal.shell"

local function foreground(block_id)
  local p = rex.block.call(M.terminal, "process", { block_id = block_id })
  return p and p.foreground
end

-- Rex can't see smart-splits' IS_NVIM user var, so check the foreground process instead.
function M.focused_nvim(block_id)
  local fg = foreground(block_id)
  return fg ~= nil and fg.name == "nvim"
end

-- Working directory of the foreground process, like kitty's --cwd=current.
function M.cwd(block_id)
  local fg = foreground(block_id)
  return fg and fg.cwd
end

-- ─── Resize ──────────────────────────────────────────────────────────────────

-- Splits from the layer root down to block_id, each with the side it's on.
local function split_path(node, block_id, path)
  if node.block_id then
    return node.block_id == block_id and path or nil
  end
  for _, side in ipairs({ "before", "after" }) do
    table.insert(path, { node = node, side = side })
    if split_path(node.split[side], block_id, path) then
      return path
    end
    table.remove(path)
  end
end

local function leaf(node, block_id)
  if node.block_id then
    return node.block_id == block_id and node or nil
  end
  return leaf(node.split.before, block_id) or leaf(node.split.after, block_id)
end

local function first_block(node)
  return node.block_id or first_block(node.split.before)
end

-- Moves the nearest border on the direction's axis by `amount` cells, the same
-- way relative_resize.py did for kitty. Returns false when there is nothing to
-- resize: no split on that axis, or the pane is zoomed.
function M.resize(block_id, direction, amount)
  local view = rex.session.view{}
  if view == nil then
    return false
  end

  for _, window in ipairs(view.windows) do
    for _, layer in ipairs(window.layers) do
      local path = split_path(layer.layout, block_id, {})
      if path then
        if window.zoomed_block_id ~= nil then
          return false
        end

        local axis = (direction == "left" or direction == "right") and "horizontal" or "vertical"
        local size = rex.block.call(M.terminal, "size", { block_id = block_id })
        local rect = leaf(layer.layout, block_id).rect
        for i = #path, 1, -1 do
          local node, side = path[i].node, path[i].side
          if node.split.direction == axis then
            -- rects are fractions of the window, so scale cells by the split's share of it
            local cells, pane_frac, split_frac
            if axis == "horizontal" then
              cells, pane_frac, split_frac = size.columns, rect[3], node.rect[3]
            else
              cells, pane_frac, split_frac = size.rows, rect[4], node.rect[4]
            end
            local delta = amount * pane_frac / (cells * split_frac)
            if direction == "left" or direction == "up" then
              delta = -delta
            end
            local ratio = math.min(0.95, math.max(0.05, node.split.ratio + delta))

            local before, after
            if side == "before" then
              before, after = block_id, first_block(node.split.after)
            else
              before, after = first_block(node.split.before), block_id
            end
            rex.session.resize_pane{
              direction = axis,
              before_block_id = before,
              after_block_id = after,
              ratio = ratio,
            }
            return true
          end
        end
        return false
      end
    end
  end
  return false
end

-- ─── Scrollback ──────────────────────────────────────────────────────────────

-- The terminal's screen and scrollback as plain text.
function M.scrollback(block_id)
  local max = 983040
  local r, err = rex.block.call(M.terminal, "format", {
    block_id = block_id, trim = true, unwrap = true, max_bytes = max,
  })
  if r == nil then
    return nil, err
  end
  -- an id means the output didn't fit in one reply; read the rest in parts
  local parts, offset, id = { r.content }, #r.content, r.id
  while id ~= nil do
    r, err = rex.block.call(M.terminal, "blob_read", {
      block_id = block_id, id = id, offset = offset, max_bytes = max,
    })
    if r == nil then
      return nil, err
    end
    table.insert(parts, r.data)
    offset = offset + #r.data
    if r.eof then
      break
    end
  end
  return (table.concat(parts):gsub("%s+$", "")) .. "\n"
end

return M
