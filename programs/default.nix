{ ... }:
{
  imports = [
    ./anki.nix
    ./bash.nix
    ./blueman.nix
    ./eww.nix
    ./git.nix
#    ./fcitx5.nix
    ./jetbrains.nix
    ./libresprite.nix
    ./nautilus.nix
    ./nvim
    ./fastfetch.nix
    ./feishin.nix
    ./nvim
    ./pamixer.nix
    ./pandoc.nix
    ./pavucontrol.nix
    ./qview.nix
    ./rustup.nix
#    ./screenshot.nix
    ./solaar.nix
    ./tor.nix
    ./trilium.nix
    ./thunderbird.nix
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
