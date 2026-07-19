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
vim.o.wrap = false
vim.o.list = true
vim.o.tabstop = 4

--- @param repo string
--- @return string url
local function gh(repo)
	return "https://github.com/" .. repo
end

vim.pack.add({
	-- rice
	gh("folke/noice.nvim"),
	gh("folke/snacks.nvim"),
	gh("folke/todo-comments.nvim"),
	gh("nvim-lualine/lualine.nvim"),
	gh("nvim-tree/nvim-web-devicons"),
	gh("projekt0n/github-nvim-theme"),
	gh("MunifTanjim/nui.nvim"), -- noice dependency

	-- util
	gh("stevearc/conform.nvim"),
	gh("lewis6991/gitsigns.nvim"),
	gh("nmac427/guess-indent.nvim"),

	-- lsp
	gh("neovim/nvim-lspconfig"),
	gh("williamboman/mason.nvim"),
	gh("williamboman/mason-lspconfig.nvim"),

	-- completion
	{ src = gh("saghen/blink.cmp"), version = vim.version.range("1.*") },
	{ src = gh("L3MON4D3/LuaSnip"), version = vim.version.range("2.*") },
})

require("todo-comments").setup()

require("snacks").setup({
	picker = {
		sources = {
			grep = { hidden = true },
			files = { hidden = true },
			explorer = { hidden = true },
		},
	},
})

require("noice").setup({
	lsp = {
		override = {
			["vim.lsp.util.stylize_markdown"] = true,
			["vim.lsp.util.convert_input_to_markdown_lines"] = true,
		},
	},
	presets = {
		bottom_search = true,
		lsp_doc_border = true,
		long_message_to_split = true,
	},
})

require("lualine").setup({
	options = { section_separators = "", component_separators = "" },
	sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { { "branch", icon = "" }, "filename" },
		lualine_x = {
			{
				require("noice").api.statusline.mode.get,
				cond = require("noice").api.statusline.mode.has,
			},
			"progress",
			"location",
		},
		lualine_y = {},
		lualine_z = {},
	},
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
		prettier = { prepend_args = { "--prose-wrap", "always", "--print-width", "80" } },
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
		markdown = { "prettier" },
		python = { "ruff_format" },
		javascriptreact = { "biome" },
		typescriptreact = { "biome" },
	},
})

vim.cmd.colorscheme("github_light")
vim.api.nvim_set_hl(0, "Normal", {})
vim.api.nvim_set_hl(0, "StatusLine", {})
vim.api.nvim_set_hl(0, "NormalFloat", {})

vim.diagnostic.config({ virtual_lines = { current_line = true } })

vim.keymap.set({ "n", "v" }, "j", "gj")
vim.keymap.set({ "n", "v" }, "k", "gk")

vim.keymap.set("n", "<c-n>", "<cmd>cnext<cr>")
vim.keymap.set("n", "<c-p>", "<cmd>cprevious<cr>")

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

vim.keymap.set("n", "<leader>t", snacks.terminal.open)
vim.keymap.set("n", "<leader>e", snacks.explorer.open)

vim.keymap.set("n", "<leader>fh", snacks.picker.help)
vim.keymap.set("n", "<leader>fg", snacks.picker.grep)
vim.keymap.set("n", "<leader>ff", snacks.picker.files)
vim.keymap.set("n", "<leader>fr", snacks.picker.resume)
vim.keymap.set("n", "<leader>fo", snacks.picker.recent)
vim.keymap.set("n", "<leader>fs", snacks.picker.git_status)
