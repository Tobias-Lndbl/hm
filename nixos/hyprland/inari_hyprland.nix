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

      hl.monitor({
        output = "DP-2",
        -- mode = "2560x1440@59",
        mode = "1920x1080@60.00",
        position = "auto",
        scale = 1,
      })

      hl.on("hyprland.start", function()
        hl.exec_cmd("iio-hyprland")
      end)
    '';
  };
}
