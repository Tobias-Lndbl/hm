{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ocaml
    ocamlPackages.utop
    dune
  ];
}
