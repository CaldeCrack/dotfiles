#!/usr/bin/env bash

get_brightness() {
  brightnessctl g
}

get_max_brightness() {
  brightnessctl m
}

get_icon() {
	echo "/usr/share/icons/custom/brightness.png"
}

notify_user() {
	brightness=$(get_brightness)
	max_brightness=$(get_max_brightness)
	norm_brightness=$(echo "$brightness" "$max_brightness" | awk '{print $1 / $2 * 100 }')
	str_brightness=$(printf "%3d" "$norm_brightness")
	dunstify -a "changeBrightness" -u low -i "$(get_icon)" -h string:x-dunst-stack-tag:mybrightness -h int:value:"$norm_brightness" "Brightness: ${str_brightness}%"
}

set_max_brightness() {
  brightnessctl s $(get_max_brightness) && notify_user
}

set_min_brightness() {
  brightnessctl s 0
}

increase_brightness() {
	brightnessctl s 1%+ && notify_user
}

decrease_brightness() {
	brightnessctl s 1%- && notify_user
}

# Flags
if [[ "$1" == "-i" ]]; then
	increase_brightness
elif [[ "$1" == "-m" ]]; then
  set_max_brightness
elif [[ "$1" == "-l" ]]; then
  set_min_brightness
else
	decrease_brightness
fi

