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

  -- Tema Catppuccin
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "mocha",
      transparent_background = false,
      italic_comments = true,
      integrations = {
        treesitter = true,
        mason = true,
        nerdtree = true,
      },
    },
  },

  -- NERDTree
  {
    "preservim/nerdtree",
    dependencies = {
      "ryanoasis/vim-devicons",
      "preservim/nerdcommenter",
    },
    config = function()
      vim.g.NERDTreeShowHidden = 1
      vim.g.NERDTreeMinimalUI = 1
      vim.g.NERDTreeWinSize = 30
      vim.g.NERDTreeQuitOnOpen = 0
      vim.g.webdevicons_enable = 1
      vim.g.webdevicons_enable_nerdtree = 1
      vim.g.WebDevIconsUnicodeDecorateFolderNodes = 1

      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          vim.cmd("NERDTree")
          vim.cmd("wincmd p")
        end,
      })

      -- Cerrar nvim si solo queda NERDTree
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
    end,
  },

  -- Startify (pantalla de inicio)
  {
    "mhinz/vim-startify",
    config = function()
      vim.g.startify_change_to_vcs_root = 1
      vim.g.startify_lists = {
        { type = "files",     header = { "   Recientes" } },
        { type = "dir",       header = { "   Directorio actual" } },
        { type = "sessions",  header = { "   Sesiones" } },
        { type = "bookmarks", header = { "   Favoritos" } },
      }
    end,
  },

  -- Snippets
  {
    "SirVer/ultisnips",
    dependencies = { "honza/vim-snippets" },
    config = function()
      vim.g.UltiSnipsExpandTrigger = "<tab>"
      vim.g.UltiSnipsJumpForwardTrigger = "<tab>"
      vim.g.UltiSnipsJumpBackwardTrigger = "<s-tab>"
    end,
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    lazy = false,
    main = "nvim-treesitter",
    opts = {},
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          pcall(vim.treesitter.start)
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
      local ensure_installed = {
        "typescript", "javascript", "python", "lua",
        "bash", "json", "css", "html", "vue",
      }
      local already = require("nvim-treesitter.config").get_installed()
      local to_install = vim.iter(ensure_installed)
        :filter(function(p) return not vim.tbl_contains(already, p) end)
        :totable()
      if #to_install > 0 then
        require("nvim-treesitter").install(to_install)
      end
    end,
  },

  -- Mason + LSP
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
      -- API nueva de nvim 0.11
      vim.lsp.config('pylsp', {})
      vim.lsp.enable('pylsp')
    end,
  },
})
