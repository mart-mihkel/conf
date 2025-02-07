return {
    { "tpope/vim-sleuth" },
    { "echasnovski/mini.ai" },
    { "echasnovski/mini.comment" },
    { "echasnovski/mini.surround" },
    { "folke/which-key.nvim", opts = {} },
    { "nvim-lualine/lualine.nvim", opts = {} },
    { "nvim-tree/nvim-web-devicons", opts = {} },
    {
        "folke/noice.nvim",
        opts = { cmdline = { view = "cmdline" } },
    },
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = { signs = false },
    },
    {
        "echasnovski/mini.diff",
        opts = {
            view = {
                style = "sign",
                signs = { add = "+", change = "~", delete = "-" },
            },
        },
    },
    {
        "norcalli/nvim-colorizer.lua",
        config = function()
            require("colorizer").setup()
        end,
    },
}
