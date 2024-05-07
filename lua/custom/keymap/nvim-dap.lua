local mappings = {}

mappings.dap = {
  plugin = true,
  n = {
    ['<leader>db'] = { '<cmd> DapToggleBreakpoint <CR>' },
  },
}

mappings.dap_python = {
  plugin = true,
  n = {
    ['<leader>dpr'] = {
      function()
        require('dap-python').test_method()
      end,
    },
  },
}

return mappings
