return {
    { 'tpope/vim-sleuth' },
    {
        'norcalli/nvim-colorizer.lua',
        config = function()
            require('colorizer').setup()
        end
    },
    {
        'RedsXDD/neopywal.nvim',
        config = function()
            require('neopywal').setup({
                transparent_background = true,
                show_end_of_buffer = true,
                dim_inactive = false,
            })

            -- vim.cmd.colorscheme 'neopywal'
        end
    },
    {
        'projekt0n/github-nvim-theme',
        config = function()
            local light_palette = { blue = { base = '#000000', bright = '#6b6b6b' } }
            local dark_palette = { blue = { base = '#f8f8f8', bright = '#ffffff' } }

            require('github-theme').setup({
                options = { hide_end_of_buffer = false },
                palettes = {
                    github_light_high_contrast = light_palette,
                    github_light_colorblind = light_palette,
                    github_light_tritanopia = light_palette,
                    github_light_default = light_palette,
                    github_light_dimmed = light_palette,
                    github_light = light_palette,

                    github_dark_high_contrast = dark_palette,
                    github_dark_colorblind = dark_palette,
                    github_dark_tritanopia = dark_palette,
                    github_dark_default = dark_palette,
                    github_dark_dimmed = dark_palette,
                    github_dark = dark_palette,
                },
            })

            vim.cmd.colorscheme 'github_light_high_contrast'
        end,
    },
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
}
