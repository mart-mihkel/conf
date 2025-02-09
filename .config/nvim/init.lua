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
    spec = "plugins",
    lockfile = "/dev/null",
    change_detection = { notify = false },
})

vim.cmd.colorscheme("github_light")
