local autocmd = vim.api.nvim_create_autocmd

autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

autocmd('FileType', {
  callback = function()
    vim.api.nvim_create_autocmd('BufWritePre', {
      pattern = '<buffer>',
      callback = function()
        local curpos = vim.api.nvim_win_get_cursor(0)
        vim.cmd([[keeppatterns %s/\s\+$//e]])
        vim.api.nvim_win_set_cursor(0, curpos)
      end,
    })
  end,
})
autocmd({ "InsertEnter" }, {
  callback = function()
    vim.o.cursorline    = false
    vim.o.cursorlineopt = "both"
    vim.opt.colorcolumn = "0"
  end
})
autocmd({ "InsertLeave" }, {
  callback = function()
    vim.o.cursorline    = true
    vim.o.cursorlineopt = "both"
    vim.opt.colorcolumn = "80"
  end
})
