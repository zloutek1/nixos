#!/usr/bin/env bash
set -euo pipefail

# Help function
function show_help() {
  echo "Usage: pick-wallpaper [OPTIONS]"
  echo ""
  echo "Opens nsxiv to pick a wallpaper and sets it"
  echo ""
  echo "Options:"
  echo "  -d, --dir DIRECTORY       Wallpaper directory (default: \$XDG_PICTURES_DIR/wallpapers)"
  echo "  -t, --transition TYPE     Transition type (default: wipe)"
  echo "  -u, --duration SECONDS    Transition duration (default: 2)"
  echo "  -c, --config FILE         Matugen config file (default: ~/.config/matugen/config.toml)"
  echo "  -m, --mode MODE           Color mode (default: dark)"
  echo "  -n, --no-colors           Don't update color scheme"
  echo "  -h, --help                Display this help message"
}

# Default values
WALLPAPER_DIR="${XDG_PICTURES_DIR:-$HOME/Pictures}/wallpapers"
TRANSITION_TYPE="wipe"
TRANSITION_DURATION=2
CONFIG_FILE="$HOME/.config/matugen/config.toml"
COLOR_MODE="dark"
UPDATE_COLORS=true
ROFI_COMMAND="rofi -show -dmenu -theme $XDG_CONFIG_HOME/rofi/wallpaper-select.rasi"

# Parse arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    -d|--dir)
      WALLPAPER_DIR="$2"
      shift 2
      ;;
    -t|--transition)
      TRANSITION_TYPE="$2"
      shift 2
      ;;
    -u|--duration)
      TRANSITION_DURATION="$2"
      shift 2
      ;;
    -c|--config)
      CONFIG_FILE="$2"
      shift 2
      ;;
    -m|--mode)
      COLOR_MODE="$2"
      shift 2
      ;;
    -n|--no-colors)
      UPDATE_COLORS=false
      shift
      ;;
    -h|--help)
      show_help
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      show_help >&2
      exit 1
      ;;
  esac
done

menu() {
  for i in "${!WALLPAPERS[@]}"; do
    # Use icon display for compatible images
    if ! echo "${WALLPAPERS[$i]}" | grep -q -E '\.gif$'; then
      printf "%s\x00icon\x1f%s\n" "$(basename "${WALLPAPERS[$i]}")" "${WALLPAPERS[$i]}"
    else
      # Display filename for GIFs
      printf "%s\n" "$(basename "${WALLPAPERS[$i]}")"
    fi
  done
}

# Check if directory exists
if [[ ! -d "$WALLPAPER_DIR" ]]; then
  echo "Error: Wallpaper directory not found: $WALLPAPER_DIR" >&2
  exit 1
fi

# Find all wallpapers
mapfile -t WALLPAPERS < <(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" \) | sort)
if [[ ${#WALLPAPERS[@]} -eq 0 ]]; then
  echo "No wallpapers found in $WALLPAPER_DIR" >&2
  exit 1
fi

# Launch nsxiv in thumbnail mode
SELECTED_WALLPAPER="$WALLPAPER_DIR/$(menu | ${ROFI_COMMAND})"

# Set the selected wallpaper using set-wallpaper
COLORS_FLAG=""
if [[ "$UPDATE_COLORS" = false ]]; then
  COLORS_FLAG="--no-colors"
fi

set-wallpaper \
  --transition "$TRANSITION_TYPE" \
  --duration "$TRANSITION_DURATION" \
  --config "$CONFIG_FILE" \
  --mode "$COLOR_MODE" \
  $COLORS_FLAG \
  "$SELECTED_WALLPAPER"