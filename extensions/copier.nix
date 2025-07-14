{pkgs, ...}:

{
  home.packages = with pkgs; [
    gnomeExtensions.copier
  ];
}
