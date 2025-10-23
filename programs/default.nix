{ ... }:
{
  imports = [
    ./bash.nix
    ./blueman.nix
    ./eww.nix
    ./git.nix
    ./jetbrains.nix
    ./libresprite.nix
    ./nautilus.nix
    ./neofetch.nix
    ./nvim
    ./pamixer.nix
    ./pandoc.nix
    ./pavucontrol.nix
    ./qview.nix
    ./rustup.nix
    ./screenshot.nix
    ./solaar.nix
    ./trilium.nix
    ./TUM
    ./unity.nix
    ./vscode.nix
    ./wmctrl.nix
    ./xournalpp.nix
    ./zip.nix
  ];

  programs = {
    home-manager.enable = true;

    direnv.enable = true;
  };
}
