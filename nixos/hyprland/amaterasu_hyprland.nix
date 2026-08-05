{ config, pkgs, lib, ... }:

{
  wayland.windowManager.hyprland.settings = {
    
    # -----------------------------------------------------
    # MACHINE-SPECIFIC MONITORS
    # -----------------------------------------------------
    monitor = [
      "DP-3, 1920x1080@144, 0x0, 1"
      "DP-6, 1920x1080@144, 0x0, 1"

      "DP-2, 3840x2160@60, -320x-1440, 1.5"
      "DP-5, 3840x2160@60, -320x-1440, 1.5"

      "HDMI-A-1, 1920x1080@60, 1920x-0, 1, transform, 1"
      "HDMI-A-2, 1920x1080@60, 1920x-0, 1, transform, 1"
    ];

    # -----------------------------------------------------
    # MACHINE-SPECIFIC WORKSPACES
    # -----------------------------------------------------
    workspace = [
      "2, monitor:DP-3"
      "2, monitor:DP-6"
    ];

    # -----------------------------------------------------
    # NVIDIA ENV VARS
    # -----------------------------------------------------
    env = [
      "LIBVA_DRIVER_NAME,nvidia"
      "__GLX_VENDOR_LIBRARY_NAME,nvidia"
    ];
  };
}
