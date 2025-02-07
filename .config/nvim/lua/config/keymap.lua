local theme_current = 1
local themes = {
    { name = "github_light", lualine = "github_light" },
    { name = "pywal16", lualine = "pywal16-nvim" },
}

local cycle_theme = function()
    theme_current = theme_current % #themes + 1
    local theme = themes[theme_current]
    vim.cmd.colorscheme(theme.name)
    require("lualine").setup({ options = { theme = theme.lualine } })
end

local netrw_buf_dir = function()
    local path = vim.fn.expand("%:h")
    vim.cmd("Explore " .. path)
end

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "<leader>cc", cycle_theme, { desc = "Colorscheme cycle" })
vim.keymap.set("n", "<leader>n", netrw_buf_dir, { desc = "Netrw buffer directory" })
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
