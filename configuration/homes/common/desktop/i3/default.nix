{
  config,
  pkgs,
  lib,
  hidpiScalingFactor,
  ...
}: let
  c = config.lib.stylix.colors;
in {
  imports = [
    ../common
  ];
  xsession = {
    enable = true;
    windowManager.i3 = {
      enable = true;
    };
  };
  home.packages = with pkgs; [
    (writeShellApplication {
      name = "i3-mouse-to-center";
      runtimeInputs = with pkgs; [xdotool i3 jq coreutils];
      text = ''
        eval "$(xdotool getactivewindow getwindowgeometry --shell 2>/dev/null && echo FAIL=1)";
        if [ -z "$FAIL" ]; then
          cwg="$(i3-msg -t get_workspaces | jq --unbuffered -r '.[] | select(.focused == true).rect')"
          X="$(echo "$cwg" | jq '.x')"
          Y="$(echo "$cwg" | jq '.y')"
          WIDTH="$(echo "$cwg" | jq '.width')"
          HEIGHT="$(echo "$cwg" | jq '.height')"
        fi
        xdotool mousemove $((X+WIDTH/2)) $((Y+HEIGHT/2));
      '';
    })
  ];
  xsession.windowManager.i3.extraConfig = ''
    tiling_drag modifier titlebar

    # enable window icons for all windows
    for_window [all] title_window_icon on
    # enable window icons for all windows with extra horizontal padding
    for_window [all] title_window_icon padding 3px
  '';
  xsession.windowManager.i3.config = {
    modifier = "Mod4";
    colors = let
      c = config.lib.stylix.colors.withHashtag;
    in {
      background = c.base05;
      # currently focused window
      focused = {
        border = c.base03;
        background = c.base03;
        text = c.base00;
        indicator = c.base06;
        childBorder = c.base03;
      };
      # window that is focused but in other container (i.e. other monitor or split)
      focusedInactive = {
        border = c.base02;
        background = c.base02;
        text = c.base05;
        indicator = c.base00;
        childBorder = c.base02;
      };
      # not focused in any container
      unfocused = {
        border = c.base00;
        background = c.base00;
        text = c.base04;
        indicator = c.base00;
        childBorder = c.base00;
      };
      urgent = {
        border = c.base0F;
        background = c.base0F;
        text = c.base07;
        indicator = c.base08;
        childBorder = c.base0F;
      };
      placeholder = {
        border = c.base00;
        background = c.base00;
        text = c.base04;
        indicator = c.base04;
        childBorder = c.base00;
      };
    };
    fonts = {
      names = [config.stylix.fonts.serif.name];
      size = 5 * hidpiScalingFactor;
    };
    gaps = {
      smartBorders = "on";
      smartGaps = true;
      inner = builtins.ceil (5 * hidpiScalingFactor); # space between two adjacent windows (or split containers)
      outer = builtins.ceil (2 * hidpiScalingFactor); # space along the screen edges
    };
    defaultWorkspace = "workspace number 1";
    workspaceAutoBackAndForth = true;
    keybindings = let
      mod = config.xsession.windowManager.i3.config.modifier;
      send_volume_notification = ''notify-send -a volume -u low -h int:value:$(pactl get-sink-volume @DEFAULT_SINK@ | grep -o '[0-9]\+%' | head -1) Volume --hint=string:x-dunst-stack-tag:volume'';
      step = "2%";
      send_brightness_notification = ''notify-send -a bright -u low -h int:value:$(brightnessctl -d amdgpu_bl1  | grep -o '[0-9]\+%') Brightness --hint=string:x-dunst-stack-tag:brightness'';
      # move mouse to center of currently focused window (FIXME moves mouse to top left if no window in focus)
      # mouse_to_focused = ''"${pkgs.bash}/bin/sh -c 'eval `${pkgs.xdotool}/bin/xdotool getactivewindow getwindowgeometry --shell`; ${pkgs.xdotool}/bin/xdotool mousemove $((X+WIDTH/2)) $((Y+HEIGHT/2))'"'';
      send_kb_brightness_notification = ''notify-send -i keyboard -u low "Keyboard brightness" $(asusctl -k | grep "Current" | cut -c 34-) --hint=string:x-dunst-stack-tag:kbbrightness'';
      send_fan_profile_notification = ''notify-send -i sensors-fan-symbolic -u low "Fan profile" $(asusctl profile -p | grep "Active profile is" | cut -c 19-) --hint=string:x-dunst-stack-tag:fans'';
      send_aura_notification = ''notify-send -i keyboard-brightness-symbolic -u low "Aura" "Next mode"'';
      send_touchpad_notification = ''xinput | grep floating && notify-send -i touchpad-disabled-symbolic -u low "Touchpad" "Off" --hint=string:x-dunst-stack-tag:volume || notify-send -i touchpad-enabled-symbolic -u low "Touchpad" "On" --hint=string:x-dunst-stack-tag:volume'';
      mouse_to_focused = "i3-mouse-to-center";
      ws_names = map builtins.toString (lib.range 1 10);
      ws_keys = (map builtins.toString (lib.range 1 9)) ++ ["0"];
      list_of_attr_to_attr = pkgs.lib.foldl (a: b: a // b) {};
      ws_bindings = list_of_attr_to_attr (lib.zipListsWith (
          ws_name: ws_key: {
            "${mod}+${ws_key}" = "workspace number ${ws_name}; exec --no-startup-id ${mouse_to_focused}";
            "${mod}+Shift+${ws_key}" = "move container to workspace number ${ws_name}; exec --no-startup-id ${mouse_to_focused}";
          }
        )
        ws_names
        ws_keys);
    in
      # fully override default config (with lib.mkOptionDefault options that exist in default config, but not provided here will still remain defined)
      lib.mkForce (ws_bindings
        // {
          "XF86AudioRaiseVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +${step} && ${send_volume_notification}";
          "--whole-window ${mod}+Shift+button4" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +${step} && ${send_volume_notification}";
          "XF86AudioLowerVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -${step} && ${send_volume_notification}";
          "--whole-window ${mod}+Shift+button5" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -${step} && ${send_volume_notification}";
          "XF86AudioMute" = ''exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle && notify-send -u low "Audio" "$(pactl get-sink-mute @DEFAULT_SINK@)" -i audio-volume-muted --hint=string:x-dunst-stack-tag:volume'';
          "XF86AudioMicMute" = ''exec --no-startup-id pactl set-source-mute @DEFAULT_SOURCE@ toggle && notify-send -u low "Microphone" "$(pactl get-source-mute @DEFAULT_SOURCE@)" -i audio-volume-muted --hint=string:x-dunst-stack-tag:volume'';
          "${mod}+semicolon" = "move to scratchpad; exec --no-startup-id ${mouse_to_focused}";
          "${mod}+l" = "scratchpad show; exec --no-startup-id ${mouse_to_focused}";
          "XF86MonBrightnessUp" = "exec --no-startup-id brightnessctl -d amdgpu_bl1  set ${step}+ && ${send_brightness_notification} # increase screen brightness";
          "XF86MonBrightnessDown" = "exec --no-startup-id brightnessctl -d amdgpu_bl1  set ${step}- && ${send_brightness_notification} # decrease screen brightness";
          "XF86KbdBrightnessUp" = "exec --no-startup-id asusctl -n && ${send_kb_brightness_notification}"; # keyboard backlight +
          "XF86KbdBrightnessDown" = "exec --no-startup-id asusctl -p && ${send_kb_brightness_notification}"; # keyboard backlight -
          "XF86Launch1" = "exec pkill picom; exec flameshot gui"; # m4 macro key above keyboard
          "XF86Launch3" = "exec --no-startup-id asusctl aura -n && ${send_aura_notification}"; # aura button
          "XF86Launch4" = "exec --no-startup-id asusctl profile -n && ${send_fan_profile_notification}"; # fan profile
          "XF86TouchpadToggle" = let
            touchpadId = ''"$(xinput | grep Touchpad | tr '\t' '\n' | grep "id=[0-9]*" | tr '=' '\n' | tail -1)"'';
          in "exec --no-startup-id xinput | grep floating && xinput enable ${touchpadId} || xinput disable ${touchpadId} && ${send_touchpad_notification}";
          "${mod}+Return" = "exec kitty; exec --no-startup-id ${mouse_to_focused}";
          "${mod}+n" = "exec eww open --toggle nc";
          "${mod}+b" = "exec eww open --toggle bar";
          "${mod}+q" = "kill; exec --no-startup-id ${mouse_to_focused}";
          "${mod}+Shift+Return" = "exec ~/.config/rofi/launchers/type-2/launcher.sh";
          "${mod}+Shift+XF86Assistant" = "exec ~/Documents/todo/run.sh";
          "${mod}+a" = "focus left; exec --no-startup-id ${mouse_to_focused}";
          "${mod}+s" = "focus down; exec --no-startup-id ${mouse_to_focused}";
          "${mod}+w" = "focus up; exec --no-startup-id ${mouse_to_focused}";
          "${mod}+d" = "focus right; exec --no-startup-id ${mouse_to_focused}";
          "${mod}+Shift+a" = "move left; exec --no-startup-id ${mouse_to_focused}";
          "${mod}+Shift+s" = "move down; exec --no-startup-id ${mouse_to_focused}";
          "${mod}+Shift+w" = "move up; exec --no-startup-id ${mouse_to_focused}";
          "${mod}+Shift+d" = "move right; exec --no-startup-id ${mouse_to_focused}";
          "${mod}+h" = "split h";
          "${mod}+v" = "split v";
          "${mod}+f" = "fullscreen toggle";
          "${mod}+Tab" = "layout toggle tabbed split; exec --no-startup-id ${mouse_to_focused}";
          "${mod}+Shift+space" = "floating toggle; exec --no-startup-id ${mouse_to_focused}";
          "${mod}+space" = "focus mode_toggle; exec --no-startup-id ${mouse_to_focused}";
          "${mod}+p" = "focus parent; exec --no-startup-id ${mouse_to_focused}";
          "${mod}+c" = "focus child; exec --no-startup-id ${mouse_to_focused}";
          "${mod}+Shift+c" = "reload";
          "${mod}+Shift+r" = "restart";
          "${mod}+Shift+e" = "exec ~/.config/rofi/powermenu/type-2/powermenu.sh";
          "${mod}+t" = "exec ${lib.getExe pkgs.telegram-desktop}";
          "Print" = "exec pkill picom; exec flameshot gui";
          "${mod}+r" = ''mode "resize"'';
          "${mod}+e" = ''mode "launch"'';
          "${mod}+m" = ''[class="cassette"] scratchpad show; resize set height 80 ppt; resize set width 80 ppt; move position center'';
        });
    modes = {
      resize = {
        "j" = "resize shrink width 10 px or 10 ppt";
        "k" = "resize grow height 10 px or 10 ppt";
        "l" = "resize shrink height 10 px or 10 ppt";
        "semicolon" = "resize grow width 10 px or 10 ppt";
        "space" = "resize set width 50ppt";
        "w" = "resize set height 80 ppt; resize set width 80 ppt"; # "w" for wide
        "c" = "move position center";

        "Left" = "resize shrink width 10 px or 10 ppt";
        "Down" = "resize grow height 10 px or 10 ppt";
        "Up" = "resize shrink height 10 px or 10 ppt";
        "Right" = "resize grow width 10 px or 10 ppt";

        "Return" = ''mode "default"'';
        "Escape" = ''mode "default"'';
        "${config.xsession.windowManager.i3.config.modifier}+r" = ''mode "default"'';
      };
      launch = {
        "t" = "exec ${lib.getExe pkgs.telegram-desktop}";
        "q" = "exec qutebrowser";
        "m" = "exec yandex-music";
        "e" = "exec dolphin";
        "F9" = "exec autorandr --batch --change --default default";

        "Return" = ''mode "default"'';
        "Escape" = ''mode "default"'';
        "${config.xsession.windowManager.i3.config.modifier}+e" = ''mode "default"'';
      };
    };
    floating.modifier = config.xsession.windowManager.i3.config.modifier;
    bars = [];
    # add notification = false; to all entries of this list
    startup = map (set: set // {notification = false;}) [
      {
        command = "nm-applet --indicator";
      }
      {
        command = "blueman-applet";
      }
      {
        command = "xhost +";
      }
      {
        command = "asusctl slash -l 128 -m Flux -B true -S true -s false -b false -w true";
        always = true;
      }
      {
        command = let
          # all of this below is because how rgb keyboard lights work.
          # without this trick colors look generic white with light tint of some color; but with this i remove "white" component to saturate final result.
          # EXAMPLE:
          # first step:
          #          50 150 200 -> 0 100 150
          #          white-ish  -> blue-ish
          # second step:
          # ampamplification-factor = 255.0 / 150; # 1.7
          #         0 100 150 -> 0 170 255
          #         blue-ish  -> juicy blue-ish
          #
          # REAL EXAMPLE WITH HEX: 202746 -> 002EFF
          # 202746: dark pale white without even light blue touch
          # 002EFF: nice saturated blue
          r = builtins.fromJSON c.base03-rgb-r;
          g = builtins.fromJSON c.base03-rgb-g;
          b = builtins.fromJSON c.base03-rgb-b;
          min-channel = lib.min (lib.min r g) b;
          saturated-r = r - min-channel;
          saturated-g = g - min-channel;
          saturated-b = b - min-channel;
          max-channel = lib.max (lib.max (lib.max saturated-r saturated-g) saturated-b) 1;
          amplification-factor = 255.0 / max-channel;
          amplified-r = saturated-r * amplification-factor;
          amplified-g = saturated-g * amplification-factor;
          amplified-b = saturated-b * amplification-factor;
          # converts single digit numbers like "0" to two-digit "00" for valid hex format
          padToTwo = s:
            if builtins.stringLength s == 1
            then "0${s}"
            else s;
          hex-r = padToTwo (lib.toHexString (builtins.floor amplified-r));
          hex-g = padToTwo (lib.toHexString (builtins.floor amplified-g));
          hex-b = padToTwo (lib.toHexString (builtins.floor amplified-b));
          result-color = hex-r + hex-g + hex-b;
        in "asusctl aura static -c ${result-color} && asusctl -k low";
        always = true;
      }
      {
        command = "feh --no-fehbg --bg-fill ${config.stylix.image}";
        always = true;
      }
    ];
    window = {
      border = builtins.ceil (2 * hidpiScalingFactor);
      commands = [
        {
          command = "move to scratchpad";
          criteria = {class = "Cider";};
        }
        {
          command = "move to scratchpad";
          criteria = {class = "cassette";};
        }
        {
          command = "floating enable border pixel 3";
          criteria = {class = "Yad";};
        }
        {
          command = "floating enable border pixel 3";
          criteria = {class = "copyq";};
        }
        # todo rofi popup helix+zathura preview
        {
          command = "floating enable";
          criteria = {class = "TODO";};
        }
        {
          command = "resize set width 40ppt";
          criteria = {class = "TODO";};
        }
        {
          command = "resize set height 80ppt";
          criteria = {class = "TODO";};
        }
        {
          command = "move position center";
          criteria = {class = "TODO";};
        }
        {
          command = "floating enable";
          criteria = {title = "/home/${config.home.username}/Documents/todo/todo.pdf";};
        }
        {
          command = "resize set width 40ppt";
          criteria = {title = "/home/${config.home.username}/Documents/todo/todo.pdf";};
        }
        {
          command = "resize set height 90ppt";
          criteria = {title = "/home/${config.home.username}/Documents/todo/todo.pdf";};
        }
        {
          command = "move position center";
          criteria = {title = "/home/${config.home.username}/Documents/todo/todo.pdf";};
        }
        # Qutebrowser edit text in helix popup
        {
          command = "floating enable";
          criteria = {class = "QuteTextEdit";};
        }
        {
          command = "resize set width 50ppt";
          criteria = {class = "QuteTextEdit";};
        }
        {
          command = "resize set height 45ppt";
          criteria = {class = "QuteTextEdit";};
        }
        {
          command = "move position center";
          criteria = {class = "QuteTextEdit";};
        }
        # other
        {
          command = "floating enable border pixel 3";
          criteria = {class = "feh";};
        }
        {
          command = "border pixel 4";
          criteria = {class = "kitty";};
        }
        {
          command = "floating enable border pixel 3";
          criteria = {class = "SimpleScreenRecorder";};
        }
      ];
    };
  };
}
