return {
    "neovim/nvim-lspconfig",
    dependencies = {
        { "j-hui/fidget.nvim", opts = { notification = { window = { winblend = 0 } } } },
        "williamboman/mason-lspconfig.nvim",
        "williamboman/mason.nvim",
        "saghen/blink.cmp",
    },
    config = function()
        local lspconfig = require("lspconfig")
        local capabilities = {
            textDocument = {
                foldingRange = {
                    dynamicRegistration = false,
                    lineFoldingOnly = true,
                },
            },
        }

        capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)

        local rust_analyzer_cfg = function()
            lspconfig.rust_analyzer.setup({
                capabilities = capabilities,
                settings = {
                    ["rust-analyzer"] = {
                        cargo = { features = "all" },
                    },
                },
            })
        end

        local lua_ls_cfg = function()
            lspconfig.lua_ls.setup({
                capabilities = capabilities,
                settings = {
                    Lua = {
                        runtime = { version = "LuaJIT" },
                        diagnostics = { globals = { "vim" } },
                    },
                },
            })
        end

        require("mason").setup()
        require("mason-lspconfig").setup({
            handlers = {
                function(server) lspconfig[server].setup({ capabilities = capabilities }) end,
                ["rust_analyzer"] = rust_analyzer_cfg,
                ["lua_ls"] = lua_ls_cfg,
            },
        })
    end,
}
