return {
    "hrsh7th/nvim-cmp",
    dependencies = {
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-nvim-lsp",
    },
    config = function ()
        local cmp = require("cmp")

        cmp.setup({
            completion = { completeopt = "menu,menuone,noinsert" },
            mapping = cmp.mapping.preset.insert({
                ["<Tab>"] = cmp.mapping.confirm({ select = true }),
                ["<C-y>"] = cmp.mapping.confirm({ select = true }),
                ["<C-n>"] = cmp.mapping.select_next_item(),
                ["<C-p>"] = cmp.mapping.select_prev_item(),
                ["<C-Space>"] = cmp.mapping.complete({}),
            }),
            sources = {
                { name = "nvim_lsp" },
                { name = "buffer" },
                { name = "path" },
            },
        })
    end
}
