{
  outputs,
  pkgs,
  ...
}:

{
  imports = [
    ./programs
    ./games
    ./nixos/hyprland
    ./desktop
  ];

  home.username = "tbsl";
  home.homeDirectory = "/home/tbsl";

  home.stateVersion = "25.05";

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
      permittedInsecurePackages = [
        "electron-37.10.3"
      ];
    };
    overlays = [
      outputs.overlays.additions

      (final: prev: {
      anki = prev.anki.overrideAttrs (oldAttrs: {
        # Add the missing Qt6 WebChannel library
        buildInputs = (oldAttrs.buildInputs or [ ]) ++ [
          prev.qt6.qtwebchannel
        ];

        # PRO TIP: If the build still fails during the "checkPhase", 
        # uncomment the line below to skip the tests entirely.
        # doCheck = false;
      });
    })
    ];
  };

  programs.kitty = {
    enable = true;
    extraConfig = ''
      include ~/.local/state/caelestia/theme/kitty.conf
    '';
  };

  xdg.enable = true;

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    setSessionVariables = false;
  };

  wayland.windowManager.hyprland.configType = "lua";
  wayland.windowManager.hyprland.systemd.enable = false;

  services.gnome-keyring.enable = true;

  home.packages = with pkgs; [
    xdg-utils

    grimblast

    swaybg
    sops
    python3
    python313Packages.dbus-python
    btop
  ];

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

  home.file = { };
}
