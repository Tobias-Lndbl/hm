{ pkgs, ... }:

let
  # Separate interpreter just for the debug adapter; the debugged program
  # still runs with $VIRTUAL_ENV / .venv python (nvim-dap-python resolves it).
  debugpyPython = pkgs.python3.withPackages (ps: [ ps.debugpy ]);
in
{
  programs.neovim.extraPackages = with pkgs; [
    pyright
    ruff
  ];

  programs.neovim.plugins = with pkgs.vimPlugins; [
    nvim-nio
    nvim-dap
    {
      plugin = nvim-dap-ui;
      type = "lua";
      config =
        #lua
        ''
          local dap, dapui = require('dap'), require('dapui')
          dapui.setup()
          -- open/close the debugger UI automatically
          dap.listeners.before.attach.dapui_config = function() dapui.open() end
          dap.listeners.before.launch.dapui_config = function() dapui.open() end
          dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
          dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

          vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: start/continue' })
          vim.keymap.set('n', '<F10>', dap.step_over, { desc = 'Debug: step over' })
          vim.keymap.set('n', '<F11>', dap.step_into, { desc = 'Debug: step into' })
          vim.keymap.set('n', '<F12>', dap.step_out, { desc = 'Debug: step out' })
          vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: toggle breakpoint' })
          vim.keymap.set('n', '<leader>B', function()
            dap.set_breakpoint(vim.fn.input('Condition: '))
          end, { desc = 'Debug: conditional breakpoint' })
          vim.keymap.set('n', '<leader>dr', dap.repl.open, { desc = 'Debug: REPL' })
          vim.keymap.set('n', '<leader>dq', dap.terminate, { desc = 'Debug: stop' })
          vim.keymap.set('n', '<leader>du', dapui.toggle, { desc = 'Debug: toggle UI' })
          vim.keymap.set({ 'n', 'v' }, '<leader>de', dapui.eval, { desc = 'Debug: eval' })
        '';
    }
    {
      plugin = nvim-dap-virtual-text;
      type = "lua";
      config =
        #lua
        ''
          require('nvim-dap-virtual-text').setup()
        '';
    }
    {
      plugin = nvim-dap-python;
      type = "lua";
      config =
        #lua
        ''
          local dap_python = require('dap-python')
          dap_python.setup('${debugpyPython}/bin/python')
          dap_python.test_runner = 'pytest'
          vim.keymap.set('n', '<leader>dt', dap_python.test_method, { desc = 'Debug: test method' })
          vim.keymap.set('n', '<leader>dc', dap_python.test_class, { desc = 'Debug: test class' })
          vim.keymap.set('v', '<leader>ds', dap_python.debug_selection, { desc = 'Debug: selection' })
        '';
    }
  ];
}
