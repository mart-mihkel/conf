vim.g.mapleader = " "
vim.g.netrw_banner = false

vim.o.guicursor = "n-v-c-i:block-nCursor"
vim.o.clipboard = "unnamedplus"
vim.o.signcolumn = "yes"
vim.o.colorcolumn = "80"
vim.o.relativenumber = true
vim.o.termguicolors = true
vim.o.breakindent = true
vim.o.ignorecase = true
vim.o.cursorline = true
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.expandtab = true
vim.o.smartcase = true
vim.o.incsearch = true
vim.o.swapfile = false
vim.o.hlsearch = false
vim.o.undofile = true
vim.o.number = true
vim.o.wrap = false
vim.o.list = true
vim.o.shiftwidth = 4
vim.o.scrolloff = 4
vim.o.tabstop = 4

vim.pack.add({
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/stevearc/conform.nvim",
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/lewis6991/gitsigns.nvim",
    "https://github.com/williamboman/mason.nvim",
    "https://github.com/NMAC427/guess-indent.nvim",
    "https://github.com/nvim-telescope/telescope.nvim",
    "https://github.com/nvim-treesitter/nvim-treesitter",
    "https://github.com/williamboman/mason-lspconfig.nvim",
    { src = "https://github.com/saghen/blink.cmp", version = "v1.6.0" },
})

vim.cmd.colorscheme("habamax")
vim.diagnostic.config({ virtual_text = { current_line = true } })
vim.lsp.config("*", {
    root_markers = { ".git" },
    capabilities = require("blink.cmp").get_lsp_capabilities(),
})

require("mason").setup()
require("gitsigns").setup()
require("telescope").setup()
require("blink.cmp").setup()
require("guess-indent").setup()
require("mason-lspconfig").setup()
require("nvim-treesitter.configs").setup({
    highlight = { enable = true },
    auto_install = true,
})

require("conform").setup({
    default_format_opts = { async = true, lsp_format = "fallback" },
    formatters_by_ft = {
        json = { "jq" },
        lua = { "stylua" },
        css = { "prettierd" },
        html = { "prettierd" },
        python = { "ruff_format" },
        javascript = { "prettierd" },
        typescript = { "prettierd" },
    },
})

vim.keymap.set({ "n", "v" }, "j", "gj")
vim.keymap.set({ "n", "v" }, "k", "gk")
vim.keymap.set({ "n", "v" }, "<C-d>", "<C-d>zz")
vim.keymap.set({ "n", "v" }, "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-j>", ":cnext<CR>")
vim.keymap.set("n", "<C-k>", ":cprevious<CR>")
vim.keymap.set("n", "<C-l>", ":lnext<CR>")
vim.keymap.set("n", "<C-h>", ":lprevious<CR>")
vim.keymap.set("n", "<M-t>", ":tabnew<CR>")
for i = 1, 10 do
    vim.keymap.set("n", "<M-" .. i .. ">", i .. "gt")
end

vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
vim.keymap.set("n", "<leader>gf", require("conform").format)
vim.keymap.set("n", "<leader>gb", require("gitsigns").blame_line)
vim.keymap.set("n", "<leader>gr", require("gitsigns").reset_hunk)
vim.keymap.set("n", "<leader>gp", require("gitsigns").preview_hunk)
vim.keymap.set("n", "<leader>sr", require("telescope.builtin").resume)
vim.keymap.set("n", "<leader>sg", require("telescope.builtin").live_grep)
vim.keymap.set("n", "<leader>sf", function()
    if vim.fs.find(".git", { upward = true, type = "directory" })[1] ~= nil then
        require("telescope.builtin").git_files({ show_untracked = true })
    else
        require("telescope.builtin").find_files()
    end
end)
