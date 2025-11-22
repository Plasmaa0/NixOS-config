dunstify -a github -i github "NixOS" "Hello, GitHub!"

i3-msg workspace 3
mpc play
sleep 1
dunstctl set-paused true
flameshot full --path new_screens/
mpc pause

i3-msg workspace 5
flameshot full -d 300 --path wall_screens/

i3-msg workspace 6
~/.config/rofi/launchers/type-2/launcher.sh &
flameshot full -d 300 --path launcher_screens/
pkill rofi

i3-msg workspace 7
~/.config/rofi/powermenu/type-2/powermenu.sh &
flameshot full -d 300 --path powermenu_screens/
pkill rofi

i3-msg workspace 8
flameshot full -d 300 --path code_screens/

i3-msg workspace 4
dunstctl set-paused false
