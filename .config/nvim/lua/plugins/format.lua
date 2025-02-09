return {
    "stevearc/conform.nvim",
    config = function()
        local conform = require("conform")

        conform.setup({
            formatters_by_ft = {
                lua = { "stylua" },
                nix = { "nixpkgs_fmt" },
                python = { "ruff_format" },
                markdown = { "markdownlint" },

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
}
