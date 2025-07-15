  { writeShellScriptBin }:

  writeShellScriptBin "rotate" ''
    hyprctl keyword monitor HDMI-A-2, transform, $1 &&\
    hyprctl keyword input:touchdevice:transform $1 &&\
   # eww reload
  ''
