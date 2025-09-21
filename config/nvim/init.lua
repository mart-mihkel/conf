vim.g.mapleader = " "
vim.g.netrw_banner = false
vim.o.clipboard = "unnamedplus"
vim.o.winborder = "rounded"
vim.o.relativenumber = true
vim.o.termguicolors = true
vim.o.colorcolumn = "80"
vim.o.signcolumn = "yes"
vim.o.ignorecase = true
vim.o.cursorline = true
vim.o.expandtab = true
vim.o.smartcase = true
vim.o.swapfile = false
vim.o.undofile = true
vim.o.laststatus = 3
vim.o.shiftwidth = 4
vim.o.scrolloff = 4
vim.o.number = true
vim.o.wrap = false
vim.o.list = true
vim.o.tabstop = 4

vim.pack.add({
	"https://github.com/ibhagwan/fzf-lua",
	"https://github.com/vague2k/vague.nvim",
	"https://github.com/stevearc/conform.nvim",
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/lewis6991/gitsigns.nvim",
	"https://github.com/williamboman/mason.nvim",
	"https://github.com/NMAC427/guess-indent.nvim",
	"https://github.com/rafamadriz/friendly-snippets",
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/williamboman/mason-lspconfig.nvim",
	{ src = "https://github.com/saghen/blink.cmp", version = "v1.6.0" },
})

require("mason").setup()
require("gitsigns").setup()
require("blink.cmp").setup()
require("guess-indent").setup()
require("mason-lspconfig").setup()
require("vague").setup({ transparent = true })
require("nvim-treesitter.configs").setup({
	highlight = { enable = true },
	auto_install = true,
})

require("conform").setup({
	default_format_opts = { lsp_format = "fallback" },
	formatters_by_ft = {
		json = { "jq" },
		jsonc = { "jq" },
		lua = { "stylua" },
		nix = { "alejandra" },
		css = { "prettierd" },
		html = { "prettierd" },
		python = { "ruff_format" },
		typescript = { "prettierd" },
		typescriptreact = { "prettierd" },
	},
})

vim.cmd.colorscheme("vague")

vim.keymap.set("n", "<M-1>", "1gt")
vim.keymap.set("n", "<M-2>", "2gt")
vim.keymap.set("n", "<M-3>", "3gt")
vim.keymap.set("n", "<M-4>", "4gt")
vim.keymap.set("n", "<M-t>", ":tabnew %<CR>")
vim.keymap.set("n", "<C-j>", ":cnext<CR>")
vim.keymap.set("n", "<C-k>", ":cprevious<CR>")
vim.keymap.set({ "n", "v" }, "<C-d>", "<C-d>zz")
vim.keymap.set({ "n", "v" }, "<C-u>", "<C-u>zz")
vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "<leader>gf", require("conform").format)
vim.keymap.set("n", "<leader>gr", require("gitsigns").reset_hunk)
vim.keymap.set("n", "<leader>gp", require("gitsigns").preview_hunk)
vim.keymap.set("n", "<leader>sr", require("fzf-lua").resume)
vim.keymap.set("n", "<leader>so", require("fzf-lua").oldfiles)
vim.keymap.set("n", "<leader>sg", require("fzf-lua").live_grep)
vim.keymap.set("n", "<leader>sf", function()
	if vim.uv.fs_stat(".git") then
		require("fzf-lua").git_files()
	else
		require("fzf-lua").files()
	end
end)
