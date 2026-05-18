-- Quitar keymaps globales que nvim 0.11 agrega por defecto
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local keymap = vim.keymap
    local bufopts = { noremap = true, silent = true, buffer = args.buf }

    keymap.set("n", "gr",        vim.lsp.buf.references,    bufopts)
    keymap.set("n", "gd",        vim.lsp.buf.definition,    bufopts)
    keymap.set("n", "<space>rn", vim.lsp.buf.rename,        bufopts)
    keymap.set("n", "K",         vim.lsp.buf.hover,         bufopts)
    keymap.set("n", "[d",        vim.diagnostic.goto_prev,  bufopts)
    keymap.set("n", "]d",        vim.diagnostic.goto_next,  bufopts)
  end
})
