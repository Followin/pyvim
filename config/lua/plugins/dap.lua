local function exists(file)
  local ok, err, code = os.rename(file, file)
  if not ok then
    if code == 13 then
      -- Permission denied, but it exists
      return true
    end
  end
  return ok, err
end

return {
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      local dap = require("dap")

      dap.adapters.coreclr = {
        type = 'executable',
        command = '/etc/profiles/per-user/main/bin/netcoredbg',
        args = { '--interpreter=vscode' },
      }

      dap.configurations.cs = {
        {
          name = "Launch - netcoredbg",
          type = "coreclr",
          request = "launch",
          env = "ASPNETCORE_ENVIRONMENT=Development",
          args = {
            "/p:EnvironmentName=Development", -- this is a msbuild jk
            --  this is set via environment variable ASPNETCORE_ENVIRONMENT=Development
            "--urls=http://localhost:5002",
            "--environment=Development",
          },
          program = function()
            local dir = vim.loop.cwd() .. '/' .. vim.fn.glob 'bin/Debug/net*/linux-x64/'
            local name = dir .. vim.fn.glob('*.csproj'):gsub('%.csproj$', '.dll')
            if not exists(name) then os.execute 'dotnet build -r linux-x64' end
            return name
          end,
          -- cwd = '${workspaceFolder}',
          -- stopOnEntry = false,
          -- console = 'internalConsole',
          -- windows = {
          --   MIMode = 'legacy',
          -- },
        },
      }

      vim.keymap.set("n", "<F5>", dap.continue)
      vim.keymap.set("n", "<F10>", dap.step_over)
      vim.keymap.set("n", "<F11>", dap.step_into)
      vim.keymap.set("n", "<F12>", dap.step_out)
      vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint)
      vim.keymap.set("n", "<leader>dr", dap.repl.open)
      vim.keymap.set("n", "<leader>dl", dap.run_last)

      local dapui = require("dapui")
      dapui.setup()

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },
}
