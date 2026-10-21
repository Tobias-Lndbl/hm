{ pkgs, ... }:

{

  programs.neovim.plugins = [
    (pkgs.vimPlugins.nvim-treesitter.withPlugins (
      p: with p; [
        bash
        c
        cpp
        c_sharp
        css
        html
        java
        javascript
        json
        lua
        make
        markdown
        markdown_inline
        latex
        sql
        ocaml
        gitcommit
        diff
        r
        rust
        scss
        toml
        vimdoc
        yaml
        nix
        python
      ]
    ))
  ];
}
