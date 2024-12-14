while [ true ]
do 
    COMMAND=$(xset -q | grep LED | awk '{ print $10 }')
    case "$COMMAND" in
    "00000000") LAYOUT="en" ;;
    "00001000") LAYOUT="ru" ;;
    esac

    if [[ $LAYOUT == "en" ]]; then
    echo en
    # `eww -c ~/.config/eww update en_reveal=true ru_reveal=false`
    elif [[ $LAYOUT == "ru" ]]; then
    echo ru
    # `eww -c ~/.config/eww update en_reveal=false ru_reveal=true`
    fi
  sleep 0.2
done