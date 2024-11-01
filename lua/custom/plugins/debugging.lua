return {
  {
    'mfussenegger/nvim-dap',
    events = 'VeryLazy',
    dependencies = {
      {
        'rcarriga/nvim-dap-ui',
        events = 'BufRead',
        dependencies = {
          'nvim-neotest/nvim-nio',
        },
      },
      {
        'williamboman/mason.nvim',
        dependencies = {
          {
            'mfussenegger/nvim-dap-python',
            events = 'BufRead',
          },
        },
      },
      {
        'theHamsta/nvim-dap-virtual-text',
        events = 'BufRead',
        opts = {},
      },
      {
        'jay-babu/mason-nvim-dap.nvim',
      },
    },

    config = function()
      local dap = require 'dap'
      local dapui = require 'dapui'
      local LazyVim = require 'lazyvim.config'

      require('mason-nvim-dap').setup {
        automatic_setup = true,
        handlers = {},
        ensure_installed = {
          'debugpy',
        },
        automatic_installation = true,
        config = function()
          require('dap-python').setup(require('venv-selector').venv() .. '/debugpy')
        end,
      }

      vim.api.nvim_set_hl(0, 'DapStoppedLine', { default = true, link = 'Visual' })

      for name, sign in pairs(LazyVim.icons.dap) do
        sign = type(sign) == 'table' and sign or { sign }
        vim.fn.sign_define('Dap' .. name, { text = sign[1], texthl = sign[2] or 'DiagnosticInfo', linehl = sign[3], numhl = sign[3] })
      end

      -- Set up listeneers for specific events to open and close dapui
      dap.listeners.after.event_initialized['dapui_config'] = dapui.open
      dap.listeners.before.event_terminated['dapui_config'] = dapui.close
      dap.listeners.before.event_exited['dapui_config'] = dapui.close

      -- Set up Dap UI config
      dapui.setup {
        controls = {
          icons = {
            disconnect = '',
            pause = '',
            play = '',
            run_last = '',
            step_back = '',
            step_into = '',
            step_out = '',
            step_over = '',
            terminate = '',
          },
        },
        icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      }
    end,

    keys = function(_, keys)
      local dap = require 'dap'
      local dapui = require 'dapui'
      return {
        { '<F5>', dap.continue, desc = 'Debug: Start/Continue' },
        { '<F6>', dap.step_over, desc = 'Debug: Step Over' },
        { '<F7>', dap.step_into, desc = 'Debug: Step Into' },
        { '<F8>', dap.step_out, desc = 'Debug: Step Out' },
        { '<leader>b', dap.toggle_breakpoint, desc = 'Debug: Toggle Breakpoint' },
        {
          '<leader>B',
          function()
            dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
          end,
          desc = 'Debug: Set Breakpoint',
        },
        { '<leader>gb', dap.run_to_cursor, desc = 'Debug: Run to cursor' },
        { '<F9>', dapui.toggle, desc = 'Debug: Toggle debug UI.' },
        { '<leader>[', dapui.eval(nil, { enter = true }) },
        unpack(keys),
      }
    end,
  },
}
