local M = {}

local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
if ok_cmp then
  capabilities = cmp_lsp.default_capabilities(capabilities)
end

local on_attach = function(client, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }

  -- Hover
  vim.keymap.set("n", "<leader>fp", vim.lsp.buf.hover, opts)

  -- Go-to
  vim.keymap.set("n", "<leader>ff", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "<leader>fd", vim.lsp.buf.declaration, opts)
  vim.keymap.set("n", "<leader>fr", vim.lsp.buf.references, opts)
  vim.keymap.set("n", "<leader>fi", vim.lsp.buf.implementation, opts)
  vim.keymap.set("n", "<leader>ft", vim.lsp.buf.type_definition, opts)

  -- Actions
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
  vim.keymap.set("n", "<leader>cc", vim.lsp.buf.code_action, opts)

  -- Diagnostics
  vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
  vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
  -- vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
  -- vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)
end

M.capabilities = capabilities
M.on_attach = on_attach

return M
