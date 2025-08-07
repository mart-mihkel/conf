vim.g.mapleader = " "
vim.g.netrw_banner = false

vim.opt.listchars = { tab = "··", trail = "·" }
vim.opt.guicursor = "n-v-c-i:block-nCursor"
vim.opt.clipboard = "unnamedplus"
vim.opt.winborder = "single"
vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = "80"

vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.breakindent = true
vim.opt.ignorecase = true
vim.opt.cursorline = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.expandtab = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.swapfile = false
vim.opt.hlsearch = false
vim.opt.undofile = true
vim.opt.number = true
vim.opt.wrap = false
vim.opt.list = true

vim.opt.shiftwidth = 4
vim.opt.scrolloff = 4
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
    group = vim.api.nvim_create_augroup("highlight-yank", {}),
    callback = function()
        vim.highlight.on_yank()
    end,
})

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp-attach", {}),
    callback = function(e)
        local opts = { buffer = e.buf }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)
        vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)
    end,
})

vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            runtime = { version = "LuaJIT" },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
            },
        },
    },
})

vim.lsp.config("rust_analyzer", {
    settings = {
        ["rust-analyzer"] = {
            cargo = { features = "all" },
        },
    },
})

vim.diagnostic.config({
    virtual_lines = { current_line = true },
})

vim.pack.add({
    { src = "https://github.com/gbprod/nord.nvim" },
    { src = "https://github.com/nvim-lua/plenary.nvim" },
    { src = "https://github.com/stevearc/conform.nvim" },
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://github.com/lewis6991/gitsigns.nvim" },
    { src = "https://github.com/williamboman/mason.nvim" },
    { src = "https://github.com/mart-mihkel/pshada.nvim" },
    { src = "https://github.com/folke/todo-comments.nvim" },
    { src = "https://github.com/NMAC427/guess-indent.nvim" },
    { src = "https://github.com/rafamadriz/friendly-snippets" },
    { src = "https://github.com/nvim-telescope/telescope.nvim" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
    { src = "https://github.com/williamboman/mason-lspconfig.nvim" },
    { src = "https://github.com/saghen/blink.cmp", version = "v1.6.0" },
})

vim.lsp.config("*", {
    root_markers = { ".git" },
    capabilities = require("blink.cmp").get_lsp_capabilities(),
})

require("mason").setup()
require("pshada").setup()
require("gitsigns").setup()
require("telescope").setup()
require("guess-indent").setup({})
require("mason-lspconfig").setup()
require("nord").setup({ transparent = true })
require("todo-comments").setup({ signs = false })

require("blink.cmp").setup({
    completion = {
        accept = { auto_brackets = { enabled = false } },
    },
})

require("nvim-treesitter.configs").setup({
    modules = {},
    ignore_install = {},
    auto_install = true,
    sync_install = false,
    ensure_installed = {},
    indent = { enable = true },
    highlight = { enable = true },
})

require("conform").setup({
    default_format_opts = { async = true, lsp_format = "fallback" },
    formatters_by_ft = {
        json = { "jq" },
        lua = { "stylua" },
        css = { "prettierd" },
        html = { "prettierd" },
        python = { "ruff_format" },
        javascript = { "prettierd" },
        typescript = { "prettierd" },
    },
})

vim.cmd.colorscheme("nord")

vim.keymap.set("n", "<leader>f", require("conform").format)
vim.keymap.set("n", "<leader>gb", require("gitsigns").blame_line)
vim.keymap.set("n", "<leader>gp", require("gitsigns").preview_hunk)
vim.keymap.set("n", "<leader>sr", require("telescope.builtin").resume)
vim.keymap.set("n", "<leader>sg", require("telescope.builtin").live_grep)
vim.keymap.set("n", "<leader>sf", function()
    if vim.uv.fs_stat(".git") then
        require("telescope.builtin").git_files({ show_untracked = true })
    else
        require("telescope.builtin").find_files()
    end
end)
