{ lib, ... }:
let
    semester = "w26";
    courses = [ "itsec" "ds" "ana" "gbs" "gdb" "med" ];
    uniDir = "~/Nextcloud/uni/${semester}";
in
{

  programs.bash = {

    enable = true;

    historySize = 10000;
    historyFileSize = 100000;
    historyControl = [ "ignoredups" "erasedups" ];
    shellOptions = [ "histappend" "checkwinsize" "globstar" ];

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
      cu = "cd ${uniDir}";

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
    }
    # cu<course> = cd into that course's folder
    // lib.listToAttrs (map (c: lib.nameValuePair "cu${c}" "cd ${uniDir}/${c}/") courses);
  };

  # Ctrl-R fuzzy history, Ctrl-T file picker, Alt-C cd
  programs.fzf.enable = true;

  # `z gbs` jumps to the most used matching dir
  programs.zoxide.enable = true;
}
