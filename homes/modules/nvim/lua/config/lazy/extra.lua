return {
    { 'tpope/vim-sleuth' },
    { 'norcalli/nvim-colorizer.lua' },
    {
        'folke/todo-comments.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
        opts = { signs = false }
    },
    {
        'echasnovski/mini.nvim',
        config = function()
            require('mini.ai').setup()
            require('mini.comment').setup()
            require('mini.surround').setup()
            require('mini.diff').setup({
                view = {
                    style = 'sign',
                    signs = { add = '+', change = '~', delete = '-' }
                }
            })
        end,
    },
    {
        'RedsXDD/neopywal.nvim',
        config = function()
            require('neopywal').setup({
                transparent_background = true,
                show_end_of_buffer = true,
                dim_inactive = false,
            })
        end
    },
    {
        'projekt0n/github-nvim-theme',
        config = function()
            local light_palette = { blue = { base = '#000000', bright = '#6b6b6b' } }
            local dark_palette = { blue = { base = '#f8f8f8', bright = '#ffffff' } }

            require('github-theme').setup({
                options = {
                    hide_end_of_buffer = false,
                    transparent = false,
                },
                palettes = {
                    github_light = light_palette,
                    github_dark = dark_palette,
                },
            })

            vim.cmd.colorscheme 'github_light'
        end,
    },
}
