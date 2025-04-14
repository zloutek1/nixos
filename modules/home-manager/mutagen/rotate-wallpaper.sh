#!/usr/bin/env bash
set -euo pipefail

WALLPAPER_DIR="${XDG_PICTURES_DIR:-$HOME/Pictures}/wallpapers"
mapfile -t WALLPAPERS < <(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" \))
if [[ ${#WALLPAPERS[@]} -eq 0 ]]; then
    echo "No wallpapers found in $WALLPAPER_DIR"
    exit 1
fi

CURRENT_WALLPAPER=$(swww query | grep -o 'image: .*' | sed 's/image: //')

CURRENT_INDEX=-1
for i in "${!WALLPAPERS[@]}"; do
    if [[ "${WALLPAPERS[$i]}" == "$CURRENT_WALLPAPER" ]]; then
        CURRENT_INDEX=$i
        break
    fi
done

if [[ $CURRENT_INDEX -eq -1 || $CURRENT_INDEX -eq $((${#WALLPAPERS[@]} - 1)) ]]; then
    NEXT_INDEX=0
else
    NEXT_INDEX=$((CURRENT_INDEX + 1))
fi

NEXT_WALLPAPER="${WALLPAPERS[$NEXT_INDEX]}"
swww img "$NEXT_WALLPAPER" --transition-type "wipe" --transition-duration 2

echo "Wallpaper changed to: $NEXT_WALLPAPER"