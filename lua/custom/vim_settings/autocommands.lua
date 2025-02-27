local autocommands = {}

function autocommands.set()
  -- [[ Basic Autocommands ]]
  --  See `:help lua-guide-autocommands`

  -- Highlight when yanking (copying) text
  --  Try it with `yap` in normal mode

  vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
      vim.highlight.on_yank()
    end,
  })

  vim.api.nvim_create_autocmd({ 'BufWinEnter', 'BufNewFile' }, {
    callback = function(opts)
      if vim.bo[opts.buf].filetype == 'json' then
        vim.cmd 'set shiftwidth=2'
        vim.cmd 'set tabstop=2'
        vim.cmd 'set expandtab'
        vim.cmd 'silent! loadview'
      end
    end,
  })

  vim.api.nvim_create_autocmd({ 'BufWinEnter', 'BufNewFile' }, {
    pattern = '.whitesource',
    command = 'set filetype=json shiftwidth=2 tabstop=2 expandtab',
  })

  vim.api.nvim_create_autocmd('BufWinLeave', {
    callback = function(opts)
      if vim.bo[opts.buf].filetype == 'json' then
        vim.cmd 'mkview'
      end
    end,
  })

  vim.api.nvim_create_autocmd({ 'BufWinEnter', 'BufNewFile' }, {
    pattern = '*.py',
    command = 'set filetype=python shiftwidth=4 tabstop=4 expandtab',
  })

  -- Make sure to load launch.json configurations at time of loading file.
  vim.api.nvim_create_autocmd({ 'BufWinEnter', 'BufNewFile' }, {
    pattern = 'python',
    callback = function(ev)
      if not vim.b[ev.buf].dap_configs_loaded then
        load_launch_json(ev.buf)
      end
    end,
  })

  vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
    pattern = { '*.tf', '*.tfvars' },
    callback = function()
      vim.lsp.buf.format()
    end,
  })

  vim.api.nvim_create_autocmd({ 'BufWinEnter', 'BufNewFile' }, {
    pattern = { '*.tf', '*.tfvars' },
    command = 'set filetype=terraform shiftwidth=2 tabstop=2 expandtab',
  })
end

return autocommands
