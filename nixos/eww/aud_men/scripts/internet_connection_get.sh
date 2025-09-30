#!/bin/sh

nmcli -t -f name connection show --active | head -n 1
