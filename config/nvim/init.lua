--- @param repo string
--- @return string url
local function gh(repo)
	return "https://github.com/" .. repo
end

-- options
do
	vim.g.netrw_preview = 1
	vim.g.netrw_banner = 0
	vim.g.mapleader = " "

	vim.o.clipboard = "unnamedplus"
	vim.o.winborder = "rounded"
	vim.o.background = "light"
	vim.o.inccommand = "split"
	vim.o.colorcolumn = "80"
	vim.o.signcolumn = "yes"

	vim.o.relativenumber = true
	vim.o.termguicolors = true
	vim.o.ignorecase = true
	vim.o.cursorline = true
	vim.o.splitright = true
	vim.o.splitbelow = true
	vim.o.expandtab = true
	vim.o.smartcase = true
	vim.o.swapfile = false
	vim.o.undofile = true
	vim.o.confirm = true
	vim.o.number = true
	vim.o.wrap = false
	vim.o.list = true

	vim.o.laststatus = 3
	vim.o.scrolloff = 8
	vim.o.tabstop = 4
end

-- keys
do
	vim.keymap.set({ "n", "v" }, "j", "gj")
	vim.keymap.set({ "n", "v" }, "k", "gk")

	vim.keymap.set("n", "<C-h>", "<C-w><C-h>")
	vim.keymap.set("n", "<C-l>", "<C-w><C-l>")
	vim.keymap.set("n", "<C-j>", "<C-w><C-j>")
	vim.keymap.set("n", "<C-k>", "<C-w><C-k>")

	vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<cr>")

	vim.keymap.set("n", "<leader>h", function()
		local enable = not vim.lsp.inlay_hint.is_enabled()
		vim.lsp.inlay_hint.enable(enable)
	end)
end

-- commands
do
	vim.api.nvim_create_autocmd("TextYankPost", {
		group = vim.api.nvim_create_augroup("yank-highlight", { clear = true }),
		callback = function()
			vim.hl.on_yank()
		end,
	})

	vim.api.nvim_create_autocmd("PackChanged", {
		group = vim.api.nvim_create_augroup("pack-build", { clear = true }),
		callback = function(e)
			local name = e.data.spec.name
			local kind = e.data.kind
			if kind ~= "install" and kind ~= "update" then
				return
			end

			if name == "LuaSnip" then
				vim.system({ "make", "install_jsregexp" }, { cwd = e.data.path }):wait()
			end

			if name == "nvim-treesitter" then
				if not e.data.active then
					vim.cmd.packadd("nvim-treesitter")
				end

				vim.cmd("TSUpdate")
			end

			if name == "molten-nvim" then
				vim.cmd("UpdateRemotePlugins")
			end
		end,
	})

	local open_floating_preview = vim.lsp.util.open_floating_preview
	---@diagnostic disable-next-line: duplicate-set-field
	function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
		local bufnr, winid = open_floating_preview(contents, syntax, opts, ...)
		if winid and vim.api.nvim_win_is_valid(winid) then
			vim.wo[winid].conceallevel = 0

			local texth = vim.api.nvim_win_text_height(winid, {}).all
			local maxh = (opts and opts.max_height) or (vim.o.lines - 4)

			vim.api.nvim_win_set_height(winid, math.min(texth, maxh))
		end

		return bufnr, winid
	end
end

-- ui
do
	vim.pack.add({ gh("projekt0n/github-nvim-theme") })

	vim.cmd.colorscheme("github_light")
	vim.api.nvim_set_hl(0, "Normal", {})
	vim.api.nvim_set_hl(0, "NormalFloat", {})

	vim.pack.add({ gh("nvim-lualine/lualine.nvim") })

	require("lualine").setup({
		options = { section_separators = "", component_separators = "" },
		sections = {
			lualine_a = {},
			lualine_b = {},
			lualine_c = { "mode", "filename", { "branch", icon = "" } },
			lualine_x = { "filetype", "progress", "location" },
			lualine_y = {},
			lualine_z = {},
		},
	})

	vim.pack.add({
		gh("folke/todo-comments.nvim"),
		gh("nmac427/guess-indent.nvim"),
		gh("nvim-tree/nvim-web-devicons"),
	})

	require("guess-indent").setup()
	require("todo-comments").setup({ signs = false })
end

-- git
do
	vim.pack.add({ gh("lewis6991/gitsigns.nvim") })

	local gitsigns = require("gitsigns")

	gitsigns.setup()

	vim.keymap.set("n", "<leader>gh", gitsigns.preview_hunk)

	vim.keymap.set("n", "<leader>gB", gitsigns.blame)
	vim.keymap.set("n", "<leader>gR", gitsigns.reset_buffer)
	vim.keymap.set("n", "<leader>gS", gitsigns.stage_buffer)

	vim.keymap.set("n", "<leader>gb", gitsigns.blame_line)
	vim.keymap.set("n", "<leader>gr", gitsigns.reset_hunk)
	vim.keymap.set("n", "<leader>gs", gitsigns.stage_hunk)

	vim.keymap.set("n", "<leader>gn", function()
		gitsigns.nav_hunk("next")
	end)

	vim.keymap.set("n", "<leader>gp", function()
		gitsigns.nav_hunk("prev")
	end)
end

-- navigation
do
	vim.pack.add({ gh("folke/snacks.nvim") })

	local snacks = require("snacks")
	local picker = snacks.picker

	snacks.setup({
		picker = {
			layout = { preset = "vertical" },
			previewers = { diff = "syntax" },
			formatters = {
				file = { filename_first = true },
			},
			sources = {
				grep = { hidden = true },
				files = { hidden = true },
				explorer = { hidden = true },
			},
		},
	})

	vim.keymap.set("n", "<leader>t", snacks.terminal.open)
	vim.keymap.set("n", "<leader>e", snacks.explorer.open)

	-- finder
	vim.keymap.set("n", "<leader>fh", picker.help)
	vim.keymap.set("n", "<leader>fg", picker.grep)
	vim.keymap.set("n", "<leader>ff", picker.files)
	vim.keymap.set("n", "<leader>fr", picker.resume)
	vim.keymap.set("n", "<leader>fo", picker.recent)
	vim.keymap.set("n", "<leader>fs", picker.git_status)

	-- lsp
	vim.keymap.del("n", "grt")
	vim.keymap.del("n", "gri")
	vim.keymap.del("n", "grr")
	vim.keymap.del("n", "grx")
	vim.keymap.del("x", "gra")
	vim.keymap.del("n", "gra")
	vim.keymap.del("n", "grn")

	vim.keymap.set("n", "gn", vim.lsp.buf.rename)
	vim.keymap.set("n", "ga", vim.lsp.buf.code_action)

	vim.keymap.set("n", "gr", picker.lsp_references)
	vim.keymap.set("n", "gd", picker.lsp_definitions)
	vim.keymap.set("n", "gD", picker.lsp_declarations)
	vim.keymap.set("n", "gi", picker.lsp_implementations)
	vim.keymap.set("n", "gt", picker.lsp_type_definitions)

	vim.keymap.set("n", "gW", picker.lsp_symbols)
	vim.keymap.set("n", "gO", picker.lsp_workspace_symbols)
end

-- lsp
do
	vim.pack.add({ gh("j-hui/fidget.nvim") })

	local fidget = require("fidget")
	fidget.setup()

	vim.notify = fidget.notify

	vim.pack.add({
		gh("neovim/nvim-lspconfig"),
		gh("williamboman/mason.nvim"),
		gh("williamboman/mason-lspconfig.nvim"),
	})

	require("mason").setup()
	require("mason-lspconfig").setup()

	vim.diagnostic.config({ virtual_text = true })
end

-- completion
do
	vim.pack.add({
		{ src = gh("saghen/blink.cmp"), version = vim.version.range("1.*") },
		{ src = gh("L3MON4D3/LuaSnip"), version = vim.version.range("2.*") },
	})

	require("luasnip").setup()
	require("blink.cmp").setup({
		signature = { enabled = true },
		snippets = { preset = "luasnip" },
		completion = { menu = { scrollbar = false } },
	})
end

-- format
do
	vim.pack.add({ gh("stevearc/conform.nvim") })

	local conform = require("conform")

	conform.setup({
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

	vim.keymap.set("n", "<leader>gf", conform.format)
end

-- jupyter
do
	vim.pack.add({ gh("GCBallesteros/jupytext.nvim") })

	require("jupytext").setup({
		style = "markdown",
		force_ft = "markdown",
		output_extension = "md",
	})

	vim.pack.add({
		gh("3rd/image.nvim"),
		gh("jmbuhr/otter.nvim"),
		{ src = gh("benlubas/molten-nvim"), version = vim.version.range("1.*") },
	})

	require("otter").setup()

	vim.api.nvim_create_autocmd("FileType", {
		pattern = "markdown",
		callback = function(e)
			if vim.bo[e.buf].buftype ~= "" then
				return
			end

			require("otter").activate()
		end,
	})

	vim.g.molten_image_provider = "image.nvim"
	vim.g.molten_output_win_max_height = 20
	vim.g.molten_auto_open_output = false
	vim.g.molten_virt_text_output = true

	require("image").setup()

	vim.keymap.set("n", "<leader>ji", "<cmd>MoltenInit<cr>")
	vim.keymap.set("v", "<leader>je", ":<C-u>MoltenEvaluateVisual<cr>gv")
	vim.keymap.set("n", "<leader>jr", "<cmd>MoltenReevaluateCell<cr>")
	vim.keymap.set("n", "<leader>jd", "<cmd>MoltenDelete<cr>")
end

-- treesitter
do
	vim.pack.add({ { src = gh("nvim-treesitter/nvim-treesitter"), version = "main" } })

	local parsers = {
		"c",
		"go",
		"cpp",
		"css",
		"lua",
		"jsx",
		"sql",
		"tsx",
		"vue",
		"xml",
		"zig",
		"bash",
		"html",
		"json",
		"just",
		"make",
		"rust",
		"toml",
		"yaml",
		"cmake",
		"nginx",
		"latex",
		"typst",
		"python",
		"svelte",
		"markdown",
		"terraform",
		"dockerfile",
		"javascript",
		"typescript",
		"markdown_inline",
	}

	local ts = require("nvim-treesitter")

	ts.setup()
	ts.install(parsers)

	vim.api.nvim_create_autocmd("FileType", {
		callback = function(e)
			local lang = vim.treesitter.language.get_lang(e.match)
			if not lang then
				return
			end

			if vim.treesitter.language.add(lang) then
				vim.treesitter.start(e.buf, lang)
				return
			end
		end,
	})
end
