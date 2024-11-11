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

  vim.api.nvim_create_autocmd('VimEnter', {
    desc = 'Auto select virtualenv on open',
    pattern = '*',
    callback = function()
      local venv = vim.fn.findfile('pyproject.toml', vim.fn.getcwd() .. ';')
      if venv ~= '' then
        require('venv-selector').setup {
          pyenv_path = '/home/klanum/.pyenv/versions',
        }
      end
    end,
    once = true,
  })
end

return autocommands
