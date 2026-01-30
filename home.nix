{
  outputs,
  inputs,
  config,
  pkgs,
  lib,
  ...

}:

{
  imports = [
    ./programs
    ./games
    ./nixos/hyprland
  ];

  home.username = "tbsl";
  home.homeDirectory = "/home/tbsl";

  home.stateVersion = "25.05";

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
    overlays = [
      outputs.overlays.additions
    ];
  };


  programs.kitty.enable = true;

  xdg.enable = true;

  #home.enableNixpkgsReleaseCheck = false;
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  home.packages = with pkgs; [
    xdg-utils
    swaybg
    sops
    python3
    python313Packages.dbus-python
    btop
  ];

  programs.bash = {
    enable = true;
    shellAliases = {
      ".." = "cd ..";
      "..." = ".. && ..";
      "...." = "... && ..";
      "cfg" = "cd ~/.config/hm";
      "cdhypr" = "cd ~/.config/hypr";
      "cdhyprhm" = "cd ~/.config/hm/nixos/hyprland";
      "ivm" = "vim";
      c = "clear";
      switch = lib.mkDefault "home-manager switch --flake ~/.config/hm";
      nswitch = lib.mkDefault "sudo nixos-rebuild switch --flake ~/.config/hm";
      wa = "firefox https://web.whatsapp.com &";
      "sdn" = "shutdown now";
      clstat = "firefox localhost:11987 &";
      ccl = "firefox localhost:11987 &";
      please = "sudo";
      nixreb_boot = "nixos-rebuild boot";
      nixreb_switch = "nixos-rebuild switch";
      element = "element-desktop";
      google = "google-chrome-stable";
      chrome = "google-chrome-stable";
      trilium-web = "google-chrome-stable 10.0.10.10 --new-window";
      ff = "fastfetch";
      "hrel" = "hyprctl reload";
      "tv_disable" = "hyprctl keyword monitor 'DP-6,disable'";
    };
  };
  
  programs.direnv.enable = true;

  i18n.inputMethod.fcitx5.settings.inputMethod = {
    GroupOrder."0" = "Default";
    "Groups/0" = {
      Name = "Default";
      "Default Layout" = "jp";
      DefaultIM = "mozc";
    };
    "Groups/0/Items/0".Name = "keyboard-jp";
    "Groups/0/Items/1".Name = "mozc";
  }; 

  home.file = {};
}
