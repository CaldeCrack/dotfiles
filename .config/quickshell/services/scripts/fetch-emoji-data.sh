#!/usr/bin/env bash
# Fetches GitHub's gemoji dataset (emoji.json), which already pairs each
# emoji with a human description, category, aliases, and search tags — no
# separate Unicode emoji-test.txt needed just for grouping/ordering.
# Reshapes into the flat array Emoji.qml expects:
#   [{ "char": "😀", "name": "grinning face", "category": "Smileys & Emotion",
#      "keywords": ["grinning", "smile", "happy"] }, ...]
#
# Run manually, or via the shell's "refetch" button (EmojiData.qml calls
# this through a Process, same as Recording/Clipboard shell out elsewhere).
# Safe to re-run any time — it always does a full re-fetch and overwrite,
# there's no incremental/diff mode.
set -euo pipefail

SOURCE_URL="https://raw.githubusercontent.com/github/gemoji/master/db/emoji.json"

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
OUTPUT_DIR="$(cd -- "$SCRIPT_DIR/../.." >/dev/null 2>&1 && pwd)/assets/data"
OUTPUT_FILE="$OUTPUT_DIR/emojis.json"

for cmd in curl jq; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "fetch-emoji-data: '$cmd' is required but not installed" >&2
        exit 1
    fi
done

mkdir -p "$OUTPUT_DIR"

tmp_file="$(mktemp)"
trap 'rm -f "$tmp_file"' EXIT

if ! curl -fsSL "$SOURCE_URL" -o "$tmp_file"; then
    echo "fetch-emoji-data: failed to download $SOURCE_URL" >&2
    exit 1
fi

# gemoji's own fields (description/aliases/tags) become name/keywords here;
# aliases and tags are merged into one keywords list since the UI just does
# a flat substring search, not alias-vs-tag-specific matching. unicode/ios
# version fields are dropped — not useful for search or display.
jq '
    map({
        char: .emoji,
        name: .description,
        category: .category,
        keywords: ((.aliases // []) + (.tags // []) | unique)
    })
    | sort_by(.category, .name)
' "$tmp_file" >"$OUTPUT_FILE"

count=$(jq 'length' "$OUTPUT_FILE")
echo "fetch-emoji-data: wrote $count emoji to $OUTPUT_FILE"
