{
  pkgs ? (import ../nixpkgs.nix) { },
}:
{
  trilium-desktop-pkg = pkgs.callPackage ./trilium.nix { };
}
