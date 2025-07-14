{pkgs, ...}:

{
  home.packages = with pkgs; [
    gnomeExtensions.restart-to
  ];
}
