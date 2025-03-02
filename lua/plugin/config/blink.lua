return {
  require("blink.cmp").setup({
    snippets = {
      expand = function(snippet)
        vim.snippet.expand(snippet)
      end,
    },
    keymap = {
      ['<C-k>'] = { 'select_prev', 'fallback' },
      ['<C-j>'] = { 'select_next', 'fallback' },
      ['<CR>'] = { 'accept', 'fallback' },
      ['<ESC>'] = { 'cancel', 'fallback' },
    },
    cmdline = {},
    completion = {
      menu = {
        scrollbar = false,
        draw = {
          columns = { { "provider" }, { "label", "label_description", gap = 2 }, { "kind" } },
          components = {
            label = {
              text = function(ctx)
                return require("colorful-menu").blink_components_text(ctx)
              end,
              highlight = function(ctx)
                return require("colorful-menu").blink_components_highlight(ctx)
              end,
            },
            kind = {
              highlight = "pitaGray",
            },
            provider = {
              text = function(ctx)
                return "[" .. ctx.item.source_name:sub(1, 3):upper() .. "]"
              end,
              highlight = "pitaGray",
            },
          },
        },
      },
    },
  })
}
