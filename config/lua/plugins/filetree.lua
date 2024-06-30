return {
  {
    'stevearc/oil.nvim',
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local oil = require('oil')
      oil.setup({
        view_options = {
          show_hidden = true,
        },
      })

      vim.keymap.set("n", "<leader>e", oil.toggle_float, { noremap = true, silent = true })
    end,
  },
}
