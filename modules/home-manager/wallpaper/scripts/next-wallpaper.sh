#!/usr/bin/env bash
set -euo pipefail

# Help function
function show_help() {
  echo "Usage: next-wallpaper [OPTIONS]"
  echo ""
  echo "Manages wallpapers - finds the next/previous wallpaper, sets it, and optionally updates color schemes"
  echo ""
  echo "Options:"
  echo "  -d, --dir DIRECTORY       Wallpaper directory (default: \$XDG_PICTURES_DIR/wallpapers)"
  echo "  -t, --transition TYPE     Transition type (default: wipe)"
  echo "  -u, --duration SECONDS    Transition duration (default: 2)"
  echo "  -c, --config FILE         Matugen config file (default: ~/.config/matugen/config.toml)"
  echo "  -m, --mode MODE           Color mode (default: dark)"
  echo "  -n, --no-colors           Don't update color scheme"
  echo "  -o, --output-only         Only output the path of the wallpaper without setting it"
  echo "  -p, --previous            Go to previous wallpaper instead of next"
  echo "  -r, --random              Choose a random wallpaper"
  echo "  -h, --help                Display this help message"
}

# Default values
WALLPAPER_DIR="${XDG_PICTURES_DIR:-$HOME/Pictures}/wallpapers"
TRANSITION_TYPE="wipe"
TRANSITION_DURATION=2
CONFIG_FILE="$HOME/.config/matugen/config.toml"
COLOR_MODE="dark"
UPDATE_COLORS=true
OUTPUT_ONLY=false
DIRECTION="next"
RANDOM_SELECT=false

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
    -o|--output-only)
      OUTPUT_ONLY=true
      shift
      ;;
    -p|--previous)
      DIRECTION="previous"
      shift
      ;;
    -r|--random)
      RANDOM_SELECT=true
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

# Choose the next wallpaper based on direction or random
if [[ "$RANDOM_SELECT" = true ]]; then
  # Select random wallpaper
  RANDOM_INDEX=$((RANDOM % ${#WALLPAPERS[@]}))
  SELECTED_WALLPAPER="${WALLPAPERS[$RANDOM_INDEX]}"
else
  # Find current index
  CURRENT_INDEX=-1
  for i in "${!WALLPAPERS[@]}"; do
    if [[ "${WALLPAPERS[$i]}" == "$CURRENT_WALLPAPER" ]]; then
      CURRENT_INDEX=$i
      break
    fi
  done

  # Determine next/previous wallpaper
  if [[ "$DIRECTION" == "next" ]]; then
    if [[ $CURRENT_INDEX -eq -1 || $CURRENT_INDEX -eq $((${#WALLPAPERS[@]} - 1)) ]]; then
      NEXT_INDEX=0
    else
      NEXT_INDEX=$((CURRENT_INDEX + 1))
    fi
  else  # previous
    if [[ $CURRENT_INDEX -eq -1 || $CURRENT_INDEX -eq 0 ]]; then
      NEXT_INDEX=$((${#WALLPAPERS[@]} - 1))
    else
      NEXT_INDEX=$((CURRENT_INDEX - 1))
    fi
  fi
  SELECTED_WALLPAPER="${WALLPAPERS[$NEXT_INDEX]}"
fi

# If output-only mode is requested, just print the wallpaper path and exit
if [[ "$OUTPUT_ONLY" = true ]]; then
  echo "$SELECTED_WALLPAPER"
  exit 0
fi

# Set the wallpaper
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