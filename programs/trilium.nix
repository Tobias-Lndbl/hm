{pkgs, ...}:

{
  home.packages = with pkgs; [
    (trilium-desktop-pkg override { electron = pkgs.electron_38; })
  ];
}
