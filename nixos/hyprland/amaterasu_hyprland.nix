{ config, pkgs, lib, ... }:

{
  wayland.windowManager.hyprland = {
    # extraConfig is types.lines, so this gets concatenated onto the string
    # from hyprland.nix -- order between the two files doesn't matter here
    # since these calls don't depend on each other.
    extraConfig = ''
      ------------------------------------------------------
      -- MACHINE-SPECIFIC MONITORS
      ------------------------------------------------------
      hl.monitor({ output = "DP-3", mode = "1920x1080@144", position = "0x0", scale = 1 })
      hl.monitor({ output = "DP-6", mode = "1920x1080@144", position = "0x0", scale = 1 })

      hl.monitor({ output = "DP-2", mode = "3840x2160@60", position = "-320x-1440", scale = 1.5 })
      hl.monitor({ output = "DP-5", mode = "3840x2160@60", position = "-320x-1440", scale = 1.5 })

      hl.monitor({ output = "HDMI-A-1", mode = "1920x1080@60", position = "1920x-0", scale = 1, transform = 1 })
      hl.monitor({ output = "HDMI-A-2", mode = "1920x1080@60", position = "1920x-0", scale = 1, transform = 1 })

      ------------------------------------------------------
      -- MACHINE-SPECIFIC WORKSPACES
      ------------------------------------------------------
      hl.workspace_rule({ workspace = "2", monitor = "DP-3", default = true })
      hl.workspace_rule({ workspace = "2", monitor = "DP-6", default = true })

      ------------------------------------------------------
      -- NVIDIA ENV VARS
      ------------------------------------------------------
      hl.env("LIBVA_DRIVER_NAME", "nvidia")
      hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
    '';
  };
}
