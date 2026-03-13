vim.g.mapleader = " "
vim.g.netrw_banner = 0
vim.g.netrw_preview = 1

vim.o.clipboard = "unnamedplus"
vim.o.winborder = "rounded"
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
vim.o.scrolloff = 4
vim.o.number = true
vim.o.wrap = true
vim.o.list = true

vim.pack.add({
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/stevearc/conform.nvim",
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/lewis6991/gitsigns.nvim",
	"https://github.com/williamboman/mason.nvim",
	"https://github.com/nmac427/guess-indent.nvim",
	"https://github.com/projekt0n/github-nvim-theme",
	"https://github.com/rafamadriz/friendly-snippets",
	"https://github.com/nvim-telescope/telescope.nvim",
	"https://github.com/williamboman/mason-lspconfig.nvim",
	{ src = "https://github.com/saghen/blink.cmp", version = "v1.9.1" },
})

require("mason").setup()
require("guess-indent").setup()
require("mason-lspconfig").setup()
require("telescope").setup({ defaults = { layout_strategy = "vertical" } })

require("blink.cmp").setup({
	completion = {
		accept = { auto_brackets = { enabled = false } },
		menu = {
			scrollbar = false,
			draw = { columns = { { "label" }, { "kind" } } },
		},
	},
})

require("gitsigns").setup({
	signs_staged_enable = false,
	signs = {
		add = { text = "+" },
		change = { text = "~" },
		delete = { text = "_" },
		topdelete = { text = "-" },
		changedelete = { text = "~" },
	},
})

require("conform").setup({
	default_format_opts = { lsp_format = "fallback" },
	formatters = { typstyle = { prepend_args = { "--wrap-text" } } },
	formatters_by_ft = {
		css = { "biome" },
		html = { "biome" },
		json = { "biome" },
		lua = { "stylua" },
		nix = { "alejandra" },
		typst = { "typstyle" },
		javascript = { "biome" },
		typescript = { "biome" },
		python = { "ruff_format" },
		markdown = { "prettierd" },
		javascriptreact = { "biome" },
		typescriptreact = { "biome" },
	},
})

vim.cmd.colorscheme("github_light")
vim.api.nvim_set_hl(0, "StatusLine", {})

vim.keymap.set({ "n", "v" }, "j", "gj")
vim.keymap.set({ "n", "v" }, "k", "gk")
vim.keymap.set("n", "<c-n>", ":silent! cnext<cr>")
vim.keymap.set("n", "<c-p>", ":silent! cprevious<cr>")

vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "<leader>gf", require("conform").format)
vim.keymap.set("n", "<leader>gb", require("gitsigns").blame_line)
vim.keymap.set("n", "<leader>gr", require("gitsigns").reset_hunk)
vim.keymap.set("n", "<leader>gs", require("gitsigns").stage_hunk)
vim.keymap.set("n", "<leader>gp", require("gitsigns").preview_hunk)
vim.keymap.set("n", "<leader>fr", require("telescope.builtin").resume)
vim.keymap.set("n", "<leader>fo", require("telescope.builtin").oldfiles)
vim.keymap.set("n", "<leader>fg", require("telescope.builtin").live_grep)
vim.keymap.set("n", "<leader>fh", require("telescope.builtin").help_tags)
vim.keymap.set("n", "<leader>fs", require("telescope.builtin").git_status)
vim.keymap.set("n", "<leader>ff", require("telescope.builtin").find_files)
