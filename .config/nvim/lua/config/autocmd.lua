vim.api.nvim_create_autocmd("VimEnter", {
    desc = "Open netrw on enter",
    group = vim.api.nvim_create_augroup("netrw-enter", { clear = true }),
    callback = function()
        if vim.fn.argc() == 0 then
            vim.cmd("Explore .")
        end
    end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking text",
    group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})
