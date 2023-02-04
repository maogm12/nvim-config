local fn = vim.fn
local lsp = vim.lsp
local diagnostic = vim.diagnostic

local lspconfig = require("lspconfig")
local lsp_on_attach = require('lsp').on_attach
local capabilities = require('cmp_nvim_lsp').default_capabilities()

require('mason-lspconfig').setup_handlers({
  function(server)
    lspconfig[server].setup({
      on_attach = lsp_on_attach,
      capabilities = capabilities,
    })
  end,
  ["pylsp"] = function()
    lspconfig.pylsp.setup {
      on_attach = lsp_on_attach,
      settings = {
        pylsp = {
          plugins = {
            pylint = { enabled = true, executable = "pylint" },
            pyflakes = { enabled = false },
            pycodestyle = { enabled = false },
            jedi_completion = { fuzzy = true },
            pyls_isort = { enabled = true },
            pylsp_mypy = { enabled = true },
          },
        },
      },
      flags = {
        debounce_text_changes = 200,
      },
      capabilities = capabilities,
    }
  end,
  ["ltex"] = function()
    lspconfig.ltex.setup {
      on_attach = lsp_on_attach,
      cmd = { "ltex-ls" },
      filetypes = { "text", "plaintex", "tex", "markdown" },
      settings = {
        ltex = {
          language = "en"
        },
      },
      flags = { debounce_text_changes = 300 },
    }
  end,
  ["vimls"] = function()
    lspconfig.vimls.setup {
      on_attach = lsp_on_attach,
      flags = {
        debounce_text_changes = 500,
      },
      capabilities = capabilities,
    }
  end,
  ["sumneko_lua"] = function()
    -- settings for lua-language-server can be found on https://github.com/sumneko/lua-language-server/wiki/Settings .
    lspconfig.sumneko_lua.setup {
      on_attach = lsp_on_attach,
      settings = {
        Lua = {
          runtime = {
            -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
            version = "LuaJIT",
          },
          diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = { "vim" },
          },
          workspace = {
            -- Make the server aware of Neovim runtime files,
            -- see also https://github.com/sumneko/lua-language-server/wiki/Libraries#link-to-workspace .
            -- Lua-dev.nvim also has similar settings for sumneko lua, https://github.com/folke/lua-dev.nvim/blob/main/lua/lua-dev/sumneko.lua .
            library = {
              fn.stdpath("data") .. "/site/pack/packer/opt/emmylua-nvim",
              fn.stdpath("config"),
            },
            maxPreload = 2000,
            preloadFileSize = 50000,
          },
        },
      },
      capabilities = capabilities,
    }
  end,
  ["clangd"] = function()
    lspconfig.clangd.setup {
      on_attach = lsp_on_attach,
      capabilities = capabilities,
      flags = {
        debounce_text_changes = 500,
      },
    }
  end
})

-- Change diagnostic signs.
fn.sign_define("DiagnosticSignError", { text = "✗", texthl = "DiagnosticSignError" })
fn.sign_define("DiagnosticSignWarn", { text = "!", texthl = "DiagnosticSignWarn" })
fn.sign_define("DiagnosticSignInformation", { text = "", texthl = "DiagnosticSignInfo" })
fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })

-- global config for diagnostic
diagnostic.config {
  underline = true,
  virtual_text = true,
  signs = true,
  severity_sort = true,
}

-- lsp.handlers["textDocument/publishDiagnostics"] = lsp.with(lsp.diagnostic.on_publish_diagnostics, {
--   underline = false,
--   virtual_text = false,
--   signs = true,
--   update_in_insert = false,
-- })

-- Change border of documentation hover window, See https://github.com/neovim/neovim/pull/13998.
lsp.handlers["textDocument/hover"] = lsp.with(vim.lsp.handlers.hover, {
  border = "rounded",
})
