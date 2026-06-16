{...}: {
  flake.homeModules.desktop-window-manager-x11-i3 = {
    config,
    pkgs,
    lib,
    hidpiScalingFactor,
    ...
  }: let
    inherit (builtins) ceil floor fromJSON;
    inherit (lib) toHexString stringLength min max zipListsWith foldl;
    inherit (config.lib.stylix) colors;

    c = colors;
    mod = config.xsession.windowManager.i3.config.modifier;

    send_volume_notification = ''notify-send -a volume -u low -h int:value:$(pactl get-sink-volume @DEFAULT_SINK@ | grep -o '[0-9]\+%' | head -1) Volume --hint=string:x-dunst-stack-tag:volume'';
    step = "2%";
    send_brightness_notification = ''notify-send -a bright -u low -h int:value:$(brightnessctl -d amdgpu_bl1  | grep -o '[0-9]\+%') Brightness --hint=string:x-dunst-stack-tag:brightness'';
    send_kb_brightness_notification = ''notify-send -i keyboard -u low "Keyboard brightness" $(asusctl leds get | grep "Current" | cut -c 34-) --hint=string:x-dunst-stack-tag:kbbrightness'';
    send_fan_profile_notification = ''notify-send -i sensors-fan-symbolic -u low "Fan profile" $(asusctl profile get | grep "Active profile: " | cut -c 17-) --hint=string:x-dunst-stack-tag:fans'';
    send_aura_notification = ''notify-send -i keyboard-brightness-symbolic -u low "Aura" "Next mode"'';
    send_touchpad_notification = ''xinput | grep floating && notify-send -i touchpad-disabled-symbolic -u low "Touchpad" "Off" --hint=string:x-dunst-stack-tag:volume || notify-send -i touchpad-enabled-symbolic -u low "Touchpad" "On" --hint=string:x-dunst-stack-tag:volume'';
    mouse_to_focused = "i3-mouse-to-center";
    ws_names = map toString (lib.range 1 10);
    ws_keys = (map toString (lib.range 1 9)) ++ ["0"];
    ws_bindings =
      foldl (a: b: a // b) {}
      (zipListsWith (
          ws_name: ws_key: {
            "${mod}+${ws_key}" = "workspace number ${ws_name}; exec --no-startup-id ${mouse_to_focused}";
            "${mod}+Shift+${ws_key}" = "move container to workspace number ${ws_name}; exec --no-startup-id ${mouse_to_focused}";
          }
        )
        ws_names
        ws_keys);
  in {
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
      for_window [all] title_window_icon on
      for_window [all] title_window_icon padding 3px
    '';

    xsession.windowManager.i3.config = {
      modifier = "Mod4";

      colors = let
        c = colors.withHashtag;
      in {
        background = c.base05;
        focused = {
          border = c.base03;
          background = c.base03;
          text = c.base00;
          indicator = c.base06;
          childBorder = c.base03;
        };
        focusedInactive = {
          border = c.base02;
          background = c.base02;
          text = c.base05;
          indicator = c.base00;
          childBorder = c.base02;
        };
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
        inner = ceil (5 * hidpiScalingFactor);
        outer = ceil (2 * hidpiScalingFactor);
      };

      defaultWorkspace = "workspace number 1";
      workspaceAutoBackAndForth = true;

      keybindings = lib.mkForce (ws_bindings
        // {
          "XF86AudioRaiseVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +${step} && ${send_volume_notification}";
          "--whole-window ${mod}+Shift+button4" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +${step} && ${send_volume_notification}";
          "XF86AudioLowerVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -${step} && ${send_volume_notification}";
          "--whole-window ${mod}+Shift+button5" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -${step} && ${send_volume_notification}";
          "XF86AudioMute" = ''exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle && notify-send -u low "Audio" "$(pactl get-sink-mute @DEFAULT_SINK@)" -i audio-volume-muted --hint=string:x-dunst-stack-tag:volume'';
          "XF86AudioMicMute" = ''exec --no-startup-id pactl set-source-mute @DEFAULT_SOURCE@ toggle && notify-send -u low "Microphone" "$(pactl get-source-mute @DEFAULT_SOURCE@)" -i audio-volume-muted --hint=string:x-dunst-stack-tag:volume'';
          "${mod}+semicolon" = "move to scratchpad; exec --no-startup-id ${mouse_to_focused}";
          "${mod}+l" = "scratchpad show; exec --no-startup-id ${mouse_to_focused}";
          "XF86MonBrightnessUp" = "exec --no-startup-id brightnessctl -d amdgpu_bl1  set ${step}+ && ${send_brightness_notification}";
          "XF86MonBrightnessDown" = "exec --no-startup-id brightnessctl -d amdgpu_bl1  set ${step}- && ${send_brightness_notification}";
          "XF86KbdBrightnessUp" = "exec --no-startup-id asusctl leds next && ${send_kb_brightness_notification}";
          "XF86KbdBrightnessDown" = "exec --no-startup-id asusctl leds prev && ${send_kb_brightness_notification}";
          "XF86Launch1" = "exec pkill picom; exec flameshot gui";
          "XF86Launch3" = "exec --no-startup-id asusctl aura effect --next-mode && ${send_aura_notification}";
          "XF86Launch4" = "exec --no-startup-id asusctl profile next && ${send_fan_profile_notification}";
          "XF86TouchpadToggle" = let
            touchpadId = ''"$(xinput | grep Touchpad | tr '\t' '\n' | grep "id=[0-9]*" | tr '=' '\n' | tail -1)"'';
          in "exec --no-startup-id xinput | grep floating && xinput enable ${touchpadId} || xinput disable ${touchpadId} && ${send_touchpad_notification}";
          "${mod}+Return" = "exec kitty; exec --no-startup-id ${mouse_to_focused}";
          "${mod}+n" = "exec eww open --toggle nc";
          "${mod}+b" = "exec eww open --toggle bar";
          "${mod}+q" = "kill; exec --no-startup-id ${mouse_to_focused}";
          "${mod}+Shift+Return" = "exec ~/.config/rofi/launchers/type-2/launcher.sh";
          "${mod}+Shift+XF86Assistant" = "exec kitty -e ~/Documents/todo/run.sh";
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
          "w" = "resize set height 80 ppt; resize set width 80 ppt";
          "c" = "move position center";
          "Left" = "resize shrink width 10 px or 10 ppt";
          "Down" = "resize grow height 10 px or 10 ppt";
          "Up" = "resize shrink height 10 px or 10 ppt";
          "Right" = "resize grow width 10 px or 10 ppt";
          "Return" = ''mode "default"'';
          "Escape" = ''mode "default"'';
          "${mod}+r" = ''mode "default"'';
        };
        launch = {
          "t" = "exec ${lib.getExe pkgs.telegram-desktop}";
          "q" = "exec helium";
          "m" = "exec yandex-music";
          "e" = "exec dolphin";
          "F9" = "exec autorandr --batch --change --default default";
          "Return" = ''mode "default"'';
          "Escape" = ''mode "default"'';
          "${mod}+e" = ''mode "default"'';
        };
      };

      floating.modifier = mod;
      bars = [];

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
          command = "asusctl slash -l 128 --mode Flux -B true -S true -s false -b false -w true";
          always = true;
        }
        {
          command = let
            r = fromJSON c.base03-rgb-r;
            g = fromJSON c.base03-rgb-g;
            b = fromJSON c.base03-rgb-b;
            min-channel = min (min r g) b;
            saturated-r = r - min-channel;
            saturated-g = g - min-channel;
            saturated-b = b - min-channel;
            max-channel = max (max (max saturated-r saturated-g) saturated-b) 1;
            amplification-factor = 255.0 / max-channel;
            amplified-r = floor (max (saturated-r * amplification-factor) 1);
            amplified-g = floor (max (saturated-g * amplification-factor) 1);
            amplified-b = floor (max (saturated-b * amplification-factor) 1);
            perceivedBrightness = r: g: b: let
              brightness = (0.299 * r) + (0.587 * g) + (0.114 * b);
            in
              min (floor brightness) 255;
            original-brightness = perceivedBrightness r g b;
            brightness-scale = 255.0 / original-brightness;
            final-scale-pre = 255.0 / (max (max (max saturated-r saturated-g) saturated-b) 1);
            final-scale = let
              x = final-scale-pre;
              base-scale = 0.5 + (0.005 * x) + (0.0003 * x * x);
            in
              base-scale * brightness-scale;
            final-amplified-r = max (min (floor (amplified-r * final-scale)) 255) 1;
            final-amplified-g = max (min (floor (amplified-g * final-scale)) 255) 1;
            final-amplified-b = max (min (floor (amplified-b * final-scale)) 255) 1;
            padToTwo = s:
              if stringLength s == 1
              then "0${s}"
              else s;
            hex-r = padToTwo (toHexString (floor final-amplified-r));
            hex-g = padToTwo (toHexString (floor final-amplified-g));
            hex-b = padToTwo (toHexString (floor final-amplified-b));
            result-color = hex-r + hex-g + hex-b;
          in "asusctl aura effect static -c ${result-color} && asusctl leds set low";
          always = true;
        }
        {
          command = "feh --no-fehbg --bg-fill ${config.stylix.image}";
          always = true;
        }
      ];

      window = {
        border = ceil (2 * hidpiScalingFactor);
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
  };
}
