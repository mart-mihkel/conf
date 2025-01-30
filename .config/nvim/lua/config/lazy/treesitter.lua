return {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
        require('nvim-treesitter.configs').setup({
            sync_install = false,
            auto_install = true,

            indent = { enable = true },
            highlight = { enable = true },
        })
    end,
}
