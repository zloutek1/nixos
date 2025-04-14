 #!/usr/bin/env bash
set -euo pipefail

CURRENT_WALLPAPER=$(swww query | grep -o 'image: .*' | sed 's/image: //')

matugen image "$CURRENT_WALLPAPER" \
    --config ~/.config/matugen/config.toml \
    --mode 'dark'