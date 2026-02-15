vim.g.mapleader = " "
vim.g.netrw_banner = 0
vim.g.netrw_preview = 1

vim.o.clipboard = "unnamedplus"
vim.o.relativenumber = true
vim.o.termguicolors = true
vim.o.colorcolumn = "80"
vim.o.signcolumn = "yes"
vim.o.ignorecase = true
vim.o.cursorline = true
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.expandtab = true
vim.o.smartcase = true
vim.o.swapfile = false
vim.o.hlsearch = false
vim.o.undofile = true
vim.o.laststatus = 3
vim.o.cmdheight = 0
vim.o.scrolloff = 4
vim.o.number = true
vim.o.wrap = true
vim.o.list = true

vim.pack.add({
	{ src = "https://github.com/nordtheme/vim" },
	{ src = "https://github.com/saghen/blink.cmp" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/stevearc/conform.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
	{ src = "https://github.com/williamboman/mason.nvim" },
	{ src = "https://github.com/NMAC427/guess-indent.nvim" },
	{ src = "https://github.com/rafamadriz/friendly-snippets" },
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },
	{ src = "https://github.com/williamboman/mason-lspconfig.nvim" },
	{ src = "https://github.com/saghen/blink.cmp", version = "v1.8.0" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "master" },
})

require("mason").setup()
require("guess-indent").setup()
require("mason-lspconfig").setup()
require("gitsigns").setup({ signcolumn = false })
require("telescope").setup({ defaults = { layout_strategy = "vertical" } })

require("nvim-treesitter.configs").setup({
	auto_install = true,
	highlight = { enable = true },
})

require("blink.cmp").setup({
	completion = {
		accept = { auto_brackets = { enabled = false } },
		menu = {
			scrollbar = false,
			draw = { columns = { { "label" }, { "kind" } } },
		},
	},
})

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		nix = { "alejandra" },
		typst = { "prettypst" },
		python = { "ruff_format" },
		markdown = { "prettierd" },

		css = { "biome" },
		html = { "biome" },
		json = { "biome" },
		jsonc = { "biome" },
		javascript = { "biome" },
		typescript = { "biome" },
		javascriptreact = { "biome" },
		typescriptreact = { "biome" },
	},
	default_format_opts = { lsp_format = "fallback" },
})

vim.cmd.colorscheme("nord")
vim.api.nvim_set_hl(0, "NormalFloat", { link = "Pmenu" })
vim.api.nvim_set_hl(0, "StatusLine", { bg = "none", fg = "none" })

vim.keymap.set({ "n", "v" }, "j", "gj")
vim.keymap.set({ "n", "v" }, "k", "gk")
vim.keymap.set({ "n", "v" }, "<c-n>", ":silent! cnext<cr>")
vim.keymap.set({ "n", "v" }, "<c-p>", ":silent! cprevious<cr>")

vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "<leader>gf", require("conform").format)
vim.keymap.set("n", "<leader>gb", require("gitsigns").blame_line)
vim.keymap.set("n", "<leader>gp", require("gitsigns").preview_hunk)

vim.keymap.set("n", "<leader>fr", require("telescope.builtin").resume)
vim.keymap.set("n", "<leader>fo", require("telescope.builtin").oldfiles)
vim.keymap.set("n", "<leader>fg", require("telescope.builtin").live_grep)
vim.keymap.set("n", "<leader>fh", require("telescope.builtin").help_tags)
vim.keymap.set("n", "<leader>fs", require("telescope.builtin").git_status)
vim.keymap.set("n", "<leader>ff", function()
	if vim.uv.fs_stat(".git") then
		require("telescope.builtin").git_files({ show_untracked = true })
	else
		require("telescope.builtin").find_files()
	end
end)
