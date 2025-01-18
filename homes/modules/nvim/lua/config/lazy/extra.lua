return {
    { 'tpope/vim-sleuth' },
    { 'uZer/pywal16.nvim', },
    { 'RRethy/base16-nvim', },
    {
        'projekt0n/github-nvim-theme',
        config = function()
            require('github-theme').setup({
                options = { hide_end_of_buffer = false },
                palettes = {
                    github_light_high_contrast = {
                        blue = { base = '#000000', bright = '#6b6b6b' },
                    },
                },
            })

            vim.cmd 'colorscheme github_light_high_contrast'
        end,
    },
    {
        'folke/todo-comments.nvim',
        event = 'VimEnter',
        dependencies = { 'nvim-lua/plenary.nvim' },
        opts = { signs = false }
    },
    {
        'echasnovski/mini.nvim',
        config = function()
            require('mini.comment').setup()

            require('mini.ai').setup()
            require('mini.surround').setup()

            require('mini.diff').setup({
                view = {
                    style = 'sign',
                    signs = { add = '+', change = '~', delete = '-' }
                }
            })
        end,
    },
}
