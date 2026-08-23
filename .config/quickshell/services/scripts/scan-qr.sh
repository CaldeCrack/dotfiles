#!/usr/bin/env bash
# Select a screen region, decode any QR code in it via zbarimg, and copy
# the decoded text to the clipboard. Same notify-send-driven feedback
# pattern as run-ocr.sh, for the same reason: this runs via
# Quickshell.execDetached (fire-and-forget), so there's no way for QML to
# see the outcome — a tracked Process was tried for run-ocr.sh and didn't
# reliably launch slurp at all until something else kicked the QML
# engine, so execDetached is the one known-working approach here.
#
# Exit codes aren't consumed by anything but kept meaningful for manual
# debugging:
#   0 - success, text copied
#   1 - a selection was made but no QR code was found in it
#   2 - user cancelled the slurp selection
#   3 - a required tool is missing
set -uo pipefail

have_notify=1
command -v notify-send >/dev/null 2>&1 || have_notify=0

notify() {
    # $1 summary, $2 body, $3 urgency (low|normal|critical)
    [[ "$have_notify" -eq 1 ]] || return 0
    notify-send -a "QR Code" -u "${3:-normal}" "$1" "$2"
}

for cmd in slurp grim zbarimg wl-copy; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        notify "QR scan failed" "Missing required tool: $cmd" critical
        exit 3
    fi
done

geometry="$(slurp)"
if [[ -z "$geometry" ]]; then
    # Cancelled selection (Escape) — slurp exits non-zero the same way on
    # a real error, so this is treated as a cancel either way rather than
    # risking a false "scan failed" notification on a plain Escape.
    exit 2
fi

text="$(grim -g "$geometry" - | zbarimg --raw -q - 2>/dev/null)"

if [[ -z "$text" ]]; then
    notify "QR scan failed" "No QR code detected in selection" critical
    exit 1
fi

printf '%s' "$text" | wl-copy

preview="$text"
if [[ ${#preview} -gt 120 ]]; then
    preview="${preview:0:120}…"
fi
notify "QR content copied to clipboard" "$preview"
