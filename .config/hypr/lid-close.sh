#!/usr/bin/env sh

pidof hyprlock || hyprlock &
sleep 1
systemctl suspend

