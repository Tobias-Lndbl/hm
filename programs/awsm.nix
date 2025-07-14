{pkgs, ...}:

{
  home.packages = with pkgs; [
    gnome-shell-extension-another-window-session-manager
  ];
}
