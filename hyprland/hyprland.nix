{inputs, outputs, lib, config, pkgs, ...}:
let 
  switch_workspace = builtins.map (ws: "SUPER, ${ws}, workspace, ${ws}") config.workspaces;

  move_workspace = builtins.map (ws: "SUPER_SHIFT, ${ws}, movetoworkspace, ${ws}") config.workspaces;

in
{
    wayland.windowManager.hyprland.enable = true;
    programs.kitty.enable = true;

  wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";
    bind =
      [
        "$mod, F, exec, firefox"
        ", Print, exec, grimblast copy area"
      ]
      ++ (
        # workspaces
        # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
        builtins.concatLists (builtins.genList (i:
            let ws = i + 1;
            in [
              "$mod, code:1${toString i}, workspace, ${toString ws}"
              "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
            ]
          )
          9)
      );

      env = [
       "IBVA_DRIVER_NAME,nvidia"
       "__GLX_VENDOR_LIBRARY_NAME,nvidia"
      ];
  };
}
