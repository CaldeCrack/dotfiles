PROFILE_DIR="$(find "$HOME/.config/zen" -maxdepth 1 -type d -name "*.Default (release)" 2>/dev/null | head -n 1)"

cp ~/.cache/matugen/userChrome.css "$PROFILE_DIR/chrome/userChrome.css"
