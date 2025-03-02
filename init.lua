-- i started thi project because of this project lol
-- https://github.com/sownteedev/TeVim
-- i took inspo for the bar :)
-- and now that i look at that repo again my tabline is similar

local req = {
  "core.lazy",
  "core.options",
  "core.keybinds",
  "core.autocmd",
  "core.lsp",
  "ui.terminal",
  "ui.colorscheme",
  "ui.colorit",
  "ui.statusline",
  "ui.tabline",
  "ui.cmd",
  "ui.startscreen",
  "ui.filetree",
}
for _, i in pairs(req) do
  require(i)
end

