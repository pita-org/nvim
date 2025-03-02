function create_centered_float_terminal()
  local width = vim.api.nvim_get_option("columns")
  local height = vim.api.nvim_get_option("lines")
  local win_width = math.floor(width * 0.7)
  local win_height = math.floor(height * 0.7)
  local row = math.floor((height - win_height) / 2)
  local col = math.floor((width - win_width) / 2)

  local buf = vim.api.nvim_create_buf(false, true)

  vim.api.nvim_set_hl(0, 'MyFloatBorder', {
    fg = '#83a5ba',
    bg = "NONE",
    bold = true
  })

  vim.api.nvim_set_hl(0, 'MyTerminalBackground', {
    bg = '#121212'
  })

  vim.api.nvim_set_hl(0, 'MyFloatTitle', {
    fg = '#83a5ba',
    bg = "#121212",
    bold = true
  })

  local opts = {
    relative = "editor",
    width = win_width,
    height = win_height,
    row = row - 3,
    col = col,
    style = "minimal",
    title = " Terminal ",
    title_pos = "left",
    border = {
      { " ", "MyFloatBorder" },
      { " ", "MyFloatBorder" },
      { " ", "MyFloatBorder" },
      { " ", "MyFloatBorder" },
      { " ", "MyFloatBorder" },
      { " ", "MyFloatBorder" },
      { " ", "MyFloatBorder" },
      { " ", "MyFloatBorder" },
    }
  }

  local win = vim.api.nvim_open_win(buf, true, opts)

  vim.api.nvim_win_set_option(win, 'winhl',
    'FloatBorder:MyFloatBorder,FloatTitle:MyFloatTitle,Normal:MyTerminalBackground')
  vim.api.nvim_win_set_option(win, 'winblend', 0)

  vim.fn.termopen(vim.o.shell)
  vim.cmd('startinsert')

  vim.b[buf].float_term_win = win

  vim.api.nvim_buf_set_keymap(buf, 't', '<ESC>', '<C-\\><C-n>:bd!<CR>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', '<ESC>', '<C-\\><C-n>:bd!<CR>', { noremap = true, silent = true })



  return buf, win
end

vim.keymap.set('n', 'nt', function()
  local existing_term_bufs = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].buftype == 'terminal' then
      table.insert(existing_term_bufs, buf)
    end
  end
  if #existing_term_bufs > 0 then
    for _, buf in ipairs(existing_term_bufs) do
      local win_id = vim.b[buf].float_term_win
      if win_id and vim.api.nvim_win_is_valid(win_id) then
        vim.api.nvim_win_close(win_id, true)
      end
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  else
    create_centered_float_terminal()
  end
end, { desc = 'Toggle custom terminal' })

