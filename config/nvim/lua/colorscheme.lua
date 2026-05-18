local ok, _ = pcall(vim.cmd, "colorscheme catppuccin")
if not ok then
  vim.notify("colorscheme catppuccin not found, using default")
end
