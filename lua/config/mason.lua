local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local lspconfig = require("lspconfig")
local base = require("config.lsp")


mason.setup()
mason_lspconfig.setup({
  ensure_installed = {
    "pyright",
    "vtsls",
  },
  automatic_installation = true,
})

vim.lsp.config('vtsls', {
  on_attach = base.on_attach,
  capabilities = base.capabilities,
})

vim.lsp.config('pyright', {
  on_attach = base.on_attach,
  capabilities = base.capabilities,
})
