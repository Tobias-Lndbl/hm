{ ... }:
{
  imports = [
    ./bash.nix
    ./blueman.nix
    ./discord.nix
    ./element.nix 
    ./eww.nix
    ./git.nix
    ./jetbrains.nix
    ./libresprite.nix
    ./nautilus.nix
    ./pamixer.nix
    ./pandoc.nix
    ./pavucontrol.nix
    ./qview.nix
    ./rustup.nix
    ./screenshot.nix
    ./spotify.nix
    ./trilium.nix
    ./TUM
    ./unity.nix
    ./vscode.nix
    ./nvim
    ./wmctrl.nix
    ./xournalpp.nix
    ./zip.nix
  ];

  programs = {
    home-manager.enable = true;

    direnv.enable = true;
  };
}
