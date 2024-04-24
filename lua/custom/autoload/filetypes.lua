vim.api.nvim_create_autocmd({ 'BufEnter', 'BufNewFile' }, {
  pattern = '.whitesource',
  command = 'set filetype=json tabstop=2',
})

vim.api.nvim_create_autocmd({ 'BufWinEnter', 'BufNewFile' }, {
  callback = function(opts)
    if vim.bo[opts.buf].filetype == 'json' then
      vim.cmd 'set shiftwidth=2'
      vim.cmd 'set foldmethod=manual'
      vim.cmd 'silent! loadview'
    end
  end,
})

vim.api.nvim_create_autocmd({ 'BufWinLeave' }, {
  callback = function(opts)
    if vim.bo[opts.buf].filetype == 'json' then
      vim.cmd 'mkview'
    end
  end,
})
