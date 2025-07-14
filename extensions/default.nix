{ ... }:

{
  imports = [
  ./copier.nix
  ./gemini-ai.nix
  ./hide-top-bar.nix
  ./tactile.nix
  ./tiling-shell.nix
  ./zen.nix
  ];

  programs = {
    home-manager.enable = true;

    direnv.enable = true;
  };
}
