vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.netrw_banner = false

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.list = true
vim.opt.listchars = { tab = "··", trail = "·" }
vim.opt.termguicolors = true
vim.opt.guicursor = "n-v-c-i:block-nCursor"
vim.opt.cursorline = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.laststatus = 3
vim.opt.scrolloff = 4
vim.opt.clipboard = "unnamedplus"
vim.opt.signcolumn = "yes"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = false
vim.opt.breakindent = true
vim.opt.expandtab = true
vim.opt.undofile = true
vim.opt.wrap = false

vim.keymap.set({ "n", "v" }, "j", "gj")
vim.keymap.set({ "n", "v" }, "k", "gk")
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
        { "norcalli/nvim-colorizer.lua" },
        {
            "shaunsingh/nord.nvim",
            lazy = false,
            priority = 1000,
            config = function()
                vim.g.nord_disable_background = true
                vim.g.nord_contrast = true
                vim.g.nord_bold = false

                vim.cmd.colorscheme("nord")
            end,
        },
        {
            "lewis6991/gitsigns.nvim",
            opts = {
                signs = {
                    add = { text = "+" },
                    change = { text = "~" },
                },
            },
        },
        {
            "nvim-treesitter/nvim-treesitter",
            build = ":TSUpdate",
            config = function()
                require("nvim-treesitter.configs").setup({
                    sync_install = false,
                    auto_install = true,
                    indent = { enable = true },
                    highlight = { enable = true },
                })
            end,
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
                cmdline = {
                    keymap = {
                        preset = "default",
                        ["<Tab>"] = { "accept", "show_and_insert", "fallback" },
                    },
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
                        javascript = { "prettierd" },
                        typescript = { "prettierd" },
                        javascriptreact = { "prettierd" },
                        typescriptreact = { "prettierd" },
                    },
                })

                vim.keymap.set("n", "<leader>f", function()
                    require("conform").format({ async = true, lsp_format = "fallback" })
                end)
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
                require("mason-lspconfig").setup({
                    automatic_enable = { exclude = { "ruff" } },
                })
            end,
        },
    },
})
