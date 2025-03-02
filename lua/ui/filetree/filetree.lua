--[[
it works i gues
lmao

]]

local api = vim.api
local fn = vim.fn

local M = {}

local b = nil
local w = nil
local lw = nil
local ds = {}
local fp = {}


local function cb()
  b = api.nvim_create_buf(false, true)
  api.nvim_buf_set_option(b, 'bufhidden', 'wipe')
  api.nvim_buf_set_option(b, 'filetype', 'filetree')


  vim.keymap.set('n', '<CR>', function()
    require("ui.filetree.filetree").toggle_item()
  end, { buffer = b, noremap = true, silent = true })

  vim.keymap.set('n', 'q', function()
    require("ui.filetree.filetree").close()
  end, { buffer = b, noremap = true, silent = true })
end

local function cw()
  lw = api.nvim_get_current_win()

  vim.cmd('vsplit')
  w = api.nvim_get_current_win()

  api.nvim_win_set_buf(w, b)
  api.nvim_win_set_option(w, 'number', false)
  api.nvim_win_set_option(w, 'relativenumber', false)
  api.nvim_win_set_width(w, 30)
end

local function gdc(p)
  local c = {}
  local h = vim.loop.fs_scandir(p)

  while h do
    local n, t = vim.loop.fs_scandir_next(h)
    if not n then break end

    table.insert(c, {
      name = n,
      type = t,
      path = p .. '/' .. n
    })
  end

  table.sort(c, function(a, b)
    if a.type == b.type then
      return a.name < b.name
    end
    return a.type == 'directory'
  end)

  return c
end

local function ah(l, s)
  for i, ln in ipairs(l) do
    local n = s + i - 1
    if ln:match("^%s*") then
      if ln:match("") then
        vim.api.nvim_buf_add_highlight(b, -1, "FileTreeExpandedDirectory", n, 0, -1)
      elseif ln:match("") then
        vim.api.nvim_buf_add_highlight(b, -1, "FileTreeDirectory", n, 0, -1)
      else
        vim.api.nvim_buf_add_highlight(b, -1, "FileTreeFile", n, 0, -1)
      end
    end
  end
end

local function rd(p, l, ls, ps)
  local c = gdc(p)
  local i = string.rep("  ", l)

  for _, it in ipairs(c) do
    local d = it.type == 'directory'
    local ic = d and (ds[it.path] and "📂" or "📁") or "📄"
    local ln = i .. ic .. " " .. it.name

    table.insert(ls, ln)
    table.insert(ps, it.path)

    if d and ds[it.path] then
      rd(it.path, l + 1, ls, ps)
    end
  end
end

local function rt()
  local l = {}
  fp = {}

  rd(fn.getcwd(), 0, l, fp)

  api.nvim_buf_clear_namespace(b, -1, 0, -1)
  api.nvim_buf_set_lines(b, 0, -1, false, l)
  ah(l, 0)
end

function M.toggle_item()
  local c = api.nvim_win_get_cursor(w)
  local cl = c[1]
  local p = fp[cl]

  if fn.isdirectory(p) == 1 then
    ds[p] = not ds[p]
    rt()
    api.nvim_win_set_cursor(w, c)
  else
    if lw and api.nvim_win_is_valid(lw) then
      api.nvim_set_current_win(lw)
      vim.cmd('edit ' .. fn.fnameescape(p))
    else
      local ws = api.nvim_list_wins()
      for _, win in ipairs(ws) do
        if win ~= w then
          api.nvim_set_current_win(win)
          vim.cmd('edit ' .. fn.fnameescape(p))
          break
        end
      end
    end
  end
end

function M.toggle()
  if w and api.nvim_win_is_valid(w) then
    M.close()
  else
    M.open()
  end
end

function M.open()
  if not b or not api.nvim_buf_is_valid(b) then
    cb()
  end

  if not w or not api.nvim_win_is_valid(w) then
    cw()
  end

  rt()
end

function M.close()
  if w and api.nvim_win_is_valid(w) then
    api.nvim_win_close(w, true)
    w = nil
  end
end

return M
