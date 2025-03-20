vim.keymap.set("n", "<C-w>n", function() vim.cmd.Explore(vim.fn.expand("%:h")) end)

vim.keymap.set("n", "<C-d>", "<C-D>zz")
vim.keymap.set("n", "<C-u>", "<C-U>zz")

vim.keymap.set("n", "<C-j>", "<cmd>cnext<CR>")
vim.keymap.set("n", "<C-k>", "<cmd>cprevious<CR>")

vim.keymap.set("n", "<C-e>", "<cmd>marks A-XYZ<CR>")

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>")
