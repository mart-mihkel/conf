local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local lazyrepo = "https://github.com/folke/lazy.nvim.git"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end

vim.opt.rtp:prepend(lazypath)

require("config.option")
require("config.mapping")
require("config.autocmd")
require("lazy").setup({
    change_detection = { notify = false },
    lockfile = "/dev/null",
    spec = {
        { import = "plugins" },
        { "tpope/vim-sleuth" },
        { "3rd/image.nvim", opts = {} },
        { "norcalli/nvim-colorizer.lua" },
    },
})
