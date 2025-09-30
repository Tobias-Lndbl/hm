#!/bin/sh
ws=$(hyprctl workspaces | grep -oP 'workspace ID \K\d+(?= \(\d+\) on monitor)')

echo ${ws}
