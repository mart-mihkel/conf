return {
    "echasnovski/mini.nvim",
    config = function()
        require("mini.comment").setup({})
        require("mini.diff").setup({
            view = {
                style = "sign",
                signs = { add = "+", change = "~", delete = "-" }
            }
        })
    end,
}
