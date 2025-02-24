require("config.option")
require("config.mapping")
require("config.autocmd")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local lazyrepo = "https://github.com/folke/lazy.nvim.git"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({ "git", "clone", "-b stable", "--filter=blob:none", lazyrepo, lazypath })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    change_detection = { notify = false },
    lockfile = "/dev/null",
    spec = {
        { import = "plugins" },
        { "tpope/vim-sleuth" },
        { "norcalli/nvim-colorizer.lua" },
        {
            "lewis6991/gitsigns.nvim",
            opts = {
                signs_staged_enable = false,
                signs = { add = { text = "+" }, change = { text = "~" } },
            },
        },
        {
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
        },
    },
})
