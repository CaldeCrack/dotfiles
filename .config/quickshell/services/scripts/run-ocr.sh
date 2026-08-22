#!/usr/bin/env bash
# Select a screen region, OCR it, copy the recognized text to the
# clipboard, and report success/failure via notify-send.
#
# Runs via Quickshell.execDetached rather than a tracked Process — a
# tracked Process reliably failed to actually launch slurp until
# something else (e.g. a config reload) kicked the QML engine, while
# execDetached launches it immediately and consistently. Since
# execDetached is fire-and-forget with no way for QML to see the exit
# code, all feedback (including failures) has to happen here via
# notify-send rather than Quickshell's own Notifications.notify() API.
set -uo pipefail

have_notify=1
command -v notify-send >/dev/null 2>&1 || have_notify=0

notify() {
    # $1 summary, $2 body, $3 urgency (low|normal|critical)
    [[ "$have_notify" -eq 1 ]] || return 0
    notify-send -a "OCR" -u "${3:-normal}" "$1" "$2"
}

for cmd in slurp grim tesseract wl-copy; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        notify "OCR failed" "Missing required tool: $cmd" critical
        exit 3
    fi
done

geometry="$(slurp)"
if [[ -z "$geometry" ]]; then
    # User cancelled the selection (Escape) — slurp exits non-zero the
    # same way on a real error, so this is treated as a cancel either way
    # rather than risking a false "OCR failed" notification on a plain
    # Escape, the overwhelmingly common case.
    exit 2
fi

text="$(grim -g "$geometry" - | tesseract - - 2>/dev/null | sed '/^[[:space:]]*$/d')"

if [[ -z "$text" ]]; then
    notify "OCR failed" "No text detected in selection" critical
    exit 1
fi

printf '%s' "$text" | wl-copy

preview="$text"
if [[ ${#preview} -gt 120 ]]; then
    preview="${preview:0:120}…"
fi
notify "Text copied to clipboard" "$preview"

echo "$text"
