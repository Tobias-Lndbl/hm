{ ... }:
{
  imports = [
    ./alacritty.nix
    ./discord.nix
    ./element.nix 
    ./eww.nix
    ./git.nix
    ./gnome-tweaks.nix
    ./libresprite.nix
    ./pamixer.nix
    ./pandoc.nix
    ./pavucontrol.nix
    ./rustup.nix
    ./spotify.nix
    ./trilium.nix
    ./unity.nix
    ./vscode.nix
    ./nvim
    ./wmctrl.nix
    ./xpdf.nix
    ./zip.nix
  ];

  programs = {
    home-manager.enable = true;

    direnv.enable = true;
  };
}
