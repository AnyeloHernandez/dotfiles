local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  rocks = { enabled = false },

  -- Copilot
  "github/copilot.vim",

  -- Tema
  "tanvirtin/monokai.nvim",

  -- NERDTree
  {
    "preservim/nerdtree",
    dependencies = { "ryanoasis/vim-devicons" },
    config = function()
      vim.g.NERDTreeShowHidden = 1
      vim.g.NERDTreeMinimalUI = 1
      vim.g.NERDTreeWinSize = 30
      vim.g.webdevicons_enable_nerdtree = 1

      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          vim.cmd("NERDTree")
          vim.cmd("wincmd p")
        end,
      })
      vim.api.nvim_create_autocmd("BufEnter", {
        callback = function()
          if vim.fn.tabpagenr("$") == 1
            and vim.fn.winnr("$") == 1
            and vim.b.NERDTree ~= nil
          then
            vim.cmd("quit")
          end
        end,
      })

      vim.keymap.set("n", "<C-b>", ":NERDTreeToggle<CR>", { silent = true })
      vim.keymap.set("n", "<C-f>", ":NERDTreeFind<CR>", { silent = true })
    end,
  },

  -- Treesitter
{
  "nvim-treesitter/nvim-treesitter",
  branch = "main",   -- antes era master
  build = ":TSUpdate",
  lazy = false,
  main = "nvim-treesitter",   -- antes era "nvim-treesitter.configs"
  opts = {},
  init = function()
    -- Habilitar highlighting e indentación por FileType
    vim.api.nvim_create_autocmd("FileType", {
      callback = function()
        pcall(vim.treesitter.start)
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })

    -- Instalar parsers (reemplaza ensure_installed)
    local ensure_installed = {
      "typescript", "javascript", "python", "lua",
      "bash", "json", "css", "html", "vue",
    }
    local already = require("nvim-treesitter.config").get_installed()
    local to_install = vim.iter(ensure_installed)
      :filter(function(p) return not vim.tbl_contains(already, p) end)
      :totable()
    require("nvim-treesitter").install(to_install)
  end,
},  -- Mason + LSP
  { "mason-org/mason.nvim", opts = {} },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
    opts = {
      ensure_installed = { "pylsp" },
    },
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")
      lspconfig.pylsp.setup({})
    end,
  },
})
