vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.netrw_banner = false

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"

vim.opt.list = true
vim.opt.listchars = { tab = "··", trail = "·" }
vim.opt.breakindent = true
vim.opt.expandtab = true

vim.opt.clipboard = "unnamedplus"
vim.opt.guicursor = "n-v-c-i:block-nCursor"
vim.opt.termguicolors = true

vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.laststatus = 3
vim.opt.scrolloff = 4

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = false

vim.opt.undofile = true
vim.opt.wrap = false

vim.keymap.set({ "n", "v" }, "j", "gj")
vim.keymap.set({ "n", "v" }, "k", "gk")

vim.keymap.set({ "n", "v" }, "<C-D>", "<C-D>zz")
vim.keymap.set({ "n", "v" }, "<C-U>", "<C-U>zz")

vim.keymap.set({ "n", "v" }, "<C-j>", "<cmd>cnext<CR>")
vim.keymap.set({ "n", "v" }, "<C-k>", "<cmd>cprevious<CR>")
vim.keymap.set({ "n", "v" }, "<C-l>", "<cmd>lnext<CR>")
vim.keymap.set({ "n", "v" }, "<C-h>", "<cmd>lprevious<CR>")

vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
    callback = function(e)
        local opts = { buffer = e.buf }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "grD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "grt", vim.lsp.buf.type_definition, opts)
        vim.keymap.set("n", "gW", vim.lsp.buf.workspace_symbol, opts)
        vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)
    end,
})

vim.diagnostic.config({ virtual_lines = { current_line = true } })

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--branch=stable",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    change_detection = { notify = false },
    spec = {
        { "tpope/vim-sleuth" },
        { "ellisonleao/gruvbox.nvim" },
        { "norcalli/nvim-colorizer.lua" },
        {
            "folke/todo-comments.nvim",
            dependencies = { "nvim-lua/plenary.nvim" },
            opts = { signs = false },
        },
        {
            "gbprod/nord.nvim",
            lazy = false,
            priority = 1000,
            config = function()
                require("nord").setup({ transparent = true })
                vim.cmd.colorscheme("nord")
            end,
        },
        {
            "nvim-lualine/lualine.nvim",
            opts = {
                options = {
                    icons_enabled = false,
                    component_separators = "",
                    section_separators = "",
                },
                sections = {
                    lualine_b = { "branch" },
                    lualine_x = {},
                },
            },
        },
        {
            "lewis6991/gitsigns.nvim",
            config = function()
                require("gitsigns").setup({
                    signs = {
                        add = { text = "+" },
                        change = { text = "~" },
                        delete = { text = "-" },
                        topdelete = { text = "-" },
                    },
                    signs_staged_enable = false,
                })

                vim.keymap.set({ "n", "v" }, "gb", "<cmd>Gitsigns blame_line<CR>")
                vim.keymap.set({ "n", "v" }, "gp", "<cmd>Gitsigns preview_hunk<CR>")
            end,
        },
        {
            "nvim-treesitter/nvim-treesitter",
            build = ":TSUpdate",
            main = "nvim-treesitter.configs",
            opts = {
                sync_install = false,
                auto_install = true,
                indent = { enable = true },
                highlight = { enable = true },
            },
        },
        {
            "nvim-telescope/telescope.nvim",
            tag = "0.1.8",
            dependencies = {
                "nvim-lua/plenary.nvim",
                { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
            },
            config = function()
                require("telescope").setup()
                require("telescope").load_extension("fzf")

                vim.keymap.set("n", "<leader>sr", require("telescope.builtin").resume)
                vim.keymap.set("n", "<leader>so", require("telescope.builtin").oldfiles)
                vim.keymap.set("n", "<leader>sg", require("telescope.builtin").live_grep)
                vim.keymap.set("n", "<leader>sG", require("telescope.builtin").git_files)
                vim.keymap.set("n", "<leader>sf", require("telescope.builtin").find_files)
            end,
        },
        {
            "saghen/blink.cmp",
            dependencies = { "rafamadriz/friendly-snippets" },
            version = "1.*",
            opts = {
                keymap = {
                    preset = "default",
                    ["<Tab>"] = { "accept", "fallback" },
                },
                completion = {
                    accept = { auto_brackets = { enabled = false } },
                    menu = {
                        draw = {
                            columns = {
                                { "label", "label_description", gap = 1 },
                                { "kind" },
                            },
                        },
                    },
                },
            },
            opts_extend = { "sources.default" },
        },
        {
            "stevearc/conform.nvim",
            config = function()
                require("conform").setup({
                    formatters_by_ft = {
                        lua = { "stylua" },
                        nix = { "alejandra" },
                        python = { "ruff_format" },
                        css = { "prettierd" },
                        scss = { "prettierd" },
                        javascript = { "prettierd" },
                        typescript = { "prettierd" },
                        javascriptreact = { "prettierd" },
                        typescriptreact = { "prettierd" },
                    },
                    default_format_opts = { async = true, lsp_format = "fallback" },
                })

                vim.keymap.set("n", "<leader>f", require("conform").format)
            end,
        },
        {
            "neovim/nvim-lspconfig",
            dependencies = {
                "saghen/blink.cmp",
                "williamboman/mason.nvim",
                "williamboman/mason-lspconfig.nvim",
            },
            config = function()
                vim.lsp.config("*", {
                    root_markers = { ".git" },
                    capabilities = require("blink.cmp").get_lsp_capabilities({
                        textDocument = {
                            foldingRange = {
                                dynamicRegistration = false,
                                lineFoldingOnly = true,
                            },
                        },
                    }),
                })

                vim.lsp.config("lua_ls", {
                    settings = {
                        Lua = {
                            runtime = { version = "LuaJIT" },
                            diagnostics = { globals = { "vim" } },
                        },
                    },
                })

                vim.lsp.config("nil_ls", {
                    settings = {
                        ["nil"] = {
                            nix = { flake = { autoArchive = true } },
                        },
                    },
                })

                vim.lsp.config("rust_analyzer", {
                    settings = {
                        ["rust-analyzer"] = {
                            cargo = { features = "all" },
                            check = { command = "clippy" },
                            interpret = { tests = true },
                        },
                    },
                })

                require("mason").setup()
                require("mason-lspconfig").setup()
            end,
        },
    },
})
