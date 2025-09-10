{pkgs, ...}:

{
  home.packages = with pkgs; [
    trilium-next-desktop
  ];
}
