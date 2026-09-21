{pkgs, ...}:
{
  home.packages = with pkgs; [
    element-desktop
    element-web
  ];
}
