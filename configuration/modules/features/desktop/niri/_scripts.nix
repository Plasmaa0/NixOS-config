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

  kb_brightness_up = pkgs.writeShellApplication {
    name = "kb-brightness-up";
    runtimeInputs = with pkgs; [asusctl libnotify];
    text = ''
      asusctl leds next
      CURRENT=$(asusctl leds get | grep "Current" | cut -c 34-)
      notify-send -u low -i keyboard "Keyboard brightness" "$CURRENT" --hint=string:x-dunst-stack-tag:kb_bright -h string:x-canonical-private-synchronous:kb_bright_notif
    '';
  };

  kb_brightness_down = pkgs.writeShellApplication {
    name = "kb-brightness-down";
    runtimeInputs = with pkgs; [asusctl libnotify];
    text = ''
      asusctl leds prev
      CURRENT=$(asusctl leds get | grep "Current" | cut -c 34-)
      notify-send -u low -i keyboard "Keyboard brightness" "$CURRENT" --hint=string:x-dunst-stack-tag:kb_bright -h string:x-canonical-private-synchronous:kb_bright_notif
    '';
  };

  fan_profile_next = pkgs.writeShellApplication {
    name = "fan-profile-next";
    runtimeInputs = with pkgs; [asusctl libnotify];
    text = ''
      asusctl profile next
      PROFILE=$(asusctl profile get | grep "Active profile: " | cut -c 17-)
      notify-send -u low -i sensors-fan-symbolic "Fan profile" "$PROFILE" --hint=string:x-dunst-stack-tag:fan_profile -h string:x-canonical-private-synchronous:fan_profile_notif
    '';
  };

  aura_next = pkgs.writeShellApplication {
    name = "aura-next";
    runtimeInputs = with pkgs; [asusctl libnotify];
    text = ''
      asusctl aura effect --next-mode
      notify-send -u low -i keyboard-brightness-symbolic "Aura" "Next mode" --hint=string:x-dunst-stack-tag:auro_mode -h string:x-canonical-private-synchronous:auro_mode_notif
    '';
  };

  fuzzel_powermenu = pkgs.writeShellApplication {
    name = "fuzzel-powermenu";
    runtimeInputs = [pkgs.fuzzel];
    text = ''
      SELECTION="$(printf "1 - Lock\n2 - Suspend\n3 - Log out\n4 - Reboot\n5 - Reboot to UEFI\n6 - Shutdown" | fuzzel --dmenu -l 6 -p "Power Menu: ")"

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
      	*"Shutdown")
      		systemctl poweroff;;
      esac
    '';
  };
}
