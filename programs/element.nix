{pkgs, ...}: 

{
  home.packages = with pkgs; [
    element-web 
    ];
}
