return {
  {
    "iguanacucumber/magazine.nvim",
    event = "InsertEnter",
    name = "nvim-cmp",
    dependencies = {
      { "iguanacucumber/mag-nvim-lsp", name = "cmp-nvim-lsp", opts = {} },
      { "iguanacucumber/mag-nvim-lua", name = "cmp-nvim-lua" },
      { "iguanacucumber/mag-buffer",   name = "cmp-buffer" },
      {
        "xzbdmw/colorful-menu.nvim",
        config = function()
          require("colorful-menu").setup({
            max_width = 55,
          })
        end,
      },
    },
    config = function()
      return require("plugin.config.cmp")
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    event = "BufReadPre",
    config = function()
      require("nvim-treesitter.configs").setup({
        sync_install = true,
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
}
