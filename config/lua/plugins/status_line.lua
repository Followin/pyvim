return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = {
      'linrongbin16/lsp-progress.nvim',
    },
    config = function()
      require("lualine").setup({
        options = {
          component_separators = "|",
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = {
            "branch",
            "diff",
            {
              "diagnostics",
              colored = true,
              update_in_insert = true,
            },
            "filename",
          },
          lualine_c = {
            -- invoke `progress` here.
            [[
              require("lsp-progress").progress({
                format = function(messages)
                    local active_clients = vim.lsp.get_active_clients()
                    local client_count = #active_clients
                    if #active_clients <= 0 then
                        return ""
                    else
                        local client_names = {}
                        for i, client in ipairs(active_clients) do
                            if client and client.name ~= "" then
                                table.insert(client_names, client.name)
                            end
                        end
                        return " "
                            .. table.concat(client_names, " ")
                    end
                end,
              })
            ]],
          },
        },
      })

      -- listen lsp-progress event and refresh lualine
      vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
      vim.api.nvim_create_autocmd("User", {
        group = "lualine_augroup",
        pattern = "LspProgressStatusUpdated",
        callback = require("lualine").refresh,
      })
    end,
  },
  {
    'linrongbin16/lsp-progress.nvim',
    config = function()
      require('lsp-progress').setup()
    end,
  },
}
