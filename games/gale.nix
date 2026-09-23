{pkgs, ... }:

{
  home.packages = with pkgs; [
    gale
    r2modman
  ];
}
