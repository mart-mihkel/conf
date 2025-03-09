return {
    "nvim-telescope/telescope.nvim",
    event = "VimEnter",
    branch = "0.1.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
        local telescope = require("telescope")
        local builtin = require("telescope.builtin")

        telescope.setup({
            defaults = { layout_strategy = "vertical" },
        })

        pcall(telescope.load_extension, "fzf")

        vim.keymap.set("n", "<leader>sr", builtin.resume)
        vim.keymap.set("n", "<leader>sb", builtin.buffers)
        vim.keymap.set("n", "<leader>so", builtin.oldfiles)
        vim.keymap.set("n", "<leader>sg", builtin.git_files)
        vim.keymap.set("n", "<leader>sw", builtin.live_grep)
        vim.keymap.set("n", "<leader>sh", builtin.help_tags)
        vim.keymap.set("n", "<leader>sf", builtin.find_files)
        vim.keymap.set("n", "<leader>/", builtin.current_buffer_fuzzy_find)
    end,
}
