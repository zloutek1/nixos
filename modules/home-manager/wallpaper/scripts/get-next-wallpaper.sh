#!/usr/bin/env bash
set -euo pipefail

# Help function
function show_help() {
  echo "Usage: next-wallpaper [OPTIONS]"
  echo ""
  echo "Finds the next wallpaper in the directory and prints its path"
  echo ""
  echo "Options:"
  echo "  -d, --dir DIRECTORY       Wallpaper directory (default: \$XDG_PICTURES_DIR/wallpapers)"
  echo "  -h, --help                Display this help message"
}

# Default values
WALLPAPER_DIR="${XDG_PICTURES_DIR:-$HOME/Pictures}/wallpapers"

# Parse arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    -d|--dir)
      WALLPAPER_DIR="$2"
      shift 2
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

# Get current wallpaper
CURRENT_WALLPAPER=$(swww query | grep -o 'image: .*' | sed 's/image: //')

# Find current index
CURRENT_INDEX=-1
for i in "${!WALLPAPERS[@]}"; do
  if [[ "${WALLPAPERS[$i]}" == "$CURRENT_WALLPAPER" ]]; then
    CURRENT_INDEX=$i
    break
  fi
done

# Determine next wallpaper
if [[ $CURRENT_INDEX -eq -1 || $CURRENT_INDEX -eq $((${#WALLPAPERS[@]} - 1)) ]]; then
  NEXT_INDEX=0
else
  NEXT_INDEX=$((CURRENT_INDEX + 1))
fi

NEXT_WALLPAPER="${WALLPAPERS[$NEXT_INDEX]}"

# Output the next wallpaper path (to be captured by calling scripts)
echo "$NEXT_WALLPAPER"