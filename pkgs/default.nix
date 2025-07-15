{pkgs ? (import ../nixpkgs.nix) {} }: {
  #example = pkgs.callPackage ./hyprctl-rotate.nix

  hyprctl-rotate = pkgs.callPackage ./hyprctl-rotate.nix {};
  hm = pkgs.home-manager;
}
