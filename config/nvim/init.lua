vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.netrw_banner = false

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = "80"

vim.opt.list = true
vim.opt.listchars = { tab = "··", trail = "·" }
vim.opt.breakindent = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4

vim.opt.winborder = "single"
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

-- NOTE: see telescope.nvim#3436
vim.api.nvim_create_autocmd("User", {
    pattern = "TelescopeFindPre",
    callback = function()
        vim.opt_local.winborder = "none"
        vim.api.nvim_create_autocmd("WinLeave", {
            once = true,
            callback = function()
                vim.opt_local.winborder = "single"
            end,
        })
    end,
})

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
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
            "gbprod/nord.nvim",
            lazy = false,
            priority = 1000,
            config = function()
                require("nord").setup({ transparent = true })
                vim.cmd.colorscheme("nord")
            end,
        },
        {
            "folke/todo-comments.nvim",
            dependencies = { "nvim-lua/plenary.nvim" },
            opts = { signs = false },
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
                auto_install = true,
                sync_install = false,
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
                local telescope = require("telescope")
                local builtin = require("telescope.builtin")

                telescope.setup()
                telescope.load_extension("fzf")

                vim.keymap.set("n", "<leader>sr", builtin.resume)
                vim.keymap.set("n", "<leader>sb", builtin.buffers)
                vim.keymap.set("n", "<leader>so", builtin.oldfiles)
                vim.keymap.set("n", "<leader>sh", builtin.help_tags)
                vim.keymap.set("n", "<leader>sg", builtin.live_grep)
                vim.keymap.set("n", "<leader>sd", builtin.diagnostics)

                vim.keymap.set("n", "<leader>sf", function()
                    if vim.uv.fs_stat(".git") then
                        builtin.git_files({ show_untracked = true })
                    else
                        builtin.find_files()
                    end
                end)
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
                local conform = require("conform")
                conform.setup({
                    formatters_by_ft = {
                        json = { "jq" },
                        lua = { "stylua" },
                        nix = { "alejandra" },
                        python = { "ruff_format" },
                        css = { "prettierd" },
                        html = { "prettierd" },
                        javascript = { "prettierd" },
                        typescript = { "prettierd" },
                        javascriptreact = { "prettierd" },
                        typescriptreact = { "prettierd" },
                    },
                    default_format_opts = { async = true, lsp_format = "fallback" },
                })

                vim.keymap.set("n", "<leader>f", conform.format)
            end,
        },
        {
            "neovim/nvim-lspconfig",
            dependencies = {
                "saghen/blink.cmp",
                "williamboman/mason.nvim",
                "williamboman/mason-lspconfig.nvim",
                {
                    "j-hui/fidget.nvim",
                    opts = { notification = { window = { winblend = 0 } } },
                },
            },
            config = function()
                vim.diagnostic.config({ virtual_lines = { current_line = true } })

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
