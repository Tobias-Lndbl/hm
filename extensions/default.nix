{ ... }:

{
  imports = [
  ./copier.nix
  ./default.nix
  ./espresso.nix
  ./hide-top-bar.nix
  ./no-title-bar.nix
  ./restart-to.nix
  ./tactile.nix
  ./zen.nix
  ];

  programs = {
    home-manager.enable = true;

    direnv.enable = true;
  };
}
