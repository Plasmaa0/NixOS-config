{
  config,
  pkgs,
  lib,
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
    colors = {
      background = "#${c.base05}";
      focused = {
        border = "#${c.base0B}";
        background = "#${c.base0B}";
        text = "#${c.base01}";
        indicator = "#${c.base0C}";
        childBorder = "#${c.base0B}";
      };
      unfocused = {
        border = "#${c.base05}";
        background = "#${c.base01}";
        text = "#${c.base06}";
        indicator = "#${c.base06}";
        childBorder = "#${c.base05}";
      };
      focusedInactive = {
        border = "#${c.base0C}";
        background = "#${c.base0C}";
        text = "#${c.base01}";
        indicator = "#${c.base0A}";
        childBorder = "#${c.base0C}";
      };
      urgent = {
        border = "#${c.base0F}";
        background = "#${c.base0F}";
        text = "#${c.base05}";
        indicator = "#${c.base0F}";
        childBorder = "#${c.base0F}";
      };
      placeholder = {
        border = "#${c.base00}";
        background = "#${c.base00}";
        text = "#${c.base05}";
        indicator = "#${c.base00}";
        childBorder = "#${c.base00}";
      };
    };
    fonts = {
      names = [config.stylix.fonts.serif.name];
      size = 10.0;
    };
    gaps = {
      smartBorders = "on";
      smartGaps = true;
      inner = 5;
      outer = 10;
    };
    keybindings = let
      mod = config.xsession.windowManager.i3.config.modifier;
      send_volume_notification = ''notify-send -a volume -u low -h int:value:$(pactl get-sink-volume @DEFAULT_SINK@ | grep -o '[0-9]\+%' | head -1) Volume --hint=string:x-dunst-stack-tag:volume'';
      step = "5%";
      send_brightness_notification = ''notify-send -a bright -u low -h int:value:$(brightnessctl | grep -o '[0-9]\+%') Brightness --hint=string:x-dunst-stack-tag:brightness'';
      # move mouse to center of currently focused window (FIXME moves mouse to top left if no window in focus)
      # mouse_to_focused = ''"${pkgs.bash}/bin/sh -c 'eval `${pkgs.xdotool}/bin/xdotool getactivewindow getwindowgeometry --shell`; ${pkgs.xdotool}/bin/xdotool mousemove $((X+WIDTH/2)) $((Y+HEIGHT/2))'"'';
      mouse_to_focused = "i3-mouse-to-center";
      ws1 = "1";
      ws2 = "2";
      ws3 = "3";
      ws4 = "4";
      ws5 = "5";
      ws6 = "6";
      ws7 = "7";
      ws8 = "8";
      ws9 = "9";
    in
      lib.mkOptionDefault {
        "XF86AudioRaiseVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +${step} && ${send_volume_notification}";
        "--whole-window ${mod}+Shift+button4" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +${step} && ${send_volume_notification}";
        "XF86AudioLowerVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -${step} && ${send_volume_notification}";
        "--whole-window ${mod}+Shift+button5" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -${step} && ${send_volume_notification}";
        "XF86AudioMute" = "exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle && notify-send -u low $(pactl get-sink-mute @DEFAULT_SINK@) -i audio-volume-muted --hint=string:x-dunst-stack-tag:volume";
        "XF86AudioMicMute" = "exec --no-startup-id pactl set-source-mute @DEFAULT_SOURCE@ toggle && notify-send -u low $(pactl get-source-mute @DEFAULT_SOURCE@) -i audio-volume-muted --hint=string:x-dunst-stack-tag:volume";
        "${mod}+semicolon" = "move to scratchpad";
        "${mod}+l" = "scratchpad show; resize set height 80 ppt; resize set width 80 ppt; move position center";
        "XF86MonBrightnessUp" = "exec --no-startup-id brightnessctl set ${step}+ && ${send_brightness_notification} # increase screen brightness";
        "XF86MonBrightnessDown" = "exec --no-startup-id brightnessctl set ${step}- && ${send_brightness_notification} # decrease screen brightness";
        "${mod}+Return" = "exec wezterm";
        "${mod}+q" = "kill";
        "${mod}+Shift+Return" = "exec ~/.config/rofi/launchers/type-2/launcher.sh";
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
        "${mod}+Tab" = "layout toggle tabbed split";
        "${mod}+Shift+space" = "floating toggle";
        "${mod}+space" = "focus mode_toggle";
        "${mod}+p" = "focus parent; exec --no-startup-id ${mouse_to_focused}";
        "${mod}+c" = "focus child; exec --no-startup-id ${mouse_to_focused}";
        "${mod}+1" = "workspace number ${ws1}; exec --no-startup-id ${mouse_to_focused}";
        "${mod}+2" = "workspace number ${ws2}; exec --no-startup-id ${mouse_to_focused}";
        "${mod}+3" = "workspace number ${ws3}; exec --no-startup-id ${mouse_to_focused}";
        "${mod}+4" = "workspace number ${ws4}; exec --no-startup-id ${mouse_to_focused}";
        "${mod}+5" = "workspace number ${ws5}; exec --no-startup-id ${mouse_to_focused}";
        "${mod}+6" = "workspace number ${ws6}; exec --no-startup-id ${mouse_to_focused}";
        "${mod}+7" = "workspace number ${ws7}; exec --no-startup-id ${mouse_to_focused}";
        "${mod}+8" = "workspace number ${ws8}; exec --no-startup-id ${mouse_to_focused}";
        "${mod}+9" = "workspace number ${ws9}; exec --no-startup-id ${mouse_to_focused}";
        "${mod}+Shift+1" = "move container to workspace number ${ws1}; exec --no-startup-id ${mouse_to_focused}";
        "${mod}+Shift+2" = "move container to workspace number ${ws2}; exec --no-startup-id ${mouse_to_focused}";
        "${mod}+Shift+3" = "move container to workspace number ${ws3}; exec --no-startup-id ${mouse_to_focused}";
        "${mod}+Shift+4" = "move container to workspace number ${ws4}; exec --no-startup-id ${mouse_to_focused}";
        "${mod}+Shift+5" = "move container to workspace number ${ws5}; exec --no-startup-id ${mouse_to_focused}";
        "${mod}+Shift+6" = "move container to workspace number ${ws6}; exec --no-startup-id ${mouse_to_focused}";
        "${mod}+Shift+7" = "move container to workspace number ${ws7}; exec --no-startup-id ${mouse_to_focused}";
        "${mod}+Shift+8" = "move container to workspace number ${ws8}; exec --no-startup-id ${mouse_to_focused}";
        "${mod}+Shift+9" = "move container to workspace number ${ws9}; exec --no-startup-id ${mouse_to_focused}";
        "${mod}+Shift+c" = "reload";
        "${mod}+Shift+r" = "restart";
        "${mod}+Shift+e" = "exec ~/.config/rofi/powermenu/type-2/powermenu.sh";
        "${mod}+t" = "exec telegram-desktop";
        "Print" = "exec pkill picom; exec flameshot gui";
        "${mod}+r" = ''mode "resize"'';
        "${mod}+m" = ''[class="cassette"] scratchpad show; resize set height 80 ppt; resize set width 80 ppt; move position center'';
      };
    modes = {
      resize = {
        "j" = "resize shrink width 10 px or 10 ppt";
        "k" = "resize grow height 10 px or 10 ppt";
        "l" = "resize shrink height 10 px or 10 ppt";
        "semicolon" = "resize grow width 10 px or 10 ppt";
        "space" = "resize set width 50ppt";

        "Left" = "resize shrink width 10 px or 10 ppt";
        "Down" = "resize grow height 10 px or 10 ppt";
        "Up" = "resize shrink height 10 px or 10 ppt";
        "Right" = "resize grow width 10 px or 10 ppt";

        "Return" = ''mode "default"'';
        "Escape" = ''mode "default"'';
        "$mod+r" = ''mode "default"'';
      };
    };
    floating.modifier = config.xsession.windowManager.i3.config.modifier;
    bars = [];
    startup = [
      {
        command = "nm-applet --indicator";
        notification = false;
      }
      {
        command = "xhost +";
        notification = false;
      }
      {
        command = "feh --bg-fill ${config.stylix.image}";
        notification = false;
        always = true;
      }
      {
        command = "eww open --toggle bar";
        notification = false;
        always = true;
      }
    ];
    window = {
      border = 2;
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
          command = "floating enable border pixel 1";
          criteria = {class = "Yad";};
        }
      ];
    };
  };
}
