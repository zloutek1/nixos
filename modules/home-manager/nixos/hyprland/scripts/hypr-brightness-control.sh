# Get current brightness percentage
BRIGHTNESS=$(brightnessctl get)
MAX_BRIGHTNESS=$(brightnessctl max)
BRIGHTNESS_PCT=$((BRIGHTNESS * 100 / MAX_BRIGHTNESS))

# Define step size based on current brightness
if [ "$BRIGHTNESS_PCT" -lt 10 ]; then
    STEP=1
else
    STEP=5
fi

# Process based on argument
case "$1" in
    up)
        brightnessctl set +${STEP}%
        ;;
    down)
        brightnessctl set ${STEP}%-
        ;;
    *)
        echo "Usage: $0 {up|down}"
        exit 1
        ;;
esac

exit 0