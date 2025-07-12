{pkgs, ...}:

{
  home.packages = with pkgs; [
    texlive 
  ];
}
