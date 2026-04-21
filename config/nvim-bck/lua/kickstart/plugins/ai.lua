return {
  'olimorris/codecompanion.nvim',
  version = 'v17.33.0',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    -- The following are optional:
    { 'MeanderingProgrammer/render-markdown.nvim', ft = { 'markdown', 'codecompanion' } },
  },
  config = function()
    local function get_secret(cmd)
      local handle = io.popen(cmd)
      if not handle then
        return nil
      end
      local result = handle:read '*a'
      handle:close()
      return result and result:gsub('%s+$', '')
    end

    local codemistral_api_key = get_secret 'pass show private/codestral.mistral.ai/api_key'
    require('codecompanion').setup {
      strategies = {
        chat = {
          adapter = 'openai',
        },
        inline = {
          adapter = 'openai',
        },
      },
      opts = {
        stream = true,
      },
      adapters = {
        http = {
          openai = function()
            return require('codecompanion.adapters').extend('openai_compatible', {
              name = 'codestral',
              env = {
                url = 'https://codestral.mistral.ai',
                api_key = codemistral_api_key,
                chat_url = '/v1/chat/completions',
              },
              handlers = {
                form_parameters = function(_, params, _)
                  -- codestral doesn't support these in the body
                  params.stream_options = nil
                  params.options = nil

                  return params
                end,
              },
              schema = {
                model = {
                  default = 'codestral-latest',
                },
                temperature = {
                  default = 0.2,
                  mapping = 'parameters', -- not supported in default parameters.options
                },
              },
            })
          end,
        },
      },
    }
  end,
}
