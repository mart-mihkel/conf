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
        vim.keymap.set("n", "gq", vim.diagnostic.setloclist, opts)
        vim.keymap.set("n", "ge", vim.diagnostic.open_float, opts)
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
    lockfile = "/dev/null",
    spec = {
        { "tpope/vim-sleuth" },
        { "folke/zen-mode.nvim" },
        { "norcalli/nvim-colorizer.lua" },
        { "nvim-tree/nvim-web-devicons" },
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
            "nvim-lualine/lualine.nvim",
            opts = {
                options = {
                    section_separators = { left = "", right = "" },
                    component_separators = { left = "", right = "" },
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { "branch" },
                    lualine_c = { "filename" },
                    lualine_x = { "filetype" },
                    lualine_y = { "progress" },
                    lualine_z = { "location" },
                },
            },
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
                local telescope = require("telescope")
                local builtin = require("telescope.builtin")

                telescope.setup()
                telescope.load_extension("fzf")

                vim.keymap.set("n", "<leader>sr", builtin.resume)
                vim.keymap.set("n", "<leader>so", builtin.oldfiles)
                vim.keymap.set("n", "<leader>sg", builtin.live_grep)
                vim.keymap.set("n", "<leader>sG", builtin.git_files)
                vim.keymap.set("n", "<leader>sf", builtin.find_files)
            end,
        },
        {
            "saghen/blink.cmp",
            dependencies = { "rafamadriz/friendly-snippets" },
            version = "1.*",
            opts = {
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
                        lua = { "stylua" },
                        nix = { "alejandra" },
                        python = { "ruff_format" },
                        yml = { "yamlfmt" },
                        yaml = { "yamlfmt" },
                        javascript = { "prettierd" },
                        typescript = { "prettierd" },
                        javascriptreact = { "prettierd" },
                        typescriptreact = { "prettierd" },
                    },
                })

                vim.keymap.set("n", "<leader>f", function()
                    conform.format({ async = true, lsp_format = "fallback" })
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
