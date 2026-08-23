#!/usr/bin/env bash
# Reads text from stdin, generates a QR code PNG from it via qrencode,
# and saves it under $QR_SAVE_DIR (default ~/Pictures/QRCodes).
#
# Optional $1: timestamp to use in the filename, supplied by
# QrCodeOptions.qml so QML and this script agree on the exact output path
# up front — QML needs to know it immediately for the "open generated
# file" button, and this runs via execDetached (fire-and-forget, no
# stdout capture back to QML), so the script can't just report the path
# afterwards. Falls back to computing its own timestamp if run standalone
# without that argument.
set -uo pipefail

SAVE_DIR="${QR_SAVE_DIR:-$HOME/Pictures/QRCodes}"
TIMESTAMP="${1:-$(date +%Y-%m-%d_%H-%M-%S)}"

have_notify=1
command -v notify-send >/dev/null 2>&1 || have_notify=0

notify() {
    [[ "$have_notify" -eq 1 ]] || return 0
    notify-send -a "QR Code" -u "${3:-normal}" "$1" "$2"
}

if ! command -v qrencode >/dev/null 2>&1; then
    notify "QR generation failed" "qrencode is not installed" critical
    exit 3
fi

text="$(cat)"
if [[ -z "$text" ]]; then
    notify "QR generation failed" "No text provided" critical
    exit 1
fi

mkdir -p "$SAVE_DIR"
out_file="$SAVE_DIR/qr_$TIMESTAMP.png"

if ! printf '%s' "$text" | qrencode -o "$out_file" 2>/dev/null; then
    notify "QR generation failed" "qrencode failed to generate the code" critical
    exit 1
fi

notify "QR code saved" "$out_file"
