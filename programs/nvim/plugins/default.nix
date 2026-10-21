{ pkgs, ... }:

{
  imports = [
    ./lsp.nix
    ./lualine.nix
    ./treesitter.nix
    ./nvim-tree.nix
    ./undotree.nix
    ./telescope.nix
    ./jdtls-nvim.nix
    ./python.nix
  ];

  programs.neovim = {
    withRuby = true;
    withPython3 = true;
  };

  programs.neovim.plugins = with pkgs.vimPlugins; [
    delimitMate
    vim-css-color
    BufOnly-vim
    vim-vsnip

    {
      plugin = gitsigns-nvim;
      type = "lua";
      config =
        #lua
        ''
          require('gitsigns').setup({
            on_attach = function(bufnr)
              local gs = require('gitsigns')
              local opts = { buffer = bufnr }
              vim.keymap.set('n', ']h', function() gs.nav_hunk('next') end, opts)
              vim.keymap.set('n', '[h', function() gs.nav_hunk('prev') end, opts)
              vim.keymap.set('n', '<leader>hs', gs.stage_hunk, opts)
              vim.keymap.set('n', '<leader>hr', gs.reset_hunk, opts)
              vim.keymap.set('n', '<leader>hp', gs.preview_hunk, opts)
              vim.keymap.set('n', '<leader>hb', function() gs.blame_line({ full = true }) end, opts)
            end,
          })
        '';
    }
    {
      plugin = which-key-nvim;
      type = "lua";
      config =
        #lua
        ''
          require('which-key').setup({ delay = 500 })
        '';
    }
    {
      plugin = comment-nvim;
      type = "lua";
      config =
        #lua
        ''
          require('Comment').setup()
          vim.cmd("highlight Normal guibg=NONE ctermbg=NONE")
        '';
    }
  ];
}
