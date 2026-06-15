#!/bin/sh

envFile=~/.config/polybar/polybar-redshift/env.sh
changeValue=300

changeMode() {
  sed -i "s/REDSHIFT=$1/REDSHIFT=$2/g" $envFile 
  REDSHIFT=$2
  echo $REDSHIFT
}

changeTemp() {
  if [ "$REDSHIFT" = on ];
  then
    if [ "$2" -gt 1000 ] && [ "$2" -lt 25000 ]
    then
      sed -i "s/REDSHIFT_TEMP=$1/REDSHIFT_TEMP=$2/g" $envFile 
      redshift -c ~/.config/redshift.conf -P -O $((REDSHIFT_TEMP+changeValue))
    fi
  fi
}

case $1 in 
  toggle) 
    if [ "$REDSHIFT" = on ];
    then
      changeMode "$REDSHIFT" off
      redshift -c ~/.config/redshift.conf -x
    else
      changeMode "$REDSHIFT" on
      redshift -c ~/.config/redshift.conf -O "$REDSHIFT_TEMP"
    fi
    ;;
  increase)
    changeTemp $((REDSHIFT_TEMP)) $((REDSHIFT_TEMP+changeValue))
    ;;
  decrease)
    changeTemp $((REDSHIFT_TEMP)) $((REDSHIFT_TEMP-changeValue));
    ;;
  temperature)
    case $REDSHIFT in
      on)
        printf "%dK" "$REDSHIFT_TEMP"
        ;;
      off)
        printf "off"
        ;;
    esac
    ;;
esac
