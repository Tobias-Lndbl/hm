{pkgs, config, ...}:
let 
  switch_workspace = builtins.map (ws: "SUPER, ${ws}, workspace, ${ws}") config.workspaces;

  move_workspace = builtins.map (ws: "SUPER_SHIFT, ${ws}, movetoworkspace, ${ws}") config.workspaces;

in
{
    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
    };
    programs.kitty.enable = true;

  wayland.windowManager.hyprland.settings = {
      env = [
       "IBVA_DRIVER_NAME,nvidia"
       "__GLX_VENDOR_LIBRARY_NAME,nvidia"
      ];
      
      input = {
        kb_layout = "de";
        follow_mouse = 1;
      };

      exec-once = [
        "[workspace 9 silent; noanim] discord"
        "[workspace 9 silent; noanim] element"
        "[workspace 9 silent; noanim] spotify"
      ];

      decoration = {
        rounding = 5;
        blur = {
          enabled = true;
          size = 3;
          passes = 2;
        };
      };

      animations = {
        enabled = 1;
        animation = [
          "windows,1,7,default"
          "workspaces,1,6,default"
        ];
      };

      bind = [
        #App binds
       # "CTRL, k, exec, kitty"

        # Move focus
        "SUPER, left, movefocus, l"
        "SUPER, right, movefocus, r"
        "SUPER, up, movefocus, u"
        "SUPER, down, movefocus, d"

        "SUPER, h, movefocus, l"
        "SUPER, l, movefocus, r"
        "SUPER, k, movefocus, u"
        "SUPER, j, movefocus, d"

        "SUPER_SHIFT, left, movewindow, l"
        "SUPER_SHIFT, right, movewindow, r"
        "SUPER_SHIFT, up, movewindow, u"
        "SUPER_SHIFT, down, movewindow, d"

        "SUPER_SHIFT, h, movewindow, l"
        "SUPER_SHIFT, l, movewindow, r"
        "SUPER_SHIFT, k, movewindow, u"
        "SUPER_SHIFT, j, movewindow, d"

        "SUPER, q, togglesplit,"
        "SUPER, v, togglefloating,"
        "SUPER, v, centerwindow,"
        "SUPER, f, fullscreen,"
        "SUPER_SHIFT, f, fullscreenstate, -1 2"

        # Groups
        "SUPER_CTRL, g, togglegroup,"
        "SUPER_CTRL, w, changegroupactive, f"
        "SUPER_CTRL, e, moveoutofgroup,"
        "SUPER_CTRL, left, moveintogroup, l"
        "SUPER_CTRL, right, moveintogroup, r"
        "SUPER_CTRL, up, moveintogroup, u"
        "SUPER_CTRL, down, moveintogroup, d"
        "SUPER_CTRL, h, moveintogroup, l"
        "SUPER_CTRL, l, moveintogroup, r"
        "SUPER_CTRL, k, moveintogroup, u"
        "SUPER_CTRL, j, moveintogroup, d"
      ] ++ switch_workspace ++ move_workspace;

      workspace = [
        "1,monitor:${config.monitors.center}"
        "2,monitor:${config.monitors.center}"
        "3,monitor:${config.monitors.center}"

        "8,monitor:${config.monitors.right}"
        "9,monitor:${config.monitors.right}"
      ];

      bindm = [
        "SUPER, mouse:272, movewindow"
      ];
  };
}
