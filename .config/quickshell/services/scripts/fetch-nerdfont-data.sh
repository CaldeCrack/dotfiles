#!/usr/bin/env bash
# Fetches Nerd Fonts' own glyphnames.json (the authoritative name -> codepoint
# mapping the project maintains) and reshapes it into the flat array
# NerdFont.qml expects:
#   [{ "char": "", "name": "cod-account", "code": "eb99" }, ...]
#
# Run manually, or via the shell's "refetch" button (NerdFontData.qml calls
# this through a Process, same as Recording/Clipboard shell out elsewhere).
# Safe to re-run any time — it always does a full re-fetch and overwrite,
# there's no incremental/diff mode.
set -euo pipefail

SOURCE_URL="https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/glyphnames.json"

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
OUTPUT_DIR="$(cd -- "$SCRIPT_DIR/../.." >/dev/null 2>&1 && pwd)/assets/data"
OUTPUT_FILE="$OUTPUT_DIR/nerdfont.json"

for cmd in curl jq; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "fetch-nerdfont-data: '$cmd' is required but not installed" >&2
        exit 1
    fi
done

mkdir -p "$OUTPUT_DIR"

tmp_file="$(mktemp)"
trap 'rm -f "$tmp_file"' EXIT

if ! curl -fsSL "$SOURCE_URL" -o "$tmp_file"; then
    echo "fetch-nerdfont-data: failed to download $SOURCE_URL" >&2
    exit 1
fi

# The source is an object keyed by glyph name, with one extra "METADATA" key
# (nerd-fonts version/date, not a glyph) that needs dropping. Reshape into a
# flat array sorted by name so the output is stable/diffable across fetches.
jq '
    to_entries
    | map(select(.key != "METADATA"))
    | map({ char: .value.char, name: .key, code: .value.code })
    | sort_by(.name)
' "$tmp_file" >"$OUTPUT_FILE"

count=$(jq 'length' "$OUTPUT_FILE")
echo "fetch-nerdfont-data: wrote $count glyphs to $OUTPUT_FILE"
