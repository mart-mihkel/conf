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
---@return string url
local function gh(repo)
	return "https://github.com/" .. repo
end

vim.pack.add({
	gh("rakr/vim-one.git"),
	gh("folke/zen-mode.nvim"),
	gh("lewis6991/gitsigns.nvim"),
	gh("nmac427/guess-indent.nvim"),
	gh("nvim-tree/nvim-web-devicons"),

	gh("nvim-lua/plenary.nvim"),
	gh("nvim-telescope/telescope.nvim"),
	gh("nvim-telescope/telescope-fzf-native.nvim"),

	gh("neovim/nvim-lspconfig"),
	gh("stevearc/conform.nvim"),
	gh("williamboman/mason.nvim"),
	gh("williamboman/mason-lspconfig.nvim"),

	{ src = gh("L3MON4D3/LuaSnip"), version = vim.version.range("2.*") },
	{ src = gh("saghen/blink.cmp"), version = vim.version.range("1.*") },
})

require("guess-indent").setup()

require("zen-mode").setup({ window = { backdrop = 1 } })

require("mason").setup({ ui = { backdrop = 100 } })
require("mason-lspconfig").setup()

-- make --directory ~/.local/share/nvim/site/pack/core/opt/telescope-fzf-native.nvim
require("telescope").setup({ defaults = { layout_strategy = "vertical" } })
require("telescope").load_extension("fzf")

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

require("gitsigns").setup({
	signs_staged_enable = false,
	signs = {
		add = { text = "+" },
		change = { text = "~" },
		delete = { text = "_" },
		topdelete = { text = "‾" },
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

vim.keymap.set("n", "grn", vim.lsp.buf.rename)
vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "gra", vim.lsp.buf.code_action)

vim.keymap.set("n", "<leader>gf", require("conform").format)

local gs = require("gitsigns")

vim.keymap.set("n", "<leader>gb", gs.blame_line)
vim.keymap.set("n", "<leader>gr", gs.reset_hunk)
vim.keymap.set("n", "<leader>gs", gs.stage_hunk)
vim.keymap.set("n", "<leader>gp", gs.preview_hunk)

local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>fr", builtin.resume)
vim.keymap.set("n", "<leader>fo", builtin.oldfiles)
vim.keymap.set("n", "<leader>fg", builtin.live_grep)
vim.keymap.set("n", "<leader>fh", builtin.help_tags)
vim.keymap.set("n", "<leader>fs", builtin.git_status)
vim.keymap.set("n", "<leader>ff", builtin.find_files)
