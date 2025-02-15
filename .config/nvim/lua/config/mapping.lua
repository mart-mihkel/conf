local colori = 1
local colors = { "github_light", "pywal16" }

local cycle_colors = function()
    colori = colori % #colors + 1
    vim.cmd.colorscheme(colors[colori])
end

vim.keymap.set("n", "<leader>cc", cycle_colors)

vim.keymap.set("n", "<C-w>n", function() vim.cmd.Explore(vim.fn.expand("%:h")) end)

vim.keymap.set("n", "<C-d>", "<C-D>zz")
vim.keymap.set("n", "<C-u>", "<C-U>zz")

vim.keymap.set("n", "<C-j>", "<cmd>cnext<CR>")
vim.keymap.set("n", "<C-k>", "<cmd>cprevious<CR>")

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>")
