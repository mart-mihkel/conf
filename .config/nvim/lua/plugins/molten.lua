return {
    "benlubas/molten-nvim",
    version = "^1.0.0",
    dependencies = { "3rd/image.nvim" },
    build = ":UpdateRemotePlugins",
    init = function()
        vim.g.molten_image_provider = "image.nvim"

        vim.keymap.set("n", "<leader>mi", ":MoltenInit python<CR>")
        vim.keymap.set("n", "<leader>mr", ":MoltenRestart<CR>")

        vim.keymap.set("n", "<leader>ml", ":MoltenEvaluateLine<CR>")
        vim.keymap.set("n", "<leader>mo", ":MoltenEvaluateOperator<CR>")
        vim.keymap.set("v", "mv", ":<C-u>MoltenEvaluateVisual<CR>gv")

        vim.keymap.set("n", "<leader>md", ":MoltenDelete<CR>")
        vim.keymap.set("n", "<leader>mh", ":MoltenHideOutput<CR>")
    end,
}
