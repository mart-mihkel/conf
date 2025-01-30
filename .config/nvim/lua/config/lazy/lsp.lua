return {
    'neovim/nvim-lspconfig',
    dependencies = {
        'williamboman/mason-lspconfig.nvim',
        'williamboman/mason.nvim',
        'hrsh7th/nvim-cmp',
    },
    config = function()
        local lspconfig = require 'lspconfig'
        local capabilities = vim.tbl_deep_extend(
            'force',
            lspconfig.util.default_config.capabilities,
            require('cmp_nvim_lsp').default_capabilities()
        )

        require('mason').setup()
        require('mason-lspconfig').setup({
            handlers = {
                function(server)
                    lspconfig[server].setup({
                        capabilities = capabilities,
                    })
                end,
                ['rust_analyzer'] = function()
                    lspconfig.rust_analyzer.setup({
                        capabilities = capabilities,
                        settings = {
                            ['rust-analyzer'] = {
                                cargo = { features = 'all' },
                            },
                        },
                    })
                end,
                ['lua_ls'] = function()
                    lspconfig.lua_ls.setup({
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                runtime = { version = 'LuaJIT' },
                                diagnostics = {
                                    globals = { 'vim' },
                                },
                            },
                        },
                    })
                end,
            },
        })

        vim.api.nvim_create_autocmd('LspAttach', {
            desc = 'LSP keymaps',
            group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
            callback = function(event)
                local builtin = require('telescope.builtin')
                local map = function(keys, func, desc)
                    vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
                end

                map('K', vim.lsp.buf.hover, 'Hover documentation')
                map('gr', builtin.lsp_references, 'Goto references')
                map('gd', builtin.lsp_definitions, 'Goto definition')
                map('gi', builtin.lsp_implementations, 'Goto implementation')

                map('<leader>rn', vim.lsp.buf.rename, 'Rename')
                map('<leader>ca', vim.lsp.buf.code_action, 'Code action')
                map('<leader>D', builtin.lsp_type_definitions, 'Type definition')
                map('<leader>ds', builtin.lsp_document_symbols, 'Document symbols')
                map('<leader>ws', builtin.lsp_dynamic_workspace_symbols, 'Workspace symbols')
            end,
        })
    end,
}
