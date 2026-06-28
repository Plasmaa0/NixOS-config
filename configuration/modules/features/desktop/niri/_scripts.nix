{pkgs, ...}: {
  volume_up = pkgs.writeShellApplication {
    name = "volume-up";
    runtimeInputs = [pkgs.libnotify pkgs.pulseaudio];
    text = ''
      pactl set-sink-volume @DEFAULT_SINK@ +2%
      VOL=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -o '[0-9]\+%' | head -1)
      notify-send -a volume -u low -h int:value:"$VOL" "Volume" --hint=string:x-dunst-stack-tag:volume -h string:x-canonical-private-synchronous:volume_notif
    '';
  };

  volume_down = pkgs.writeShellApplication {
    name = "volume-down";
    runtimeInputs = [pkgs.libnotify pkgs.pulseaudio];
    text = ''
      pactl set-sink-volume @DEFAULT_SINK@ -2%
      VOL=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -o '[0-9]\+%' | head -1)
      notify-send -a volume -u low -h int:value:"$VOL" "Volume" --hint=string:x-dunst-stack-tag:volume -h string:x-canonical-private-synchronous:volume_notif
    '';
  };

  volume_mute = pkgs.writeShellApplication {
    name = "volume-mute";
    runtimeInputs = [pkgs.libnotify pkgs.pulseaudio];
    text = ''
      pactl set-sink-mute @DEFAULT_SINK@ toggle
      notify-send -u low "Audio" "$(pactl get-sink-mute @DEFAULT_SINK@)" -i audio-volume-muted
    '';
  };

  mic_mute = pkgs.writeShellApplication {
    name = "mic-mute";
    runtimeInputs = [pkgs.libnotify pkgs.pulseaudio];
    text = ''
      pactl set-source-mute @DEFAULT_SOURCE@ toggle
      notify-send -u low "Microphone" "$(pactl get-source-mute @DEFAULT_SOURCE@)" -i audio-volume-muted
    '';
  };

  brightness_up = pkgs.writeShellApplication {
    name = "brightness-up";
    runtimeInputs = [pkgs.libnotify pkgs.brightnessctl pkgs.gawk];
    text = ''
      brightnessctl -d amdgpu_bl1 set 2%+
      BRIGHT=$(brightnessctl -d amdgpu_bl1  | grep -o '[0-9]\+%')
      notify-send -a bright -u low -h int:value:"$BRIGHT" "Brightness" --hint=string:x-dunst-stack-tag:brightness -h string:x-canonical-private-synchronous:brightness_notif
    '';
  };

  brightness_down = pkgs.writeShellApplication {
    name = "brightness-down";
    runtimeInputs = [pkgs.libnotify pkgs.brightnessctl pkgs.gawk];
    text = ''
      brightnessctl -d amdgpu_bl1 set 2%-
      BRIGHT=$(brightnessctl -d amdgpu_bl1  | grep -o '[0-9]\+%')
      notify-send -a bright -u low -h int:value:"$BRIGHT" "Brightness" --hint=string:x-dunst-stack-tag:brightness -h string:x-canonical-private-synchronous:brightness_notif
    '';
  };

  touchpad_toggle = pkgs.writeShellApplication {
    name = "touchpad-toggle";
    runtimeInputs = [pkgs.libinput];
    text = ''
      DEV=$(libinput list-devices | grep -A 10 Touchpad | grep "kernel:" | cut -d: -f2 | xargs)
      if [ -n "$DEV" ]; then
        if libinput debug-events --device "$DEV" --show-keycodes 2>&1 | grep -q "enable"; then
          libinput disable-device "$DEV"
        else
          libinput enable-device "$DEV"
        fi
      fi
    '';
  };

  fuzzel_powermenu = pkgs.writeShellApplication {
    name = "fuzzel-powermenu";
    runtimeInputs = [pkgs.fuzzel];
    text = ''
      SELECTION="$(printf "1 - Lock\n2 - Suspend\n3 - Log out\n4 - Reboot\n5 - Reboot to UEFI\n6 - Hard reboot\n7 - Shutdown" | fuzzel --dmenu -l 7 -p "Power Menu: ")"

      case $SELECTION in
      	*"Lock")
      		${pkgs.systemd}/bin/loginctl lock-session;;
      	*"Suspend")
      		systemctl suspend;;
      	*"Log out")
      		niri msg action quit;;
      	*"Reboot")
      		systemctl reboot;;
      	*"Reboot to UEFI")
      		systemctl reboot --firmware-setup;;
      	*"Hard reboot")
      		pkexec "echo b > /proc/sysrq-trigger";;
      	*"Shutdown")
      		systemctl poweroff;;
      esac
    '';
  };
}
