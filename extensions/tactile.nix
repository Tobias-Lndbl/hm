{pkgs, ...}:

{
  home.packages = with pkgs; [
    gnomeExtensions.tactile
  ];
}
