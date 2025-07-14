{ ... }:
{
  imports = [
    ./libresprite.nix
    ./discord.nix
    ./element.nix 
    ./git.nix
    ./gnome-tweaks.nix
    ./google-chrome.nix
    ./pandoc.nix
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
