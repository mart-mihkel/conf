return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local harpoon = require("harpoon")

        harpoon:setup()

        local h_add = function()
            harpoon:list():add()
        end

        local h_list = function()
            harpoon.ui:toggle_quick_menu(harpoon:list())
        end

        vim.keymap.set("n", "<leader>a", h_add, { desc = "Harpoon add" })
        vim.keymap.set("n", "<leader>h", h_list, { desc = "Harpoon list" })
    end,
}
