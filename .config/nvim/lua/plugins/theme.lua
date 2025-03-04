return {
    "shaunsingh/nord.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        vim.opt.background = "dark"

        vim.g.nord_bold = false
        vim.g.nord_contrast = true
        vim.g.nord_disable_background = true

        vim.cmd.colorscheme("nord")
    end,
}
