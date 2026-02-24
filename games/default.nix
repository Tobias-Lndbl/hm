{ pkgs, ... }:
{
  imports = [
    ./prismlauncher.nix
    ./wine.nix
    ./lutris.nix
  ];
}
