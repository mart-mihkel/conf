return {
    "projekt0n/github-nvim-theme",
    lazy = false,
    priority = 1024,
    config = function()
        local black = { base = "#181818", bright = "#6b6b6b" }

        require("github-theme").setup({
            options = {
                hide_end_of_buffer = false,
            },
            palettes = {
                github_light_high_contrast = {
                    blue = black,
                },
            },
        })

        vim.cmd("colorscheme github_light_high_contrast")
    end,
}
