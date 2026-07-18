#!/usr/bin/env bash

pidof hyprlock || hyprlock &
sleep 1
systemctl suspend

