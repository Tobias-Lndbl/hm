{ ... }:
{
  imports = [
    ./alacritty.nix
    ./discord.nix
    ./element.nix 
    ./git.nix
    ./gnome-tweaks.nix
    ./google-chrome.nix
    ./libresprite.nix
    ./pandoc.nix
    ./spotify.nix
    ./unity.nix
    ./vscode.nix
    ./nvim
    ./waybar.nix
    ./wmctrl.nix
    ./xpdf.nix
  ];

  programs = {
    home-manager.enable = true;

    direnv.enable = true;
  };
}
