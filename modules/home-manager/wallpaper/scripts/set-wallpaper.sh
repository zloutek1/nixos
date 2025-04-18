#!/usr/bin/env bash
set -euo pipefail

# Help function
function show_help() {
  echo "Usage: set-wallpaper [OPTIONS] <image_path>"
  echo ""
  echo "Sets the wallpaper using swww and optionally updates color scheme"
  echo ""
  echo "Options:"
  echo "  -t, --transition TYPE     Transition type (default: wipe)"
  echo "  -d, --duration SECONDS    Transition duration (default: 2)"
  echo "  -c, --config FILE         Matugen config file (default: ~/.config/matugen/config.toml)"
  echo "  -m, --mode MODE           Color mode (default: dark)"
  echo "  -n, --no-colors           Don't update color scheme"
  echo "  -h, --help                Display this help message"
}

# Default values
TRANSITION_TYPE="wipe"
TRANSITION_DURATION=2
CONFIG_FILE="$HOME/.config/matugen/config.toml"
COLOR_MODE="dark"
UPDATE_COLORS=true
WALLPAPER=""

# Parse arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    -t|--transition)
      TRANSITION_TYPE="$2"
      shift 2
      ;;
    -d|--duration)
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
      WALLPAPER="$1"
      shift
      ;;
  esac
done

# Check if a wallpaper was provided
if [[ -z "${WALLPAPER}" ]]; then
  echo "Error: No wallpaper specified" >&2
  show_help >&2
  exit 1
fi

# Check if the file exists
if [[ ! -f "$WALLPAPER" ]]; then
  echo "Error: Wallpaper file not found: $WALLPAPER" >&2
  exit 1
fi

# Set wallpaper using swww
swww img "$WALLPAPER" --transition-type "$TRANSITION_TYPE" --transition-duration "$TRANSITION_DURATION"

echo "Wallpaper set to: $WALLPAPER" >&2

# Update colors if requested
if [[ "$UPDATE_COLORS" = true ]]; then
  update-colors --config "$CONFIG_FILE" --mode "$COLOR_MODE" "$WALLPAPER"
fi