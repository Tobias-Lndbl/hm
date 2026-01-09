{pkgs, ...}:
{
  home.packages = with pkgs; [
    #tor
    tor-browser
  ];
}
