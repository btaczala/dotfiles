-- NOTE: Here is where you install your plugins.
require('lazy').setup(
  {
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
      'tomasky/bookmarks.nvim',
      event = 'VimEnter',
      opts = {},
      config = function()
        require('bookmarks').setup {}
      end,
    },
    'tpope/vim-fugitive',
    --
    -- require 'kickstart/plugins/neogit',
    require 'kickstart.plugins.telescope',
    require 'kickstart.plugins.git',
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
    --
    require 'kickstart/plugins/which-key',
    require 'kickstart/plugins/obsidian',
    require 'kickstart/plugins/lsp-config',
    { -- Autoformat
      'stevearc/conform.nvim',
      config = function()
        require('conform').formatters.cmakeformat = {
          inherit = false,
          command = 'cmake-format',
          args = { '$FILENAME', '--line-width', '100' },
        }
        require('conform').formatters.qmlformat = {
          inherit = false,
          command = 'qmlformat',
          args = { '$FILENAME' },
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
            vim.api.nvim_command 'write'
            require('conform').format { async = false, lsp_format = 'fallback' }
          end,
          mode = '',
          desc = '[F]ormat buffer',
        },
      },
      opts = {
        notify_on_error = true,
      },
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
        suppressed_dirs = { '~/', '~/Projects', '~/Downloads', '/', '/Users/bartek/Projects/inmusic/mount_windows/mediamaster' },
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
    {
      'rebelot/kanagawa.nvim',
      config = function()
        require('kanagawa').setup {
          compile = false, -- enable compiling the colorscheme
          undercurl = true, -- enable undercurls
          commentStyle = { italic = true },
          functionStyle = {},
          keywordStyle = { italic = true },
          statementStyle = { bold = true },
          typeStyle = {},
          transparent = false, -- do not set background color
          dimInactive = false, -- dim inactive window `:h hl-NormalNC`
          terminalColors = true, -- define vim.g.terminal_color_{0,17}
          colors = { -- add/modify theme and palette colors
            palette = {},
            theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
          },
          overrides = function(_) -- add/modify highlights
            return {}
          end,
          theme = 'wave', -- Load "wave" theme
          background = { -- map the value of 'background' option to a theme
            dark = 'wave', -- try "dragon" !
            light = 'lotus',
          },
        }
      end,
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
      opts = {
        transparent = false,
      },
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
    require 'kickstart/plugins/snippets',
    require 'kickstart/plugins/plantuml',
    {
      'folke/trouble.nvim',
      opts = {}, -- for default options, refer to the configuration section for custom setup.
      cmd = 'Trouble',
      keys = {
        {
          '<leader>qq',
          '<cmd>Trouble diagnostics toggle<cr>',
          desc = 'Quickfix List (Trouble)',
        },
      },
    },
    {
      'mrcjkb/rustaceanvim',
      version = '^5', -- Recommended
      lazy = false, -- This plugin is already lazy
    },
    { 'RaafatTurki/hex.nvim' },
    require 'kickstart/plugins/openscad',
    {
      'fei6409/log-highlight.nvim',
      config = function()
        require('log-highlight').setup {}
      end,
    },
    {
      'javiorfo/nvim-soil',

      -- Optional for puml syntax highlighting:
      dependencies = { 'javiorfo/nvim-nyctophilia' },

      lazy = true,
      ft = 'plantuml',
      opts = {
        -- If you want to change default configurations

        -- This option closes the image viewer and reopen the image generated
        -- When true this offers some kind of online updating (like plantuml web server)
        actions = {
          redraw = false,
        },

        -- If you want to use Plant UML jar version instead of the installed version
        puml_jar = '/opt/homebrew/Cellar/plantuml/1.2025.2/libexec/plantuml.jar',

        -- If you want to customize the image showed when running this plugin
        image = {
          darkmode = false, -- Enable or disable darkmode
          format = 'png', -- Choose between png or svg

          -- This is a default implementation of using nsxiv to open the resultant image
          -- Edit the string to use your preferred app to open the image (as if it were a command line)
          -- Some examples:
          -- return "feh " .. img
          -- return "xdg-open " .. img
          execute_to_open = function(img)
            return 'open ' .. img
          end,
        },
      },
    },
  },
  ---@diagnostic disable-next-line: missing-fields
  {
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
  }
)
