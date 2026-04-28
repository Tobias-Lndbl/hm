{ ... }:
{
  imports = [
    ./anki.nix
    ./bash.nix
    ./blueman.nix
    ./discord.nix
    ./easyeffects.nix
    ./element.nix
    ./eww.nix
    ./fastfetch.nix
    ./feishin.nix
    ./git.nix
    ./jetbrains.nix
    ./libresprite.nix
    ./nautilus.nix
    ./gnucash.nix
    ./gnumake.nix
    ./nextcloud-client.nix
    ./nvim
    ./pamixer.nix
    ./pandoc.nix
    ./pavucontrol.nix
    ./qview.nix
    ./rustup.nix
    ./solaar.nix
    ./tor.nix
#    ./trilium.nix
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
