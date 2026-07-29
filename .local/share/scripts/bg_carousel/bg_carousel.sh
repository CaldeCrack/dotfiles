#!/usr/bin/env bash

# Directory with the files — overridable via -d so the shell can pass its
# configured general.wallpaperDir instead of duplicating that path here.
DIR="$HOME/.config/shared-assets/wallpapers"

# Directory for state files
THIS_DIR=~/.local/share/scripts/bg_carousel
STATE_FILE=$THIS_DIR/.carousel_state

# Wallpaper state shared with Hyprland configs
WALLPAPER_STATE=~/.config/hypr/state/current_wallpaper.conf

CMD1=(matugen image)
CMD2=(hyprctl hyprpaper wallpaper)

# Default direction: forward
DIRECTION="forward"
# Explicit file, set via -w — when present, skips the carousel index math
# and applies this file directly (the case the InfoPanel wallpaper tab
# uses; -f/-b remain for the existing keybind-driven carousel).
EXPLICIT_FILE=""

while getopts "fbw:d:" opt; do
  case "$opt" in
    f) DIRECTION="forward" ;;
    b) DIRECTION="backward" ;;
    w) EXPLICIT_FILE="$OPTARG" ;;
    d) DIR="$OPTARG" ;;
    *) echo "Usage: $0 [-f | -b] [-w <file>] [-d <dir>]"; exit 1 ;;
  esac
done

mkdir -p "$THIS_DIR"

# Get sorted list of files — still needed in explicit mode too, so we can
# locate the picked file's index and keep the carousel in sync for any
# later -f/-b call.
mapfile -t FILES < <(find "$DIR" -maxdepth 1 -type f \
    ! -name ".carousel_state" | sort)

FILE_AMOUNT=${#FILES[@]}

if [ "$FILE_AMOUNT" -eq 0 ]; then
    echo "No files found in $DIR"
    exit 1
fi

if [ -n "$EXPLICIT_FILE" ]; then
    FILE="$EXPLICIT_FILE"
    INDEX=0
    for i in "${!FILES[@]}"; do
        if [ "${FILES[$i]}" = "$FILE" ]; then
            INDEX=$i
            break
        fi
    done
else
    # Read previous index, default to 0
    if [ -f "$STATE_FILE" ]; then
        INDEX=$(<"$STATE_FILE")
    else
        INDEX=0
    fi

    # Ensure index is valid
    if [ "$INDEX" -ge "$FILE_AMOUNT" ] || [ "$INDEX" -lt 0 ]; then
        INDEX=0
    fi

    FILE="${FILES[$INDEX]}"
fi

# Apply wallpaper
"${CMD2[@]}" 'eDP-1,' "$FILE"
"${CMD2[@]}" 'HDMI-A-1,' "$FILE"
"${CMD1[@]}" "$FILE" --source-color-index 0

# Update the shared wallpaper state
mkdir -p "$(dirname "$WALLPAPER_STATE")"
printf '$current_wallpaper = %s\n' "$FILE" > "$WALLPAPER_STATE"

# Update index for next time
if [ "$DIRECTION" = "forward" ]; then
    NEXT_INDEX=$(( (INDEX + 1) % FILE_AMOUNT ))
else
    NEXT_INDEX=$(( (INDEX - 1 + FILE_AMOUNT) % FILE_AMOUNT ))
fi

echo "$NEXT_INDEX" > "$STATE_FILE"
