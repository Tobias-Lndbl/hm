{pkgs, ...}:

{
  home.packages = with pkgs; [
    gnomeExtensions.tiling-shell
  ];
}
