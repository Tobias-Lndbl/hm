{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
  packages = [
    (pkgs.python3.withPackages (ps: with ps; [
      requests
      beautifulsoup4
      pwntools
      pycryptodome
      cryptography
      numpy
      ipython
      flask
    ]))
  ];
}
