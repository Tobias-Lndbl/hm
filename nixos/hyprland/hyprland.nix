{
  config,
  pkgs,
  lib,
  ...
}:

{
  wayland.windowManager.hyprland = {
    enable = true;

    # Optional: You had this in your home config[cite: 1]
    # configType = "hyprlang";

    settings = {
      # -----------------------------------------------------
      # VARIABLES
      # -----------------------------------------------------
      "$terminal" = "kitty";
      "$fileManager" = "nautilus";
      "$browser" = "zen";
      "$browser-new-window" = "zen --blank-window";
      "$browser-private-window" = "zen --private-window";
      "$nextcloud" = "[fullscreenstate -1, 2] firefox https://nextcloud.lndbl.de  --new-window";
      "$matrix" = "https://matrix.tum.de/#/home";
      "$music" = "feishin";
      "$calendar" = "https://nextcloud.home/apps/calendar";
      "$mail" = "https://nextcloud.home/apps/mail";
      "$japanese" = "fcitx5 --enable mozc";
      "$trilium" = "trilium";
      "$xournalpp" = "xournalpp ~/Templates/xournalpp_template.xopp";
      "$menu" = "caelestia:launcher";
      "$mainMod" = "SUPER";

      # -----------------------------------------------------
      # AUTOSTART & ENVIRONMENT
      # -----------------------------------------------------
      exec-once = [
        "$japanese"
      ];

      env = [
        "QT_QPA_PLATFORMTHEME,qt6ct"
      ];

      # -----------------------------------------------------
      # LOOK AND FEEL
      # -----------------------------------------------------
      general = {
        gaps_in = 2.5;
        gaps_out = 5;
        border_size = 2;
        resize_on_border = false;
        allow_tearing = false;
        layout = "dwindle";
      };

      decoration = {
        rounding = 15;
        active_opacity = 1.0;
        inactive_opacity = 1.0;

        shadow.enabled = false;

        blur = {
          enabled = true;
          size = 5;
          passes = 2;
          vibrancy = 0.5;
        };
      };

      animations = {
        enabled = false;
        bezier = [
          "easeOutQuint,0.23,1,0.32,1"
          "easeInOutCubic,0.65,0.05,0.36,1"
          "linear,0,0,1,1"
          "almostLinear,0.5,0.5,0.75,1.0"
          "quick,0.15,0,0.1,1"
        ];
        animation = [
          "global, 1, 10, default"
          "border, 1, 5.39, easeOutQuint"
          "windows, 1, 4.79, easeOutQuint"
          "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
          "windowsOut, 1, 1.49, linear, popin 87%"
          "fadeIn, 1, 1.73, almostLinear"
          "fadeOut, 1, 1.46, almostLinear"
          "fade, 3, 3.03, quick"
          "layers, 1, 3.81, easeOutQuint"
          "layersIn, 1, 4, easeOutQuint, fade"
          "layersOut, 1, 1.5, linear, fade"
          "fadeLayersIn, 1, 1.79, almostLinear"
          "fadeLayersOut, 1, 1.39, almostLinear"
          "workspaces, 1, 1.94, almostLinear, fade"
          "workspacesIn, 1, 1.21, almostLinear, fade"
          "workspacesOut, 1, 1.94, almostLinear, fade"
        ];
      };

      dwindle.preserve_split = true;
      master.new_status = "master";

      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
      };

      ecosystem.no_update_news = true;
      "allow_session_lock_restore" = true;

      # -----------------------------------------------------
      # INPUT
      # -----------------------------------------------------
      input = {
        kb_layout = "de";
        follow_mouse = 1;
        sensitivity = 0;
        touchpad.natural_scroll = false;
      };

      device = {
        name = "epic-mouse-v1";
        sensitivity = -0.5;
      };

      # -----------------------------------------------------
      # KEYBINDINGS
      # -----------------------------------------------------
      bind = [
        "$mainMod, C, killactive"
        "$mainMod, V, togglefloating"
        "$mainMod, P, pseudo"
        "$mainMod, X, layoutmsg, togglesplit"
        "$mainMod, F, fullscreen"
        "$mainMod SHIFT, F, fullscreenstate, -1, 2"
        "$mainMod, SPACE, global, $menu"
        "$mainMod, Q, exec, $terminal"
        "$mainMod CONTROL, N, exec, $fileManager"
        "$mainMod, B, exec, $browser"
        "$mainMod, N, exec, $browser-new-window"
        "$mainMod, M, exec, $browser-private-window"
        "$mainMod, Y, exec, $xournalpp"
        "$mainMod, T, exec, $trilium"
        "$mainMod CONTROL, K, exec, $nextcloud"
        "$mainMod CONTROL, S, exec, grimblast save area ~/Pictures/Screenshots/$(date +'%Y-%m-%d_%H-%M-%S').png"

        # Resize
        "$mainMod ALT, h, resizeactive, -100 0"
        "$mainMod ALT, l, resizeactive, 100 0"
        "$mainMod ALT, j, resizeactive, 0 100"
        "$mainMod ALT, k, resizeactive, 0 -100"

        # Move Focus
        "$mainMod, h, movefocus, l"
        "$mainMod, l, movefocus, r"
        "$mainMod, k, movefocus, u"
        "$mainMod, j, movefocus, d"

        # Switch workspaces with mainMod + [0-9]
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"

        # Move window within workspace
        "$mainMod SHIFT, h, movewindow, l"
        "$mainMod SHIFT, l, movewindow, r"
        "$mainMod SHIFT, k, movewindow, u"
        "$mainMod SHIFT, j, movewindow, d"

        # Scratchpad
        "$mainMod, S, togglespecialworkspace, magic"
        "$mainMod SHIFT, S, movetoworkspace, special:magic"

        # Mouse Workspace Scrolling
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"
      ];

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      bindel = [
        ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+"
        ",XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"
      ];

      bindl = [
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
      ];
    };

    # For niche blocks like xwayland that might behave unusually in strict Nix mapping
    extraConfig = ''
      xwayland {
        force_zero_scaling = true
      }
    '';
  };
}
