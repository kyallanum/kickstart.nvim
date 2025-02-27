return {
  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      default_file_explorer = true,
      columns = {
        'icon',
        'permissions',
      },
      buf_options = {
        buflisted = true,
        bufhidden = 'hide',
      },
      skip_confirm_for_simple_edits = true,
      cleanup_delay_ms = 2000,
      view_options = {
        show_hidden = false,
        case_insensitive = true,
        sort = {
          { 'type', 'asc' },
          { 'name', 'asc' },
        },
      },
      use_default_keymaps = false,
      keymaps = {
        ['g?'] = { 'actions.show_help', mode = 'n' },
        ['<CR>'] = 'actions.select',
        ['<C-t>'] = { 'actions.select', opts = { tab = true } },
        ['<C-c>'] = { 'actions.close', mode = 'n' },
        ['-'] = { 'actions.parent', mode = 'n' },
        ['_'] = { 'actions.open_cwd', mode = 'n' },
        ['`'] = { 'actions.cd', mode = 'n' },
        ['~'] = { 'actions.cd', opts = { scope = 'tab' }, mode = 'n' },
        ['gs'] = { 'actions.change_sort', mode = 'n' },
        ['gx'] = 'actions.open_external',
        ['g.'] = { 'actions.toggle_hidden', mode = 'n' },
        ['g\\'] = { 'actions.toggle_trash', mode = 'n' },
      },
    },
    dependencies = { { 'echasnovski/mini.icons', opts = {} } },
    lazy = false,
  },
}
