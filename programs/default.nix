{ ... }:
{
  imports = [
    ./libresprite.nix
    ./discord.nix
    ./git.nix
    ./gnome-tweaks.nix
    ./google-chrome.nix
    ./spotify.nix
    ./unity.nix
    ./vscode.nix
    #./whatsapp-for-linux.nix
    ./nvim
  ];

  programs = {
    home-manager.enable = true;

    direnv.enable = true;
  };
}
