{pkgs, ...}:

pkgs.writeShellScriptBin "workspace-exists" ''
  ws=$(hyprctl workspaces | grep -oP 'workspace ID \K\d+(?= \(\d+\) on monitor)')


''
