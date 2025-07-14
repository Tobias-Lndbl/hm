{pkgs, ...}:

{
  home.packages = with pkgs;[
    gnomeExtensions.zen
  ];
}
