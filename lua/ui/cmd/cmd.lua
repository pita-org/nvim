local M = {}
local api = vim.api
local buf, win

-- local function setup_highlights()
--   api.nvim_set_hl(0, 'MyCmdLineBorder', {
--     fg = '#83a5ba',
--     bg = '#111111',
--     bold = true
--   })
--   api.nvim_set_hl(0, 'MySearchBackground', {
--     bg = '#111111'
--   })
--   api.nvim_set_hl(0, 'MyCmdLineTitle', {
--     bg = "#111111",
--     fg = "#83a5ba",
--     bold = true,
--   })
--   api.nvim_set_hl(0, 'CmdLinePrefix', {
--     fg = '#83a5ba',
--     bold = true
--   })
-- end


function _G.create_float()
  buf = api.nvim_create_buf(false, true)
  local width = api.nvim_get_option("columns")
  local height = api.nvim_get_option("lines")

  local win_height = 1
  local win_width = 40
  local row = math.floor((height - win_height) / 2)
  local col = math.floor((width - win_width) / 2)

  local opts = {
    relative = "editor",
    width = 40,
    height = 1,
    row = 3,
    col = col,
    style = 'minimal',
    title = "Commands ",
    title_pos = 'left',
    border = {
      { " ", "MySearchBackground" },
      { " ", "MyFloatBorder" },
      { " ", "MyFloatBorder" },
      { " ", "MySearchBackground" },
      { " ", "MySearchBackground" },
      { " ", "MySearchBackground" },
      { " ", "MySearchBackground" },
      { " ", "MySearchBackground" },
    }
  }

  win = api.nvim_open_win(buf, true, opts)
  api.nvim_set_option('winhl', 'Normal:MySearchBackground,FloatBorder:MyFloatBorder,FloatTitle:MyCmdLineTitle')
  api.nvim_buf_set_option(buf, 'winhl', 'FloatTitle:MyCmdLineTitle')
  api.nvim_buf_set_name(buf, "UniqueFloatingCmdLineName")
  api.nvim_win_set_option(win, 'winblend', 0)

  api.nvim_buf_set_option(buf, 'buftype', 'prompt')
  api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')

  vim.fn.prompt_setprompt(buf, ' ')

  vim.fn.prompt_setcallback(buf, execute_command)

  api.nvim_buf_set_keymap(buf, 'i', '<Tab>', '<C-x><C-v>', { noremap = true, silent = true })
  api.nvim_buf_set_keymap(buf, 'i', '<S-Tab>', '<C-p>', { noremap = true, silent = true })
end

function _G.execute_command(text)
  _G.close_floating_cmdline()
  vim.schedule(function()
    pcall(vim.cmd, text)
  end)
end

function _G.close_floating_cmdline()
  if win and api.nvim_win_is_valid(win) then
    api.nvim_win_close(win, true)
  end
  win = nil
  buf = nil
end

function _G.show_floating_cmdline()
  if win and api.nvim_win_is_valid(win) then
    _G.close_floating_cmdline()
  end
  _G.create_float()
  vim.cmd('startinsert!')
end

function M.setup()
  -- setup_highlights()
  vim.api.nvim_set_keymap('n', ':', '<cmd>lua show_floating_cmdline()<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<Esc>', '<cmd>lua close_floating_cmdline()<CR>', { noremap = true, silent = true })
end

return M
