{pkgs, ...}:

{
  home.packages = with pkgs; [
    gnomeExtensions.no-title-bar
  ];
}
