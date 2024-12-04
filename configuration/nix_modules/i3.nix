{ config, pkgs, ... }:

let
  c = config.lib.stylix.colors;
in 
{
  # xsession.windowManager.i3 = {
  #   enable = true;
  # };
  home.file."${config.xdg.configHome}/i3/config".text = ''
  # This file has been auto-generated by i3-config-wizard(1).
# It will not be overwritten, so edit it as you like.
#
# Should you change your keyboard layout some time, delete
# this file and re-run i3-config-wizard(1).
#

# i3 config file (v4)
#
# Please see https://i3wm.org/docs/userguide.html for a complete reference!

default_border pixel 2
smart_gaps on
gaps inner 10
gaps outer 5
smart_borders on

# class                   border       bground      text         indicator      child_border

client.focused          #${c.base0B} #${c.base0B} #${c.base01} #${c.base0C}   #${c.base0B}
client.unfocused        #${c.base05} #${c.base01} #${c.base06} #${c.base06}   #${c.base05}
client.focused_inactive #${c.base0C} #${c.base0C} #${c.base01} #${c.base0A}   #${c.base0C}
client.urgent           #${c.base0F} #${c.base0F} #${c.base05} #${c.base0F}   #${c.base0F}
client.placeholder      #${c.base00} #${c.base00} #${c.base05} #${c.base00}   #${c.base00}

client.background       #${c.base05}

set $mod Mod4
exec --no-startup-id xrandr --dpi 192
exec --no-startup-id xhost +
exec --no-startup-id ~/.screenlayout/my.sh
# exec_always --no-startup-id picom --config ~/.config/picom/picom.conf -b &

# Font for window titles. Will also be used by the bar unless a different font
# is used in the bar {} block below.
font pango: ${config.stylix.fonts.serif.name} 10

# Start XDG autostart .desktop files using dex. See also
# https://wiki.archlinux.org/index.php/XDG_Autostart
# exec --no-startup-id dex --autostart --environment i3
# exec_always --no-startup-id exec i3-workspace-names-daemon -n -d " | "

# xss-lock grabs a logind suspend inhibit lock and will use i3lock to lock the
# screen before suspend. Use loginctl lock-session to lock your screen.
# exec --no-startup-id xss-lock --transfer-sleep-lock -- i3lock --nofork

exec --no-startup-id nm-applet --indicator

exec --no-startup-id copyq

# Use pactl to adjust volume in PulseAudio.
set $send_volume_notification notify-send -a volume -u low -h int:value:$(pactl get-sink-volume @DEFAULT_SINK@ | grep -o '[0-9]\+%' | head -1) Volume --hint=string:x-dunst-stack-tag:volume
set $increase_volume 
set $refresh_i3status killall -SIGUSR1 i3status 
set $step 5%
bindsym XF86AudioRaiseVolume exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +$step && $send_volume_notification
bindsym --whole-window $mod+Shift+button4 exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +$step && $send_volume_notification

bindsym XF86AudioLowerVolume exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -$step && $send_volume_notification
bindsym --whole-window $mod+Shift+button5 exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -$step && $send_volume_notification

bindsym XF86AudioMute exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle && notify-send -u low $(pactl get-sink-mute @DEFAULT_SINK@) -i audio-volume-muted --hint=string:x-dunst-stack-tag:volume
bindsym XF86AudioMicMute exec --no-startup-id pactl set-source-mute @DEFAULT_SOURCE@ toggle && notify-send -u low $(pactl get-source-mute @DEFAULT_SOURCE@) -i audio-volume-muted --hint=string:x-dunst-stack-tag:volume

for_window [class="Cider"] move to scratchpad
bindsym $mod+m [class="Cider"] scratchpad show; resize set height 80 ppt; resize set width 80 ppt; move position center

bindsym $mod+semicolon move to scratchpad
bindsym $mod+l scratchpad show
# exec --no-startup-id cider

set $send_brightness_notification notify-send -a bright -u low -h int:value:$(brightnessctl | grep -o '[0-9]\+%') -i preferences-system-brightness-lock --hint=string:x-dunst-stack-tag:brightness Brightness
bindsym XF86MonBrightnessUp exec --no-startup-id brightnessctl set 5%+ && $send_brightness_notification # increase screen brightness
bindsym XF86MonBrightnessDown exec --no-startup-id brightnessctl set 5%- && $send_brightness_notification # decrease screen brightness

# Use Mouse+$mod to drag floating windows to their wanted position
floating_modifier $mod

# move tiling windows via drag & drop by left-clicking into the title bar,
# or left-clicking anywhere into the window while holding the floating modifier.
tiling_drag modifier titlebar

# start a terminal
bindsym $mod+Return exec wezterm

# kill focused window
bindsym $mod+q kill

bindsym $mod+Shift+Return exec ~/.config/rofi/launchers/type-2/launcher.sh

# change focus
bindsym $mod+a focus left
bindsym $mod+s focus down
bindsym $mod+w focus up
bindsym $mod+d focus right

# alternatively, you can use the cursor keys:
# bindsym $mod+Left focus left
# bindsym $mod+Down focus down
# bindsym $mod+Up focus up
# bindsym $mod+Right focus right

# move focused window
bindsym $mod+Shift+a move left
bindsym $mod+Shift+s move down
bindsym $mod+Shift+w move up
bindsym $mod+Shift+d move right

# alternatively, you can use the cursor keys:
# bindsym $mod+Shift+Left move left
# bindsym $mod+Shift+Down move down
# bindsym $mod+Shift+Up move up
# bindsym $mod+Shift+Right move right

# split in horizontal orientation
bindsym $mod+h split h

# split in vertical orientation
bindsym $mod+v split v

# enter fullscreen mode for the focused container
bindsym $mod+f fullscreen toggle

# change container layout (stacked, tabbed, toggle split)
# bindsym $mod+s layout stacking
# bindsym $mod+w layout tabbed
# bindsym $mod+e layout toggle split
bindsym $mod+Tab       layout toggle tabbed split

# toggle tiling / floating
bindsym $mod+Shift+space floating toggle

# change focus between tiling / floating windows
bindsym $mod+space focus mode_toggle

# focus the parent container
bindsym $mod+p focus parent

# focus the child container
bindsym $mod+c focus child

# Define names for default workspaces for which we configure key bindings later on.
# We use variables to avoid repeating the names in multiple places.
set $ws1 "1"
set $ws2 "2"
set $ws3 "3"
set $ws4 "4"
set $ws5 "5"
set $ws6 "6"
set $ws7 "7"
set $ws8 "8"
set $ws9 "9"
set $ws10 "10"

# switch to workspace
bindsym $mod+1 workspace number $ws1
bindsym $mod+2 workspace number $ws2
bindsym $mod+3 workspace number $ws3
bindsym $mod+4 workspace number $ws4
bindsym $mod+5 workspace number $ws5
bindsym $mod+6 workspace number $ws6
bindsym $mod+7 workspace number $ws7
bindsym $mod+8 workspace number $ws8
bindsym $mod+9 workspace number $ws9
bindsym $mod+0 workspace number $ws10

# move focused container to workspace
bindsym $mod+Shift+1 move container to workspace number $ws1
bindsym $mod+Shift+2 move container to workspace number $ws2
bindsym $mod+Shift+3 move container to workspace number $ws3
bindsym $mod+Shift+4 move container to workspace number $ws4
bindsym $mod+Shift+5 move container to workspace number $ws5
bindsym $mod+Shift+6 move container to workspace number $ws6
bindsym $mod+Shift+7 move container to workspace number $ws7
bindsym $mod+Shift+8 move container to workspace number $ws8
bindsym $mod+Shift+9 move container to workspace number $ws9
bindsym $mod+Shift+0 move container to workspace number $ws10

# reload the configuration file
bindsym $mod+Shift+c reload
# restart i3 inplace (preserves your layout/session, can be used to upgrade i3)
bindsym $mod+Shift+r restart
# exit i3 (logs you out of your X session)
# bindsym $mod+Shift+e exec "i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -B 'Yes, exit i3' 'i3-msg exit'"
bindsym $mod+Shift+e exec ~/.config/rofi/powermenu/type-2/powermenu.sh
bindsym $mod+t exec telegram-desktop
# bindsym $mod+t i3-msg 'workspace $ws10'
bindsym Print exec flameshot gui

# resize window (you can also use the mouse for that)
mode "resize" {
    bindsym j resize shrink width 10 px or 10 ppt
    bindsym k resize grow height 10 px or 10 ppt
    bindsym l resize shrink height 10 px or 10 ppt
    bindsym semicolon resize grow width 10 px or 10 ppt
    bindsym space resize set width 50ppt

    bindsym Left resize shrink width 10 px or 10 ppt
    bindsym Down resize grow height 10 px or 10 ppt
    bindsym Up resize shrink height 10 px or 10 ppt
    bindsym Right resize grow width 10 px or 10 ppt

    bindsym Return mode "default"
    bindsym Escape mode "default"
    bindsym $mod+r mode "default"
}

bindsym $mod+r mode "resize"

# exec_always --no-startup-id pkill polybar || polybar
exec_always --no-startup-id eww open --toggle bar
exec --no-startup-id $HOME/.config/i3/set_lang.sh
exec_always --no-startup-id feh --bg-fill ${config.stylix.image}

exec_always --no-startup-id killall flameshot || flameshot
# exec_always --no-startup-id killall dunst || dunst -config ~/.config/dunst/dunstrc

for_window [class="Yad"] floating enable border pixel 1
  '';
}
