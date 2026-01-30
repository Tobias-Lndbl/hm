{
  pkgs,
  config,
  lib,
  ...
}:

{
  imports = [
    ./wofi.nix
    ./stylix.nix
    ./grim.nix
  ];

  programs.hyprlock.enable = true;

  programs.hyprpanel = {
    enable = true;
    settings = {
      bar.bluetooth.label = false;
      bar.clock.format = "%a %b %d %H:%M:%S";
      bar.dashboard.icon = "󱄅";
      general.scaling_priority = "gdk";
      wallpaper.enable = false;

      bar.layouts = {
        left = [
          "dashboard"
          "workspaces"
          "windowtitle"
        ];
        middle = [
          "media"
        ];
        right = [
          "volume"
          "network"
          "clock"
          "systray"
          "notifications"
        ];
      };

      theme = {
        #font.size = config.appearance.fontSize;
	      font.size = 12;
        bar.transparent = true;
        bar.location = "bottom";
      };
    };
  };

  home.packages = with pkgs; [
    wl-clipboard
  ];


  programs.bash.bashrcExtra = ''
    ccat() {
      cat "$1" | wl-copy
    }
  '';
  programs.bash.shellAliases = {
    cpwd = "pwd | wl-copy";
  };

  home.sessionVariables = {
    _JAVA_AWT_WM_NONREPARENTING = "1";
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    SDL_VIDEODRIVER = "wayland";
    XDG_SESSION_TYPE = "wayland";
    NIXOS_OZONE_WL = "1";
    GDK_BACKEND = "wayland";
  };

  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;
      preload = [ "${config.stylix.image}" ];
      
      # NEW SYNTAX: Uses a list of strings formatted for the new parser
      wallpaper = [
        ", ${config.stylix.image}"
      ];
    };
  };

  stylix.cursor = {
    name = "phinger-cursors-light";
    package = pkgs.phinger-cursors;
    size = 28;
  };
}
