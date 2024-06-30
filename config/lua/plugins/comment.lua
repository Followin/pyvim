return {
  {
    'numToStr/Comment.nvim',
    opts = {
      toggler = {
        line = '<leader>/',
      },
      opleader = {
        line = '<leader>/',
      },
    },
    lazy = false,
    enabled = vim.g.nixConfig.plugins.comment.enabled,
  },
}
