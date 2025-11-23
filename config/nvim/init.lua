vim.g.mapleader = " "
vim.g.netrw_banner = 0
vim.g.netrw_preview = 1

vim.o.clipboard = "unnamedplus"
vim.o.relativenumber = true
vim.o.termguicolors = true
vim.o.winborder = "single"
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
vim.o.shiftwidth = 4
vim.o.cmdheight = 0
vim.o.scrolloff = 4
vim.o.number = true
vim.o.wrap = true
vim.o.list = true
vim.o.tabstop = 4

vim.pack.add({
	"https://github.com/saghen/blink.cmp",
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/stevearc/conform.nvim",
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/lewis6991/gitsigns.nvim",
	"https://github.com/williamboman/mason.nvim",
	"https://github.com/NMAC427/guess-indent.nvim",
	"https://github.com/rafamadriz/friendly-snippets",
	"https://github.com/nvim-telescope/telescope.nvim",
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/williamboman/mason-lspconfig.nvim",
})

require("mason").setup()
require("blink.cmp").setup()
require("guess-indent").setup()
require("mason-lspconfig").setup()

require("nvim-treesitter.configs").setup({
	highlight = { enable = true },
	auto_install = true,
})

require("gitsigns").setup({
	signs = {
		add = { text = "+" },
		change = { text = "~" },
		delete = { text = "-" },
		topdelete = { text = "-" },
		changedelete = { text = "~" },
	},
})

require("telescope").setup({
	defaults = {
		borderchars = { " ", " ", " ", " ", " ", " ", " ", " " },
		layout_config = {
			horizontal = {
				width = { padding = 0 },
				height = { padding = 0 },
			},
		},
	},
})

require("conform").setup({
	default_format_opts = { lsp_format = "fallback" },
	formatters_by_ft = {
		json = { "jq" },
		lua = { "stylua" },
		nix = { "alejandra" },
		css = { "prettierd" },
		html = { "prettierd" },
		typst = { "prettypst" },
		python = { "ruff_format" },
		markdown = { "prettierd" },
		javascript = { "prettierd" },
		typescript = { "prettierd" },
		javascriptreact = { "prettierd" },
		typescriptreact = { "prettierd" },
	},
})

vim.cmd.colorscheme("habamax")
vim.api.nvim_set_hl(0, "Pmenu", { bg = "none", fg = "none" })
vim.api.nvim_set_hl(0, "PmenuKind", { bg = "none", fg = "none" })
vim.api.nvim_set_hl(0, "StatusLine", { bg = "none", fg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none", fg = "none" })
vim.api.nvim_set_hl(0, "WinSeparator", { bg = "none", fg = "none" })

vim.keymap.set({ "n", "v" }, "j", "gj")
vim.keymap.set({ "n", "v" }, "k", "gk")
vim.keymap.set({ "n", "v" }, "<c-d>", "<c-d>zz")
vim.keymap.set({ "n", "v" }, "<c-u>", "<c-u>zz")
vim.keymap.set({ "n", "v" }, "<c-n>", ":cnext<cr>")
vim.keymap.set({ "n", "v" }, "<c-p>", ":cprevious<cr>")

vim.keymap.set("n", "<leader>e", ":args<cr>")
vim.keymap.set("n", "<leader>a", ":argadd %<cr>:argdedupe<cr>")
vim.keymap.set("n", "<c-h>", ":1argument<cr>")
vim.keymap.set("n", "<c-j>", ":2argument<cr>")
vim.keymap.set("n", "<c-k>", ":3argument<cr>")
vim.keymap.set("n", "<c-l>", ":4argument<cr>")

vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "<leader>gf", require("conform").format)
vim.keymap.set("n", "<leader>gb", require("gitsigns").blame_line)
vim.keymap.set("n", "<leader>gs", require("gitsigns").stage_hunk)
vim.keymap.set("n", "<leader>gr", require("gitsigns").reset_hunk)
vim.keymap.set("n", "<leader>gp", require("gitsigns").preview_hunk)

vim.keymap.set("n", "<leader>fr", require("telescope.builtin").resume)
vim.keymap.set("n", "<leader>fo", require("telescope.builtin").oldfiles)
vim.keymap.set("n", "<leader>fg", require("telescope.builtin").live_grep)
vim.keymap.set("n", "<leader>fs", require("telescope.builtin").git_status)
vim.keymap.set("n", "<leader>ff", function()
	if vim.uv.fs_stat(".git") then
		require("telescope.builtin").git_files({ show_untracked = true })
	else
		require("telescope.builtin").find_files()
	end
end)
