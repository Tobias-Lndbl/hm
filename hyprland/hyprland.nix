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

      monitor = [
        "HDMI-A-2, 1920x1080@60.00000, 1920x0, 1, transform,1"
        "DP-5, 1920x1080@143.9999, 0x0, 1"
      ];
      
      input = {
        kb_layout = "de";
        follow_mouse = 1;
      };

#      exec-once = [
#        "[workspace 9 silent; noanim] discord"
#        "[workspace 9 silent; noanim] element"
#        "[workspace 9 silent; noanim] spotify"
#      ];

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
        "SUPER, Return, killwindow,"


        #App binds
       # "CTRL, k, exec, kitty"
       # "CTRL, exec, kitty"
       # "SUPER_CTRL, f, exec firefox"
        "SUPER, a, exec, alacritty"

        #Workspace binds
        "SUPER_CTRL, 1, workspace, 1"
        "SUPER_CTRL, 2, workspace, 2"
        "SUPER_CTRL, 3, workspace, 3"
        "SUPER_CTRL, 4, workspace, 4"
        "SUPER_CTRL, 5, workspace, 5"
        "SUPER_CTRL, 6, workspace, 6"
        "SUPER_CTRL, 7, workspace, 7"
        "SUPER_CTRL, 8, workspace, 8"
        "SUPER_CTRL, 9, workspace, 9"

        "SUPER_CTRL, h, workspace, -1"
        "SUPER_CTRL, l, workspace, +1"

        "SUPER_CTRL, q, movetoworkspace, 1"
        "SUPER_CTRL, w, movetoworkspace, 2"
        "SUPER_CTRL, e, movetoworkspace, 3"
        "SUPER_CTRL, r, movetoworkspace, 4"
        "SUPER_CTRL, t, movetoworkspace, 5"
        "SUPER_CTRL, z, movetoworkspace, 6"
        "SUPER_CTRL, u, movetoworkspace, 7"
        "SUPER_CTRL, i, movetoworkspace, 8"
        "SUPER_CTRL, o, movetoworkspace, 9"

        "SUPER_CTRL, y, movetoworkspace, -1"
        "SUPER_CTRL, x, movetoworkspace, +1"

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
        "SUPER_CTRL, a, changegroupactive, f"
        "SUPER_CTRL, s, moveoutofgroup,"
        "SUPER_CTRL, left, moveintogroup, l"
        "SUPER_CTRL, right, moveintogroup, r"
        "SUPER_CTRL, up, moveintogroup, u"
        "SUPER_CTRL, down, moveintogroup, d"
      ];  #++ switch_workspace ++ move_workspace;

#      workspace = [
#        "1,monitor:${config.monitors.center}"
#        "2,monitor:${config.monitors.center}"
#        "3,monitor:${config.monitors.center}"

#        "8,monitor:${config.monitors.right}"
#        "9,monitor:${config.monitors.right}"
#      ];

      bindm = [
        "SUPER, mouse:272, movewindow"
      ];
  };
}
