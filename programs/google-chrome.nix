{pkgs, config, lib, ...}:

{
  home.packages = with pkgs; [
    google-chrome
  ];
}
