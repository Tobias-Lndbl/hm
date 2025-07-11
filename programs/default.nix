{ ... }:
{
  imports = [
    ./libresprite.nix
    ./discord.nix
    ./chromium.nix
    ./element.nix 
    ./git.nix
    ./gnome-tweaks.nix
#    ./google-chrome.nix
    ./spotify.nix
    ./unity.nix
    ./vscode.nix
    ./nvim
    ./xpdf.nix
  ];

  programs = {
    home-manager.enable = true;

    direnv.enable = true;
  };
}
