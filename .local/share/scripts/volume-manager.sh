#!/usr/bin/env bash

iDIR="/usr/share/icons/custom"

get_volume() {
	volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
	volume_num=$(echo "$volume" | cut -d " " -f 2)
	echo "$(awk "BEGIN {print $volume_num * 100 }")"
}

get_mute() {
	volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
	echo "$volume" | cut -d " " -f 3
}

get_icon() {
	current=$(get_volume)
	mute=$(get_mute)
	if [[ "$current" -eq "0" || "$mute" = "[MUTED]" ]]; then
		echo "$iDIR/volume_mute.png"
	elif [[ "$current" -ge "66" ]]; then
		echo "$iDIR/volume_high.png"
	elif [[ "$current" -ge "33" ]]; then
		echo "$iDIR/volume_normal.png"
	else
		echo "$iDIR/volume_low.png"
	fi
}

notify_user() {
	volume=$(get_volume)
	str_volume=$(printf "%3d" "$volume")
	mute=$(get_mute)
	if [[ "$mute" = "[MUTED]" ]]; then
		dunstify -a "changeVolume" -u low -i "$(get_icon)" -h string:x-dunst-stack-tag:myvolume "Volume muted" 
	else
		dunstify -a "changeVolume" -u low -i "$(get_icon)" -h string:x-dunst-stack-tag:myvolume -h int:value:"$volume" "Volume: ${str_volume}%"
	fi
}

increase_volume() {
	wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%+ -l 1 && notify_user
}

decrease_volume() {
	wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%- && notify_user
}

toggle_mute() {
	wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle && notify_user
}

# Flags
if [[ "$1" == "-i" ]]; then
	increase_volume
elif [[ "$1" == "-d" ]]; then
	decrease_volume
elif [[ "$1" == "-t" ]]; then
	toggle_mute
fi

