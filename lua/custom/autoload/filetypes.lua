vim.api.nvim_create_autocmd({ 'BufEnter', 'BufNewFile' }, {
  pattern = '.whitesource',
  command = 'set filetype=json tabstop=2',
})
