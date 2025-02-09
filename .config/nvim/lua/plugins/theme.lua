return {
    {
        "uZer/pywal16.nvim",
        lazy = false,
    },
    {
        "projekt0n/github-nvim-theme",
        lazy = false,
        config = function()
            local dark_palette = { blue = { base = "#f8f8f8", bright = "#ffffff" } }
            local light_palette = { blue = { base = "#181818", bright = "#6b6b6b" } }

            require("github-theme").setup({
                options = { hide_end_of_buffer = false },
                palettes = {
                    github_dark = dark_palette,
                    github_light = light_palette,
                },
            })
        end,
    },
}
