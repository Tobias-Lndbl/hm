#!/bin/sh
ws=$(hyprctl activeworkspace | grep -oP 'workspace ID \K\d+(?= \(\d+\) on monitor)')

echo ${ws}
