require('mason').setup()
require('mason-lspconfig').setup({
    ensure_installed = {
        "sumneko_lua", -- lua
        "rust_analyzer", -- rust
        "clangd", -- C/C++
        "pylsp", -- python
        "marksman", -- markdown
        "bashls", -- bash
        "beancount", -- beancount
    },
    automatic_setup = true,
})
