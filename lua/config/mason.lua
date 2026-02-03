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
  before_init = function(_, config)
    local root = config.root_dir
    local python = root .. "/.venv/bin/python"

    if vim.fn.executable(python) == 1 then
      config.settings = config.settings or {}
      config.settings.python = config.settings.python or {}
      config.settings.python.pythonPath = python
    end
  end,
})
