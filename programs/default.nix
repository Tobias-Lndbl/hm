{ ... }:
{
  imports = [
    ./discord.nix
    ./git.nix
    ./google-chrome.nix
    ./spotify.nix
    ./vscode.nix
    ./whatsapp-for-linux.nix
    #./nvim
  ];

  programs = {
    home-manager.enable = true;

    direnv.enable = true;
  };
}
