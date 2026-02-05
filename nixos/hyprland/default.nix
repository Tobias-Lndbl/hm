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
      scalingPriority = "both";
      wallpaper.enable = false;

    menus = {
        clock.weather.unit = "metric";
        clock.weather.enable = true;
        clock.weather.location = "Germering";

        clock.time.military = true;
        clock.time.hideSeconds = false;

    };

      bar = {
        launcher.autoDetectIcon = true;
        clock.format = "%H:%M:%S";

        workspaces.show_numbered = true;
        workspaces.numbered_active_indicator = "highlight";



        layouts."*" = {
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
            "battery"
            "bluetooth"
            #(if config.appearance.hasBattery then "battery" else "")
            "network"
            "clock"
            "systray"
            "notifications"
          ];
        };
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
