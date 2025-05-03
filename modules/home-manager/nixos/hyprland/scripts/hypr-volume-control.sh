# Get current volume level (removing the % sign)
VOLUME=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2*100}')
VOLUME=''${VOLUME%.*}  # Remove decimal part

# Define step size based on current volume
if [ "$VOLUME" -lt 10 ]; then
    STEP=1
else
    STEP=5
fi

# Process based on argument
case "$1" in
    up)
        wpctl set-volume @DEFAULT_AUDIO_SINK@ ${STEP}%+
        ;;
    down)
        wpctl set-volume @DEFAULT_AUDIO_SINK@ ${STEP}%-
        ;;
    toggle)
        wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
        ;;
    *)
        echo "Usage: $0 {up|down|toggle}"
        exit 1
        ;;
esac

exit 0