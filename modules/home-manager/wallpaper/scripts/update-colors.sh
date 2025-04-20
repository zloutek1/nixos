#!/usr/bin/env bash
set -euo pipefail

# Help function
function show_help() {
  echo "Usage: update-colors [OPTIONS] [IMAGE_PATH]"
  echo ""
  echo "Updates color scheme based on current or specified wallpaper using matugen"
  echo ""
  echo "Options:"
  echo "  -c, --config FILE         Config file path (default: ~/.config/matugen/config.toml)"
  echo "  -m, --mode MODE           Color mode (default: dark)"
  echo "  -h, --help                Display this help message"
}

# Default values
CONFIG_FILE="$HOME/.config/matugen/config.toml"
COLOR_MODE="dark"

# Parse arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    -c|--config)
      CONFIG_FILE="$2"
      shift 2
      ;;
    -m|--mode)
      COLOR_MODE="$2"
      shift 2
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

# If no wallpaper specified, use current wallpaper
if [[ -z "${WALLPAPER:-}" ]]; then
  WALLPAPER=$(swww query | grep -o 'image: .*' | sed 's/image: //')
  
  # Check if a current wallpaper was found
  if [[ -z "$WALLPAPER" ]]; then
    echo "Error: No current wallpaper found and none specified" >&2
    exit 1
  fi
fi

# Check if the file exists
if [[ ! -f "$WALLPAPER" ]]; then
  echo "Error: Wallpaper file not found: $WALLPAPER" >&2
  exit 1
fi

# Check if config file exists
if [[ ! -f "$CONFIG_FILE" ]]; then
  echo "Warning: Config file not found: $CONFIG_FILE" >&2
  echo "Using default configuration" >&2
  
  # Use matugen without config file
  matugen image "$WALLPAPER" --mode "$COLOR_MODE"
else
  # Use matugen with config file
  matugen image "$WALLPAPER" --config "$CONFIG_FILE" --mode "$COLOR_MODE"
fi

echo "Color scheme updated based on: $WALLPAPER" >&2

if command -v "hyprshade" >/dev/null 2>&1; then
  hyprshade auto
fi