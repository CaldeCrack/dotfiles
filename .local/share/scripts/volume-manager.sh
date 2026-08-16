#!/usr/bin/env bash

increase_volume() {
	wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%+ -l 1
}

decrease_volume() {
	wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-
}

toggle_mute() {
	wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
}

# Flags
if [[ "$1" == "-i" ]]; then
	increase_volume
elif [[ "$1" == "-d" ]]; then
	decrease_volume
elif [[ "$1" == "-t" ]]; then
	toggle_mute
fi

