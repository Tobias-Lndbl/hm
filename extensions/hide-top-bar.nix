{pkgs, ...}:

{
  home.packages = with pkgs; [
    gnomeExtensions.hide-top-bar
  ];
}
