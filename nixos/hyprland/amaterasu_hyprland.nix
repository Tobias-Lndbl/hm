{ config, pkgs, lib, ... }:

{
  wayland.windowManager.hyprland = {
    extraConfig = ''
      ------------------------------------------------------
      -- MACHINE-SPECIFIC MONITORS
      ------------------------------------------------------
      hl.monitor({ output = "DP-3", mode = "1920x1080@144", position = "0x0", scale = 1 })
      hl.monitor({ output = "DP-6", mode = "1920x1080@144", position = "0x0", scale = 1 })

      hl.monitor({ output = "DP-2", mode = "3840x2160@60", position = "0x-1080", scale = 2 })
      hl.monitor({ output = "DP-5", mode = "3840x2160@60", position = "0x-1080", scale = 2 })
      -- hl.monitor({ output = "DP-5", mode = "1920x1080@143.95", position = "0x-1080", scale = 1 })

      hl.monitor({ output = "HDMI-A-1", mode = "1920x1080@60", position = "1920x-360", scale = 1, transform = 1 })
      hl.monitor({ output = "HDMI-A-2", mode = "1920x1080@60", position = "1920x-360", scale = 1, transform = 1 })

      ------------------------------------------------------
      -- MACHINE-SPECIFIC WORKSPACES
      ------------------------------------------------------
      -- Bound by EDID description (prefix match), since the connector names
      -- shift between boots (DP-3/DP-6, DP-2/DP-5, HDMI-A-1/HDMI-A-2).
      hl.workspace_rule({ workspace = "2", monitor = "desc:ASUSTek COMPUTER INC ASUS VG249", default = true })
      hl.workspace_rule({ workspace = "3", monitor = "desc:ASUSTek COMPUTER INC ASUS VG249" })
      hl.workspace_rule({ workspace = "1", monitor = "desc:Acer Technologies Acer G245H", default = true })
      -- SUPER+0 targets workspace 10 (see the bind loop in hyprland.nix)
      hl.workspace_rule({ workspace = "10", monitor = "desc:Samsung Electric Company", default = true })

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
