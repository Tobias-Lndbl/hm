{
  config,
  pkgs,
  lib,
  ...
}:

{
  wayland.windowManager.hyprland = {
    settings = { };

    extraConfig = ''
      ------------------------------------------------------
      -- INARI-SPECIFIC
      ------------------------------------------------------
      hl.monitor({
        output = "eDP-1",
        mode = "2880x1800@120",
        position = "auto",
        scale = 1.6,
      })

      hl.on("hyprland.start", function()
        hl.exec_cmd("iio-hyprland")
      end)
    '';
  };
}
