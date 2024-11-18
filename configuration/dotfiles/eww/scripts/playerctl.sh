# Format of the information displayed
# Eg. {{ artist }} - {{ album }} - {{ title }}
FORMAT="{{ title }} - {{ artist }}"

step=1%
case "$1" in
    --title) FORMAT="{{ title }}" ;;
    --artist) FORMAT="{{ artist }}" ;;
    --status) FORMAT="{{ status }}" ;;
    --cover) playerctl metadata -p playerctld | grep 'artUrl' | cut -c 45- && exit;;
    --play-pause) playerctl play-pause -p playerctld && exit;;
    --previous) playerctl previous -p playerctld && exit;;
    --next) playerctl next -p playerctld && exit;;
    --volume-up) pactl set-sink-volume @DEFAULT_SINK@ +$step && exit;;
    --volume-down) pactl set-sink-volume @DEFAULT_SINK@ -$step && exit;;
esac

PLAYER="playerctld"

PLAYERCTL_STATUS=$(playerctl --player=$PLAYER status 2>/dev/null)
EXIT_CODE=$?

if [ $EXIT_CODE -eq 0 ]; then
    STATUS=$PLAYERCTL_STATUS
else
    STATUS="No music"
fi

if [ "$1" == "--status" ]; then
    echo "$STATUS"
else
    if [ "$STATUS" = "Stopped" ]; then
        echo "No music is playing"
    elif [ "$STATUS" = "Paused"  ]; then
        playerctl --player=$PLAYER metadata --format "$FORMAT"
    elif [ "$STATUS" = "No music"  ]; then
        echo "$STATUS"
    else
        playerctl --player=$PLAYER metadata --format "$FORMAT"
    fi
fi

