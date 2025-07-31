vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.netrw_banner = false

vim.opt.listchars = { tab = "··", trail = "·" }
vim.opt.guicursor = "n-v-c-i:block-nCursor"
vim.opt.clipboard = "unnamedplus"
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.winborder = "single"
vim.opt.breakindent = true
vim.opt.colorcolumn = "80"
vim.opt.signcolumn = "yes"
vim.opt.ignorecase = true
vim.opt.cursorline = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.expandtab = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = false
vim.opt.undofile = true
vim.opt.shiftwidth = 4
vim.opt.laststatus = 3
vim.opt.number = true
vim.opt.scrolloff = 4
vim.opt.wrap = false
vim.opt.list = true
vim.opt.tabstop = 4

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

vim.pack.add({
    { src = "https://github.com/tpope/vim-sleuth" },
    { src = "https://github.com/gbprod/nord.nvim" },
    { src = "https://github.com/j-hui/fidget.nvim" },
    { src = "https://github.com/nvim-lua/plenary.nvim" },
    { src = "https://github.com/stevearc/conform.nvim" },
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://github.com/lewis6991/gitsigns.nvim" },
    { src = "https://github.com/williamboman/mason.nvim" },
    { src = "https://github.com/folke/todo-comments.nvim" },
    { src = "https://github.com/rafamadriz/friendly-snippets" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
    { src = "https://github.com/williamboman/mason-lspconfig.nvim" },
    { src = "https://github.com/saghen/blink.cmp", version = "v1.6.0" },
    { src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim" },
    {
        src = "https://github.com/nvim-telescope/telescope.nvim",
        version = "0.1.8",
    },
})

require("nord").setup({ transparent = true })

vim.cmd.colorscheme("nord")

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

require("mason").setup()
require("mason-lspconfig").setup()

require("todo-comments").setup({ signs = false })

require("fidget").setup({
    notification = { window = { winblend = 0 } },
})

require("nvim-treesitter.configs").setup({
    auto_install = true,
    sync_install = false,
    highlight = { enable = true },
})

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

require("telescope").setup({
    defaults = {
        layout_config = {
            width = { padding = 0 },
            height = { padding = 0 },
        },
    },
})

require("telescope").load_extension("fzf")

vim.keymap.set("n", "<leader>sr", require("telescope.builtin").resume)
vim.keymap.set("n", "<leader>sb", require("telescope.builtin").buffers)
vim.keymap.set("n", "<leader>so", require("telescope.builtin").oldfiles)
vim.keymap.set("n", "<leader>sh", require("telescope.builtin").help_tags)
vim.keymap.set("n", "<leader>sg", require("telescope.builtin").live_grep)
vim.keymap.set("n", "<leader>sd", require("telescope.builtin").diagnostics)
vim.keymap.set("n", "<leader>sf", function()
    if vim.uv.fs_stat(".git") then
        require("telescope.builtin").git_files({ show_untracked = true })
    else
        require("telescope.builtin").find_files()
    end
end)

require("blink.cmp").setup({
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
})

require("conform").setup({
    formatters_by_ft = {
        json = { "jq" },
        jsonc = { "jq" },
        lua = { "stylua" },
        nix = { "alejandra" },
        css = { "prettierd" },
        html = { "prettierd" },
        python = { "ruff_format" },
        javascript = { "prettierd" },
        typescript = { "prettierd" },
        javascriptreact = { "prettierd" },
        typescriptreact = { "prettierd" },
    },
    default_format_opts = { async = true, lsp_format = "fallback" },
})

vim.keymap.set("n", "<leader>f", require("conform").format)
