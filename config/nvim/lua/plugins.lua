-- NOTE: Here is where you install your plugins.
require('lazy').setup({
  -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
    config = function()
      local path = vim.fn.getcwd()
      if string.sub(path, 1, #'/Users/bartek/Projects/inmusic/mount_windows/') == '/Users/bartek/Projects/inmusic/mount_windows/' then
        return
      end
      require('gitsigns').setup()
    end,
  },
  {
    'MunsMan/kitty-navigator.nvim',
    build = {
      'cp navigate_kitty.py ~/.config/kitty',
      'cp pass_keys.py ~/.config/kitty',
    },
    opts = {
      keybindings = {
        {
          '<C-j>',
          function()
            require('kitty-navigator').navigateLeft()
          end,
          desc = 'Move left a Split',
          mode = { 'n' },
        },
        {
          '<C-k>',
          function()
            require('kitty-navigator').navigateDown()
          end,
          desc = 'Move down a Split',
          mode = { 'n' },
        },
        {
          '<C-l>',
          function()
            require('kitty-navigator').navigateUp()
          end,
          desc = 'Move up a Split',
          mode = { 'n' },
        },
        {
          '<C-;>',
          function()
            require('kitty-navigator').navigateRight()
          end,
          desc = 'Move right a Split',
          mode = { 'n' },
        },
      },
    },
  },

  {
    'tomasky/bookmarks.nvim',
    event = 'VimEnter',
    opts = {},
    config = function()
      require('bookmarks').setup {}
    end,
  },

  require 'kickstart/plugins/neogit',
  require 'kickstart.plugins.telescope',
  -- LSP Plugins
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
      },
    },
  },
  { 'Bilal2453/luvit-meta', lazy = true },
  {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup {}
    end,
  },
  {
    'rcarriga/nvim-notify',
    config = function()
      require('notify').setup()
    end,
  },
  require 'kickstart/plugins/overseer',
  {
    'eriks47/generate.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('generate').setup()
    end,
  },

  require 'kickstart/plugins/which-key',
  require 'kickstart/plugins/lsp-config',
  { -- Autoformat
    'stevearc/conform.nvim',
    config = function()
      require('conform').formatters.cmakeformat = {
        inherit = false,
        command = 'cmake-format',
        args = { '', '$FILENAME' },
      }
      require('conform').formatters.qmlformat = {
        inherit = false,
        command = 'qmlformat',
        args = { '', '$FILENAME' },
      }
      require('conform').setup {
        log_level = vim.log.levels.DEBUG,
        formatters_by_ft = {
          lua = { 'stylua' },
          json = { 'fixjson' },
          cmake = { 'cmakeformat' },
          qml = { 'qmlformat' },
        },
      }
    end,
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>lf',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = true,
      format_on_save = { timeout_ms = 500 },
    },
  },
  {
    'rachartier/tiny-inline-diagnostic.nvim',
    event = 'VeryLazy', -- Or `LspAttach`
    priority = 1000, -- needs to be loaded in first
    config = function()
      require('tiny-inline-diagnostic').setup {
        preset = 'classic',
      }
    end,
  },
  require 'kickstart/plugins/cmake',
  require 'kickstart/plugins/dap',
  require 'kickstart/plugins/cmp',
  {
    'p00f/clangd_extensions.nvim',
    ft = { 'c', 'cpp' },
    opts = { extensions = { autoSetHints = false } },
  },
  {
    'rmagatti/auto-session',
    lazy = false,

    opts = {
      suppressed_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
      -- log_level = 'debug',
    },
  },
  {
    'f-person/auto-dark-mode.nvim',
    config = function()
      local auto_dark_mode = require 'auto-dark-mode'

      auto_dark_mode.setup {
        update_interval = 1000,
        set_dark_mode = function()
          vim.cmd.colorscheme 'tokyonight-night'
        end,
        set_light_mode = function()
          vim.cmd.colorscheme 'tokyonight-day'
        end,
      }
      auto_dark_mode.init()
    end,
  },
  {
    'numToStr/Comment.nvim',
    opts = {
      -- add any options here
    },
  },

  { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is.
    --
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
    'folke/tokyonight.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    init = function()
      vim.cmd.colorscheme 'tokyonight-night'

      -- You can configure highlights by doing something like:
      vim.cmd.hi 'Comment gui=none'
    end,
  },
  {
    'navarasu/onedark.nvim',
    config = function()
      require('onedark').setup {
        style = 'darker',
        transparent = true,
        lualine = {
          transparent = true,
        },
      }
    end,
    -- init = function()
    --   vim.cmd.colorscheme 'onedark'
    -- end,
  },

  -- Highlight todo, notes, etc in comments
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      require('mini.ai').setup { n_lines = 500 }
      require('mini.surround').setup()

      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = vim.g.have_nerd_font }

      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs', -- Sets main module to use for opts
    opts = {
      ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' },
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
  },
  {
    'mrjones2014/smart-splits.nvim',
  },
  require 'kickstart/plugins/ai',
  require 'kickstart/plugins/plantuml',
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})
