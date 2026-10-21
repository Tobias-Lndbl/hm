{ lib, ... }:
let
    semester = "w26";
    course0 = "itsec";
    course1 = "ds";
    course2 = "ana";
    course3 = "gbs";
    course4 = "gdb";
    course5 = "med";
in
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
      py = "python3";
      pysh = "nix-shell ~/.config/hm/scripts/py.nix";

      # Config navigation
      cfg = "cd ~/.config/hm";
      cdhypr = "cd ~/.config/hm/nixos/hyprland";
      cu = "cd ~/Nextcloud/uni/${semester}";
      "cu${course0}" = "cd ~/Nextcloud/uni/${semester}/${course0}/";
      "cu${course1}" = "cd ~/Nextcloud/uni/${semester}/${course1}/";
      "cu${course2}" = "cd ~/Nextcloud/uni/${semester}/${course2}/";
      "cu${course3}" = "cd ~/Nextcloud/uni/${semester}/${course3}/";
      "cu${course4}" = "cd ~/Nextcloud/uni/${semester}/${course4}/";
      "cu${course5}" = "cd ~/Nextcloud/uni/${semester}/${course5}/";

      # Rebuilds. mkDefault so a host module can override them.
      switch = lib.mkDefault "home-manager switch --flake ~/.config/hm#tbsl@\$(hostname)";
      bswitch = lib.mkDefault "home-manager switch -b backup --flake ~/.config/hm#tbsl@\$(hostname)";
      nswitch = lib.mkDefault "sudo nixos-rebuild switch --flake ~/.config/hm#\$(hostname)";
      nixreb_boot = "nixos-rebuild boot";
      nixreb_switch = "nixos-rebuild switch";

      # Hyprland
      hrel = "hyprctl reload";

      # Pyroeis VPN
      pu = "nmcli connection up pyroeis";
      pd = "nmcli connection down pyroeis";

      # Caelestia shell status page.
      # The zen-browser flake installs the binary as `zen-beta`, not `zen`.
      clstat = "zen-beta localhost:11987 &";
      ccl = "zen-beta localhost:11987 &";

      #TUM
      lxhalle = "kitten ssh lxhalle";
    };
  };
}
