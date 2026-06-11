#!/usr/bin/env bash

# Directory with the files
DIR=~/.config/shared-assets/wallpapers

# File to store the current index
THIS_DIR=~/.local/share/scripts/bg_carousel
STATE_FILE=$THIS_DIR/.carousel_state

CMD1=(matugen image)
CMD2=(hyprctl hyprpaper wallpaper)

# Default direction: forward
DIRECTION="forward"

# Parse flags
while getopts "fb" opt; do
  case "$opt" in
    f) DIRECTION="forward" ;;
    b) DIRECTION="backward" ;;
    *) echo "Usage: $0 [-f | -b]"; exit 1 ;;
  esac
done

# Get sorted list of files (excluding the state file)
mapfile -t FILES < <(find "$DIR" -maxdepth 1 -type f \
    ! -name ".carousel_state" | sort)

FILE_AMOUNT=${#FILES[@]}

# No files case
if [ $FILE_AMOUNT -eq 0 ]; then
    echo "No files found in $DIR"
    exit 1
fi

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

# Pick the file
FILE="${FILES[$INDEX]}"

# Run the commands
"${CMD2[@]}" 'eDP-1,' "$FILE" && "${CMD1[@]}" "$FILE" --source-color-index 0
"${CMD2[@]}" 'HDMI-A-1,' "$FILE" && "${CMD1[@]}" "$FILE" --source-color-index 0

# Update index for next time
if [ "$DIRECTION" = "forward" ]; then
  NEXT_INDEX=$(( (INDEX + 1) % FILE_AMOUNT ))
else
  NEXT_INDEX=$(( (INDEX - 1 + FILE_AMOUNT) % FILE_AMOUNT ))
fi

echo "$NEXT_INDEX" > "$STATE_FILE"
