return {
    "neovim/nvim-lspconfig",
    dependencies = {
        { "j-hui/fidget.nvim", opts = { notification = { window = { winblend = 0 } } } },
        { "L3MON4D3/LuaSnip", version = "v2.*", build = "make install_jsregexp" },
        "williamboman/mason-lspconfig.nvim",
        "williamboman/mason.nvim",
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/nvim-cmp",
    },
    config = function()
        -- snippets
        local luasnip = require("luasnip")
        luasnip.config.setup({})
        require("luasnip.loaders.from_vscode").lazy_load()

        -- autocomplete
        local cmp = require("cmp")
        cmp.setup({
            completion = { completeopt = "menu,menuone,noinsert" },
            mapping = cmp.mapping.preset.insert({
                ["<C-Space>"] = cmp.mapping.complete({}),
                ["<C-y>"] = cmp.mapping.confirm({ select = true }),
                ["<C-n>"] = cmp.mapping.select_next_item(),
                ["<C-p>"] = cmp.mapping.select_prev_item(),

                ["<C-l>"] = cmp.mapping(function()
                    if luasnip.expand_or_locally_jumpable() then luasnip.expand_or_jump() end
                end, { "i", "s" }),

                ["<C-h>"] = cmp.mapping(function()
                    if luasnip.locally_jumpable(-1) then luasnip.jump(-1) end
                end, { "i", "s" }),
            }),
            snippet = {
                expand = function(args) luasnip.lsp_expand(args.body) end,
            },
            sources = {
                { name = "nvim_lsp" },
                { name = "luasnip" },
                { name = "buffer" },
                { name = "path" },
            },
        })

        -- lsp
        local lspconfig = require("lspconfig")
        local capabilities = vim.tbl_deep_extend(
            "force",
            lspconfig.util.default_config.capabilities,
            require("cmp_nvim_lsp").default_capabilities()
        )

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
