{pkgs, ...}:

{
  home.packages = with pkgs; [
    wmctrl
  ];
}
