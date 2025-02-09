local theme_current = 1
local themes = {
    { name = "github_light", lualine = "github_light" },
    { name = "pywal16", lualine = "pywal16-nvim" },
}

local cycle_theme = function()
    theme_current = theme_current % #themes + 1
    local theme = themes[theme_current]

    vim.cmd.colorscheme(theme.name)
    -- require("lualine").setup({ options = { theme = theme.lualine } })
end

vim.keymap.set("n", "<C-W>n", function()
    vim.cmd.Explore(vim.fn.expand("%:h"))
end)

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.keymap.set("n", "<leader>cc", cycle_theme)

vim.keymap.set("n", "<C-J>", "<cmd>cnext<CR>")
vim.keymap.set("n", "<C-K>", "<cmd>cprevious<CR>")

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>")
