vim.g.mapleader = " "
vim.g.netrw_banner = 0
vim.g.netrw_preview = 1

vim.o.clipboard = "unnamedplus"
vim.o.winborder = "rounded"
vim.o.relativenumber = true
vim.o.termguicolors = true
vim.o.background = "light"
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

---@param repo string
---@return string
local function gh(repo)
	return "https://github.com/" .. repo
end

vim.pack.add({
	gh("rakr/vim-one.git"),
	gh("nvim-lua/plenary.nvim"),
	gh("stevearc/conform.nvim"),
	gh("neovim/nvim-lspconfig"),
	gh("lewis6991/gitsigns.nvim"),
	gh("williamboman/mason.nvim"),
	gh("nmac427/guess-indent.nvim"),
	gh("rafamadriz/friendly-snippets"),
	gh("nvim-telescope/telescope.nvim"),
	gh("williamboman/mason-lspconfig.nvim"),
	{ src = gh("saghen/blink.cmp"), version = "v1.10.4" },
})

require("telescope").setup({ defaults = { layout_strategy = "vertical" } })
require("mason").setup({ ui = { backdrop = 100 } })
require("mason-lspconfig").setup()
require("guess-indent").setup()

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
	formatters = {
		typstyle = { prepend_args = { "--wrap-text" } },
		["tex-fmt"] = { prepend_args = { "--format-tables" } },
	},
	formatters_by_ft = {
		css = { "biome" },
		html = { "biome" },
		json = { "biome" },
		lua = { "stylua" },
		tex = { "tex-fmt" },
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

vim.cmd.colorscheme("one")
vim.api.nvim_set_hl(0, "Pmenu", {})
vim.api.nvim_set_hl(0, "NormalFloat", {})

vim.keymap.set({ "n", "v" }, "j", "gj")
vim.keymap.set({ "n", "v" }, "k", "gk")

vim.keymap.set("n", "<c-n>", ":cnext<cr>")
vim.keymap.set("n", "<c-p>", ":cprevious<cr>")

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
