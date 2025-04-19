#!/usr/bin/env bash
set -euo pipefail

# Function to display help message
function show_help() {
  cat << EOF
Usage: wallchange [next|previous|random] [OPTIONS]

Manages wallpapers - finds the next/previous/random wallpaper, sets it, and optionally updates color schemes.

Required Argument (choose one):
  next                      Go to the next wallpaper.
  previous                  Go to the previous wallpaper.
  random                    Choose a random wallpaper.

Options:
  --wallpaper-directory DIRECTORY  Wallpaper directory (default: \$XDG_PICTURES_DIR/wallpapers)
  --swww-transition TYPE           Transition type for swww (default: wipe)
  --swww-duration SECONDS          Transition duration for swww (default: 2)
  --matugen-config FILE            Matugen config file (default: ~/.config/matugen/config.toml)
  --matugen-mode MODE              Color mode for matugen (default: dark)
  --no-matugen-colors              Don't update color scheme via matugen
  --output-only                    Only output the path of the wallpaper without setting it
  --help                           Display this help message
EOF
}

# Function to find all valid wallpaper files
function find_wallpapers() {
  local wallpaper_dir="$1"
  find "$wallpaper_dir" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" \) | sort
}

# Function to get the current wallpaper
function get_current_wallpaper() {
  swww query | grep -o 'image: .*' | sed 's/image: //'
}

# Function to select the next wallpaper based on the action
function select_wallpaper() {
  local action="$1"
  local current_wallpaper="$2"
  local -a wallpapers=("${@:3}")
  
  local wallpaper_count=${#wallpapers[@]}
  
  if [[ $wallpaper_count -eq 0 ]]; then
    echo "No wallpapers found" >&2
    exit 1
  fi
  
  if [[ "$action" == "random" ]]; then
    # Select random wallpaper
    local random_index=$((RANDOM % wallpaper_count))
    echo "${wallpapers[$random_index]}"
    return
  fi
  
  # Find current index
  local current_index=-1
  for i in "${!wallpapers[@]}"; do
    if [[ "${wallpapers[$i]}" == "$current_wallpaper" ]]; then
      current_index=$i
      break
    fi
  done
  
  # Determine next/previous wallpaper
  local next_index
  if [[ "$action" == "next" ]]; then
    if [[ $current_index -eq -1 || $current_index -eq $((wallpaper_count - 1)) ]]; then
      next_index=0
    else
      next_index=$((current_index + 1))
    fi
  else  # previous
    if [[ $current_index -eq -1 || $current_index -eq 0 ]]; then
      next_index=$((wallpaper_count - 1))
    else
      next_index=$((current_index - 1))
    fi
  fi
  
  echo "${wallpapers[$next_index]}"
}

# Main function
function main() {
  # Default values
  local wallpaper_dir="${XDG_PICTURES_DIR:-$HOME/Pictures}/wallpapers"
  local transition_type="wipe"
  local transition_duration=2
  local config_file="$HOME/.config/matugen/config.toml"
  local color_mode="dark"
  local update_colors="true"
  local output_only="false"
  local action="" # To store the required action (next, previous, or random)
  
  # Parse required argument first
  if [[ $# -eq 0 ]]; then
    echo "Error: Missing required argument (next, previous, or random)." >&2
    show_help
    exit 1
  fi
  
  case "$1" in
    next|previous|random)
      action="$1"
      shift # Consume the required argument
      ;;
    --help)
      show_help
      exit 0
      ;;
    *)
      echo "Error: Invalid required argument: $1" >&2
      show_help
      exit 1
      ;;
  esac
  
  # Parse optional arguments
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --wallpaper-directory)
        if [[ $# -lt 2 ]]; then
          echo "Error: --wallpaper-directory requires a directory path." >&2
          exit 1
        fi
        wallpaper_dir="$2"
        shift 2
        ;;
      --swww-transition)
        if [[ $# -lt 2 ]]; then
          echo "Error: --swww-transition requires a transition type." >&2
          exit 1
        fi
        transition_type="$2"
        shift 2
        ;;
      --swww-duration)
        if [[ $# -lt 2 ]]; then
          echo "Error: --swww-duration requires a duration in seconds." >&2
          exit 1
        fi
        transition_duration="$2"
        shift 2
        ;;
      --matugen-config)
        if [[ $# -lt 2 ]]; then
          echo "Error: --matugen-config requires a file path." >&2
          exit 1
        fi
        config_file="$2"
        shift 2
        ;;
      --matugen-mode)
        if [[ $# -lt 2 ]]; then
          echo "Error: --matugen-mode requires a mode." >&2
          exit 1
        fi
        color_mode="$2"
        shift 2
        ;;
      --no-matugen-colors)
        update_colors="false"
        shift
        ;;
      --output-only)
        output_only="true"
        shift
        ;;
      --help) # Handle --help again in case it's after the required arg
        show_help
        exit 0
        ;;
      *)
        echo "Error: Unknown option: $1" >&2
        show_help
        exit 1
        ;;
    esac
  done
  
  # Check if directory exists
  if [[ ! -d "$wallpaper_dir" ]]; then
    echo "Error: Wallpaper directory not found: $wallpaper_dir" >&2
    exit 1
  fi
  
  # Find all wallpapers
  mapfile -t wallpapers < <(find_wallpapers "$wallpaper_dir")
  if [[ ${#wallpapers[@]} -eq 0 ]]; then
    echo "No wallpapers found in $wallpaper_dir" >&2
    exit 1
  fi
  
  # Get current wallpaper
  local current_wallpaper
  current_wallpaper=$(get_current_wallpaper)
  
  # Choose the next wallpaper based on action
  local selected_wallpaper
  selected_wallpaper=$(select_wallpaper "$action" "$current_wallpaper" "${wallpapers[@]}")
  
  # If output-only mode is requested, just print the wallpaper path and exit
  if [[ "$output_only" == "true" ]]; then
    echo "$selected_wallpaper"
    exit 0
  fi
  
  # Set the wallpaper
  set-wallpaper \
    --transition "$transition_type" \
    --duration "$transition_duration" \
    --config "$config_file" \
    --mode "$color_mode" \
    "$( [[ "$update_colors" = false ]] && echo "--no-colors" )" \
    "$selected_wallpaper"
}

# Execute main function with all arguments
main "$@"