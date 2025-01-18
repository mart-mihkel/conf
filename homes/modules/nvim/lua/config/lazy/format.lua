return {
    'stevearc/conform.nvim',
    opts = {
        notify_on_error = false,
        formatters_by_ft = {
            lua = { 'stylua' },
            yml = { 'ymlfmt' },
            python = { 'ruff_format' },
            javascript = { 'prettierd' },
            typescript = { 'prettierd' },
            ['*'] = { 'trim_whitespace', 'trim_newlines' },
        },
    },
    config = function()
        local format = function()
            require('conform').format({
                async = true,
                lsp_format = 'fallback',
                formatters = { 'trim_whitespace', 'trim_newlines' },
            })
        end

        vim.keymap.set({ 'n', 'v' }, '<leader>f', format, { desc = 'Format' })
    end
}
