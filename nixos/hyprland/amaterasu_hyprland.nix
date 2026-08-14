{ config, pkgs, lib, ... }:

{
  wayland.windowManager.hyprland = {
    extraConfig = ''
      ------------------------------------------------------
      -- MACHINE-SPECIFIC MONITORS
      ------------------------------------------------------
      hl.monitor({ output = "DP-3", mode = "1920x1080@144", position = "0x1440", scale = 1 })
      hl.monitor({ output = "DP-6", mode = "1920x1080@144", position = "0x1440", scale = 1 })

      hl.monitor({ output = "DP-2", mode = "3840x2160@60", position = "0x-1440", scale = 1.5 })
      hl.monitor({ output = "DP-5", mode = "3840x2160@60", position = "0x-1440", scale = 1.5 })

      hl.monitor({ output = "HDMI-A-1", mode = "1920x1080@60", position = "1920x1440", scale = 1, transform = 1 })
      hl.monitor({ output = "HDMI-A-2", mode = "1920x1080@60", position = "1920x1440", scale = 1, transform = 1 })

      ------------------------------------------------------
      -- MACHINE-SPECIFIC WORKSPACES
      ------------------------------------------------------
      hl.workspace_rule({ workspace = "2", monitor = "DP-3", default = true })
      hl.workspace_rule({ workspace = "3", monitor = "DP-3", default = true })
      hl.workspace_rule({ workspace = "0", monitor = "DP-2", default = true })
      hl.workspace_rule({ workspace = "1", monitor = "HDMI-A-1", default = true })

      ------------------------------------------------------
      -- NVIDIA ENV VARS
      ------------------------------------------------------
      hl.env("LIBVA_DRIVER_NAME", "nvidia")
      hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")

      ------------------------------------------------------
      -- XWAYLAND PRIMARY
      ------------------------------------------------------
      hl.on("hyprland.start", function() 
        hl.exec_cmd("xrandr --output DP-3 --primary")
      end)
    '';
  };
}
