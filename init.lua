-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim with plugins
require("lazy").setup({
  spec = {
    -- Your other plugins here if any

    -- Flash used for code navigation
    {
      "folke/flash.nvim",
      event = "VeryLazy",
      ---@type Flash.Config
      opts = {},
      -- stylua: ignore
      keys = {
        { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
        { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
        { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
        { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
        { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
      },
    },
		
    -- Buffer auto completion
    { 
      "hrsh7th/nvim-cmp",
      dependencies = {
	"hrsh7th/cmp-buffer",       -- buffer completions
        "hrsh7th/cmp-nvim-lsp",     -- LSP completions
        "neovim/nvim-lspconfig",    -- LSP client
	  },
      config = function()
        local cmp = require("cmp")
        local lspconfig = require("lspconfig")
        local cmp_nvim_lsp = require("cmp_nvim_lsp")
				
        cmp.setup({
	  -- key mappings:
          mapping = {
            ["<C-Space>"] = cmp.mapping.complete(),                 -- trigger completion menu
            ["<CR>"]      = cmp.mapping.confirm({ select = true }), -- confirm selection
            ["<Tab>"]     = cmp.mapping.select_next_item(),         -- next item
            ["<S-Tab>"]   = cmp.mapping.select_prev_item(),         -- previous item
          },
          sources = {
	    { name = "nvim_lsp" },  -- LSP first
            { name = "buffer" },    -- then buffer
          },
        })

      -- 2) Enable Python LSP (pyright) with cmp capabilities
      lspconfig.pyright.setup({
        capabilities = cmp_nvim_lsp.default_capabilities(),
      })

      end,
    },
	
    -- Horizon color
    { "akinsho/horizon.nvim", version = "*" },

    -- Add Telescope plugin
    {
      "nvim-telescope/telescope.nvim",
      tag = "0.1.5", -- pinned version
      dependencies = { 
        "nvim-lua/plenary.nvim",
        "BurntSushi/ripgrep"
      },
      config = function()
        require("telescope").setup()
      end,
    },

    -- Treesitter plugin added here
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      config = function()
        require("nvim-treesitter.configs").setup({
          ensure_installed = { "lua", "c", "zig", "cpp", "python", "javascript", "typescript", "bash", "json", "yaml", "toml", "markdown", "gitignore", "go", "vim" },
          highlight = { enable = true, additional_vim_regex_highlighting = false },
          indent = { enable = true },
        })
      end,
    },

  },
  -- global lazy.nvim settings
  install = { colorscheme = { "habamax" } },
  checker = { enabled = true },
})

-- Keymaps for Telescope (can be after setup)
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>")
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>")
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>")
vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>")

-- Color
vim.cmd.colorscheme('horizon')
vim.o.background = "dark"

-- Lines
vim.opt.nu = true
vim.opt.relativenumber = true

-- Tabs to 4 spaces
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4



