{ ... }:
{
  imports = [
    ./libresprite.nix
    ./discord.nix
    ./element.nix 
    ./git.nix
    ./gnome-tweaks.nix
    ./google-chrome.nix
    ./spotify.nix
    ./unity.nix
    ./vscode.nix
    ./nvim
  ];

  programs = {
    home-manager.enable = true;

    direnv.enable = true;
  };
}
