#!/usr/bin/env bash

get_max_brightness() {
  brightnessctl m
}

set_max_brightness() {
  brightnessctl s $(get_max_brightness)
}

set_min_brightness() {
  brightnessctl s 0
}

increase_brightness() {
	brightnessctl s 1%+
}

decrease_brightness() {
	brightnessctl s 1%-
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

