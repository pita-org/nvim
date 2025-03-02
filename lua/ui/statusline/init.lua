vim.g.barpos = "bottom"
vim.g.barstyle = "floating"

require("ui.statusline." .. vim.g.barstyle).init(vim.g.barpos)
