{pkgs, ...}:

pkgs.writeShellScriptBin "workspace-script" ''
  cws=$(hyprctl activeworkspace | grep -oP 'workspace ID \K\d+(?= \(\d+\) on monitor)')

  echo $cws
''
