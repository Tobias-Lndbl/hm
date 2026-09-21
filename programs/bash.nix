{ lib, ... }:

{
  programs.bash = {
    enable = true;

    bashrcExtra = ''
      export EDITOR='vim'
    '';

    shellAliases = {
      ".." = "cd ..";
      "..." = ".. && ..";
      "...." = "... && ..";
      c = "clear";
      please = "sudo";
      sdn = "shutdown now";
      ivm = "vim";
      ff = "fastfetch";
      element = "element-desktop";

      # Config navigation
      cfg = "cd ~/.config/hm";
      cdhypr = "cd ~/.config/hm/nixos/hyprland";

      # Rebuilds. mkDefault so a host module can override them.
      switch = lib.mkDefault "home-manager switch --flake ~/.config/hm#tbsl@\$(hostname)";
      bswitch = lib.mkDefault "home-manager switch -b backup --flake ~/.config/hm#tbsl@\$(hostname)";
      nswitch = lib.mkDefault "sudo nixos-rebuild switch --flake ~/.config/hm#\$(hostname)";
      nixreb_boot = "nixos-rebuild boot";
      nixreb_switch = "nixos-rebuild switch";

      # Hyprland
      hrel = "hyprctl reload";
      tv_disable = "hyprctl keyword monitor 'DP-6,disable'";

      # Pyroeis VPN
      pu = "nmcli connection up pyroeis";
      pd = "nmcli connection down pyroeis";

      # Caelestia shell status page.
      # The zen-browser flake installs the binary as `zen-beta`, not `zen`.
      clstat = "zen-beta localhost:11987 &";
      ccl = "zen-beta localhost:11987 &";
    };
  };
}
