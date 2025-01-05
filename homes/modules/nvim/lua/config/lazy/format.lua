return {
    "stevearc/conform.nvim",
    opts = {
        notify_on_error = false,
        formatters_by_ft = {
            lua = { "stylua" },
            yml = { "ymlfmt" },
            c = { "clang-format" },
            py = { "ruff_format" },
            javascript = { "prettierd" },
            typescript = { "prettierd" },
            ["_"] = { "trim_whitespace" },
        },
    },
    config = function()
        local format = function()
            require("conform").format({ async = true, lsp_format = "fallback" })
        end

        vim.keymap.set({ "n", "v" }, "<leader>f", format, { desc = "Format" })
    end
}
