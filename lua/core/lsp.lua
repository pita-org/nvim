local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- local capabilities = require('blink.cmp').get_lsp_capabilities()
-- local capabilities = nil

-- Function to start an LSP client for a specific file type
local function start_lsp_for_filetype(filetype, cmd, root_files, settings)
  vim.api.nvim_create_autocmd("FileType", {
    pattern = filetype,
    callback = function()
      local root_dir = vim.fs.dirname(vim.fs.find(root_files, { upward = true })[1] or vim.fn.getcwd())
      vim.lsp.start({
        name = filetype .. "_lsp",
        cmd = cmd,
        root_dir = root_dir,
        capabilities = capabilities,
        settings = settings,
      })
    end,
  })
end
start_lsp_for_filetype("gleam", { "gleam", "lsp" }, { "gleam.toml" }, nil)
start_lsp_for_filetype("lua", { "lua-language-server" }, { ".luarc.json", ".git" }, {
  Lua = {
    diagnostics = { globals = { "vim", "bit", "jit", "utf8" } },
    workspace = {
      checkThirdParty = false,
      library = vim.tbl_deep_extend('force', vim.api.nvim_get_runtime_file("", true), {
        "${3rd}/luv/library",
        "${3rd}/busted/library",
        "/usr/share/awesome/lib",
        "/usr/share/lua",
      }),
    },
    telemetry = { enable = false },
    hint = { enable = true },
  },
})


-- C/C++ i want to stop using lsp lets start with C/C++
start_lsp_for_filetype("c,cpp", {
  "clangd",
  "--background-index",
  "-j=12",
  "--query-driver=/usr/bin/**/clang-*,/bin/clang,/bin/clang++,/usr/bin/gcc,/usr/bin/g++",
  "--clang-tidy",
  "--clang-tidy-checks=*",
  "--all-scopes-completion",
  "--cross-file-rename",
  "--completion-style=detailed",
  "--header-insertion-decorators",
  "--header-insertion=iwyu",
  "--pch-storage=memory",
}, { ".clangd", ".git" }, nil)




vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc)
      vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
    end
    map("gr", vim.lsp.buf.references, "Goto References ")
    map("gd", vim.lsp.buf.definition, "Goto Definition")
    map("<leader>bf", vim.lsp.buf.format, "Format Buffer")
    map("gi", vim.lsp.buf.implementation, "Goto Implementation")
    map("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
    map("<leader>w", vim.lsp.buf.rename, "Rename")
    map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
    map("gD", vim.lsp.buf.declaration, "Goto Declaration")

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
      local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd("LspDetach", {
        group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event2.buf })
        end,
      })
    end
  end,
})
vim.diagnostic.config({
  virtual_text = true,
  underline = true,
  update_in_insert = false,
  severity_sort = false,
  signs = {

    text = {
      [vim.diagnostic.severity.ERROR] = '',
      [vim.diagnostic.severity.WARN] = '',
      [vim.diagnostic.severity.HINT] = '',
      [vim.diagnostic.severity.INFO] = '',
    },

  },
})

