{
  config,
  pkgs,
  lib,
  ...
}:

{
  wayland.windowManager.hyprland.settings = {
    exec-once = [
      "iio-hyprland"
    ];
    monitor = [
      "eDP-1,2880x1800@120,auto,1.6"
    ];
  };
}
