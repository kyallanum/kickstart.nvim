local function get_python_path()
  -- Get the project root based off of a marker
  local function find_project_root()
    local markers = {
      '.git',
      'pyproject.toml',
      'setup.py',
      'requirements.txt',
    }

    local current_dir = vim.fn.expand '%:p:h'
    while current_dir ~= '/' do
      for _, marker in ipairs(markers) do
        if vim.fn.filereadable(current_dir .. '/' .. marker) == 1 or vim.fn.isdirectory(current_dir .. '/' .. marker) == 1 then
          return current_dir
        end
      end
      current_dir = vim.fn.fnamemodify(current_dir, ':h')
    end
    return nil
  end

  local project_root = find_project_root()
  if project_root then
    -- If this is a project venv (not a pyenv shim) then return that path
    local venv = project_root .. '/venv/bin/python'
    if vim.fn.executable(venv) == 1 then
      local real_path = vim.fn.resolve(venv)
      if not string.match(real_path, 'pyenv/shims') then
        print('Found project venv: ' .. real_path)
        return real_path
      end
    end

    -- If it is a pyenv shim return that
    local handle = io.popen('cd ' .. vim.fn.shellescape(project_root) .. ' && pyenv which python')
    if handle then
      local pyenv_path = handle:read '*a'
      handle:close()
      if pyenv_path and pyenv_path ~= '' then
        pyenv_path = string.gsub(pyenv_path, '[\n\r]', '')
        print('Using pyenv Python: ' .. pyenv_path)
        return pyenv_path
      end
    end
  end

  -- Else use the pyenv system version
  local handle = io.popen 'pyenv which python'
  if handle then
    local system_python = handle:read '*a'
    handle:close()
    if system_python and system_python ~= '' then
      system_python = string.gsub(system_python, '[\n\r]', '')
      vim.notify('Using pyenv system Python: ' .. system_python, vim.log.levels.WARN)
      return system_python
    end
  end

  -- Else use the basic system python version
  local basic_python = vim.fn.exepath 'python3' or vim.fn.exepath 'python'
  vim.notify('Using basic system Python: ' .. basic_python, vim.log.levels.WARN)
  return basic_python
end

return {
  {
    'mfussenegger/nvim-dap',
    event = 'VeryLazy',
    dependencies = {
      {
        'rcarriga/nvim-dap-ui',
        event = 'BufRead',
        dependencies = { 'nvim-neotest/nvim-nio' },
      },
      {
        'williamboman/mason.nvim',
        dependencies = { 'jay-babu/mason-nvim-dap.nvim' },
      },
      {
        'theHamsta/nvim-dap-virtual-text',
        event = 'BufRead',
        opts = {},
      },
    },

    config = function()
      local dap = require 'dap'
      local dapui = require 'dapui'
      local LazyVim = require 'lazyvim.config'

      -- Python configuration
      local python_path = get_python_path()
      local default_python_config = {
        type = 'python',
        request = 'launch',
        pythonPath = python_path,
        console = 'integratedTerminal',
        justMyCode = false,
        env = {
          PYTHONPATH = vim.fn.getcwd(),
          VIRTUAL_ENV = vim.fn.getcwd() .. '/venv',
          PATH = vim.fn.getcwd() .. '/venv/bin:' .. vim.env.PATH,
        },
      }

      -- Configuration management
      local function merge_config(user_config)
        if user_config.type ~= 'python' then
          return user_config
        end

        local config = vim.deepcopy(default_python_config)
        for k, v in pairs(user_config) do
          if k ~= 'pythonPath' and k ~= 'env' then
            config[k] = v
          end
        end

        if user_config.env then
          for k, v in pairs(user_config.env) do
            if k ~= 'PYTHONPATH' and k ~= 'VIRTUAL_ENV' and k ~= 'PATH' then
              config.env[k] = v
            end
          end
        end
        return config
      end

      -- Load configurations
      local function load_launch_json(bufnr)
        bufnr = bufnr or vim.api.nvim_get_current_buf()

        if vim.b[bufnr].dap_configs_loaded then
          return
        end

        print('Loading configuration for buffer', bufnr)
        dap.configurations.python = nil

        -- Clear existing python configurations

        local launch_json = vim.fn.getcwd() .. '/.vscode/launch.json'
        if vim.fn.filereadable(launch_json) == 1 then
          local content = vim.fn.readfile(launch_json)
          local decoded = vim.fn.json_decode(content)
          if decoded and decoded.configurations then
            dap.configurations.python = vim.tbl_map(merge_config, decoded.configurations)
          end
        else
          dap.configurations.python = {
            merge_config {
              type = 'python',
              name = 'Launch file',
              program = '${file}',
              cwd = '${workspaceFolder}',
            },
          }
        end

        -- Mark this buffer as loaded
        vim.b[bufnr].dap_configs_loaded = true
      end

      -- Make sure to load launch.json configurations at time of loading file.
      vim.api.nvim_create_autocmd({ 'BufWinEnter', 'BufNewFile' }, {
        pattern = 'python',
        callback = function(ev)
          if not vim.b[ev.buf].dap_configs_loaded then
            load_launch_json(ev.buf)
          end
        end,
      })

      -- Python adapter setup
      dap.adapters.python = {
        type = 'executable',
        command = python_path,
        args = { '-m', 'debugpy.adapter' },
      }

      -- Configuration overrides
      local original_run = dap.run
      dap.run = function(config, opts)
        local final_config = config.type == 'python' and merge_config(config) or config
        return original_run(final_config, opts)
      end

      -- Mason Setup
      require('mason-nvim-dap').setup {
        automatic_installation = false,
        handlers = {},
        ensure_installed = {},
      }

      vim.api.nvim_set_hl(0, 'DapStoppedLine', { default = true, link = 'Visual' })
      for name, sign in pairs(LazyVim.icons.dap) do
        sign = type(sign) == 'table' and sign or { sign }
        vim.fn.sign_define('Dap' .. name, {
          text = sign[1],
          texthl = sign[2] or 'DiagnosticInfo',
          linehl = sign[3],
          numhl = sign[3],
        })
      end

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
        icons = {
          expanded = '▾',
          collapsed = '▸',
          current_frame = '*',
        },
      }

      -- Event handlers
      dap.listeners.after.event_initialized['dapui_config'] = dapui.open
      dap.listeners.before.event_terminated['dapui_config'] = dapui.close
      dap.listeners.before.event_exited['dapui_config'] = dapui.close
      dap.listeners.before['terminate']['custom'] = function()
        vim.fn.system 'pkill -f debugpy'
      end
    end,

    -- Keybindings
    keys = function(_, keys)
      local dap = require 'dap'
      local dapui = require 'dapui'
      return {
        { '<F5>', dap.continue, desc = 'Debug: Start/Continue' },
        { '<F6>', dap.step_over, desc = 'Debug: Step Over' },
        { '<F7>', dap.step_into, desc = 'Debug: Step Into' },
        { '<F8>', dap.step_out, desc = 'Debug: Step Out' },
        { '<leader>b', dap.toggle_breakpoint, desc = 'Debug: Set Breakpoint' },
        {
          '<leader>B',
          function()
            dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
          end,
          desc = 'Debug: Set Breakpoint',
        },
        { '<leader>gb', dap.run_to_cursor, desc = 'Debug: Run to cursor' },
        { '<F9>', dapui.toggle, desc = 'Debug: Toggle Debug UI.' },
        {
          '<leader>[',
          function()
            dapui.eval(nil, { enter = true })
          end,
        },
        unpack(keys),
      }
    end,
  },
}
