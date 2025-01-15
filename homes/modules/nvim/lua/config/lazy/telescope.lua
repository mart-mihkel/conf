return {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
        'nvim-lua/plenary.nvim',
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }
    },
    config = function()
        require('telescope').setup()

        pcall(require('telescope').load_extension, 'fzf')

        local builtin = require 'telescope.builtin'
        vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = 'Search resume' })
        vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = 'Search grep' })
        vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = 'Search help' })
        vim.keymap.set('n', '<leader>sb', builtin.buffers, { desc = 'Search buffers' })
        vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = 'Search files' })
        vim.keymap.set('n', '<leader>so', builtin.oldfiles, { desc = 'Search old files' })
        vim.keymap.set('n', '<leader>/', builtin.current_buffer_fuzzy_find, { desc = 'Search current buffer' })
    end,
}
