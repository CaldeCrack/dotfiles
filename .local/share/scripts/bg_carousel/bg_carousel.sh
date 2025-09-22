#!/usr/bin/env bash

# Directory with the files
DIR=~/.config/assets/wallpapers

# File to store the current index
THIS_DIR=~/.local/share/scripts/bg_carousel
STATE_FILE=$THIS_DIR/.carousel_state

# Config file for extra flags (optional)
FLAGS_FILE=$THIS_DIR/flags.conf

# Command you want to run (replace "echo" with your command)
CMD1=(hyprctl hyprpaper reload ,)
CMD2=(hellwal --check-contrast -q -f ~/dotfiles/.config/hellwal/templates)

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

# Get sorted list of files (excluding the state file and flags file)
mapfile -t FILES < <(find "$DIR" -maxdepth 1 -type f \
    ! -name ".carousel_state" ! -name "flags.conf" | sort)

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
BASENAME="$(basename "$FILE")"

# Lookup extra flags (if any)
EXTRA_FLAGS=""
if [ -f "$FLAGS_FILE" ]; then
    LINE=$(grep -E "^${BASENAME}:" "$FLAGS_FILE" || true)
    if [ -n "$LINE" ]; then
        EXTRA_FLAGS="${LINE#*:}"
    fi
fi

# Run the commands
"${CMD1[@]}" "$FILE"
"${CMD2[@]}" $EXTRA_FLAGS -i "$FILE"

# Update index for next time
if [ "$DIRECTION" = "forward" ]; then
  NEXT_INDEX=$(( (INDEX + 1) % FILE_AMOUNT))
else
  NEXT_INDEX=$(( (INDEX - 1 + FILE_AMOUNT) % FILE_AMOUNT ))
fi

echo "$NEXT_INDEX" > "$STATE_FILE"

