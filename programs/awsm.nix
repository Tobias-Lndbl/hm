{pkgs, ...}:

{
  home.packages = with pkgs; [
    gnomeExtensions.another-window-session-manager
  ];
}
