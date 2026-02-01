#!/bin/bash

chosen=$(printf " Lock\n Logout\n Reboot\n⏻ Shutdown" | rofi -dmenu -p "Power")

case "$chosen" in
  " Lock") hyprlock ;;
  " Logout") hyprctl dispatch exit ;;
  " Reboot") systemctl reboot ;;
  "⏻ Shutdown") systemctl poweroff ;;
esac

