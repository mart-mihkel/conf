vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
    callback = function() vim.highlight.on_yank() end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("trim-whitespace", { clear = true }),
    command = [[%s/\s\+$//e]],
})

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
    callback = function(e)
        local opts = { buffer = e.buf }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "grd", vim.lsp.buf.document_symbol, opts)
        vim.keymap.set("n", "grw", vim.lsp.buf.workspace_symbol, opts)

        vim.keymap.set("n", "gq", vim.diagnostic.setloclist, opts)
        vim.keymap.set("n", "ge", vim.diagnostic.open_float, opts)
    end,
})
