vim.g.mapleader = " "
vim.g.netrw_banner = 0
vim.g.netrw_preview = 1

vim.o.clipboard = "unnamedplus"
vim.o.winborder = "rounded"
vim.o.guicursor = "a:block"
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
vim.o.tabstop = 4
vim.o.wrap = true
vim.o.list = true

--- @param repo string
--- @return string url
local function gh(repo)
	return "https://github.com/" .. repo
end

vim.pack.add({
	gh("folke/snacks.nvim"),
	gh("folke/zen-mode.nvim"),
	gh("folke/todo-comments.nvim"),
	gh("nvim-tree/nvim-web-devicons"),
	gh("projekt0n/github-nvim-theme"),

	gh("lewis6991/gitsigns.nvim"),
	gh("nmac427/guess-indent.nvim"),

	gh("neovim/nvim-lspconfig"),
	gh("stevearc/conform.nvim"),
	gh("williamboman/mason.nvim"),
	gh("williamboman/mason-lspconfig.nvim"),

	{ src = gh("L3MON4D3/LuaSnip"), version = vim.version.range("2.*") },
	{ src = gh("saghen/blink.cmp"), version = vim.version.range("1.*") },
})

require("todo-comments").setup()
require("zen-mode").setup({
	window = { width = 86, backdrop = 1 },
})

require("snacks").setup({
	image = { enabled = true },
	picker = { enabled = true },
})

require("gitsigns").setup()
require("guess-indent").setup()

require("mason").setup({ ui = { backdrop = 100 } })
require("mason-lspconfig").setup()

-- make --directory ~/.local/share/nvim/site/pack/core/opt/LuaSnip install_jsregexp
require("luasnip").setup()
require("blink.cmp").setup({
	signature = { enabled = true },
	snippets = { preset = "luasnip" },
	completion = {
		menu = { scrollbar = false },
		accept = { auto_brackets = { enabled = false } },
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
		typst = { "typstyle" },
		javascript = { "biome" },
		typescript = { "biome" },
		python = { "ruff_format" },
		markdown = { "prettierd" },
		javascriptreact = { "biome" },
		typescriptreact = { "biome" },
	},
})

-- TODO: delete
vim.lsp.enable("qmlls")
vim.lsp.config("qmlls", {
	cmd = { "qmlls6" },
	filetypes = { "qml", "qmljs" },
})

vim.cmd.colorscheme("github_light")
vim.api.nvim_set_hl(0, "Normal", {})
vim.api.nvim_set_hl(0, "StatusLine", {})
vim.api.nvim_set_hl(0, "NormalFloat", {})

vim.diagnostic.config({ virtual_lines = { current_line = true } })

vim.keymap.set({ "n", "v" }, "j", "gj")
vim.keymap.set({ "n", "v" }, "k", "gk")

vim.keymap.set("n", "<c-n>", ":cnext<cr>")
vim.keymap.set("n", "<c-p>", ":cprevious<cr>")
vim.keymap.set("n", "<leader>e", ":Explore<cr>")

vim.keymap.set("n", "grn", vim.lsp.buf.rename)
vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "gra", vim.lsp.buf.code_action)

vim.keymap.set("n", "<leader>gf", require("conform").format)

local gs = require("gitsigns")

vim.keymap.set("n", "<leader>gb", gs.blame_line)
vim.keymap.set("n", "<leader>gr", gs.reset_hunk)
vim.keymap.set("n", "<leader>gs", gs.stage_hunk)
vim.keymap.set("n", "<leader>gp", gs.preview_hunk)

local snacks = require("snacks")

vim.keymap.set("n", "<leader>fh", snacks.picker.help)
vim.keymap.set("n", "<leader>fg", snacks.picker.grep)
vim.keymap.set("n", "<leader>ff", snacks.picker.files)
vim.keymap.set("n", "<leader>fr", snacks.picker.resume)
vim.keymap.set("n", "<leader>fo", snacks.picker.recent)
vim.keymap.set("n", "<leader>fs", snacks.picker.git_status)
