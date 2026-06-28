{
  pkgs,
  lib,
  ...
}: let
  scripts = pkgs.callPackage ./_scripts.nix {};

  spawn-cmd = cmd: {spawn = lib.getExe cmd;};
in {
  programs.niri.settings.binds = {
    # ----- Workspace switching (1-10) -----
    "Mod+1".action = {focus-workspace = 1;};
    "Mod+2".action = {focus-workspace = 2;};
    "Mod+3".action = {focus-workspace = 3;};
    "Mod+4".action = {focus-workspace = 4;};
    "Mod+5".action = {focus-workspace = 5;};
    "Mod+6".action = {focus-workspace = 6;};
    "Mod+7".action = {focus-workspace = 7;};
    "Mod+8".action = {focus-workspace = 8;};
    "Mod+9".action = {focus-workspace = 9;};
    "Mod+0".action = {focus-workspace = 10;};
    "Mod+Shift+1".action = {move-window-to-workspace = [{focus = false;} 1];};
    "Mod+Shift+2".action = {move-window-to-workspace = [{focus = false;} 2];};
    "Mod+Shift+3".action = {move-window-to-workspace = [{focus = false;} 3];};
    "Mod+Shift+4".action = {move-window-to-workspace = [{focus = false;} 4];};
    "Mod+Shift+5".action = {move-window-to-workspace = [{focus = false;} 5];};
    "Mod+Shift+6".action = {move-window-to-workspace = [{focus = false;} 6];};
    "Mod+Shift+7".action = {move-window-to-workspace = [{focus = false;} 7];};
    "Mod+Shift+8".action = {move-window-to-workspace = [{focus = false;} 8];};
    "Mod+Shift+9".action = {move-window-to-workspace = [{focus = false;} 9];};
    "Mod+Shift+0".action = {move-window-to-workspace = [{focus = false;} 10];};

    # ----- Focus/Move (a,s,w,d) -----
    "Mod+a".action = {focus-column-or-monitor-left = [];};
    "Mod+s".action = {focus-window-or-workspace-down = [];};
    "Mod+w".action = {focus-window-or-workspace-up = [];};
    "Mod+d".action = {focus-column-or-monitor-right = [];};
    "Mod+Shift+a".action = {move-column-left-or-to-monitor-left = [];};
    "Mod+Shift+s".action = {move-window-down-or-to-workspace-down = [];};
    "Mod+Shift+w".action = {move-window-up-or-to-workspace-up = [];};
    "Mod+Shift+d".action = {move-column-right-or-to-monitor-right = [];};
    "Mod+Ctrl+a".action = {focus-monitor-left = [];};
    "Mod+Ctrl+s".action = {focus-monitor-down = [];};
    "Mod+Ctrl+w".action = {focus-monitor-up = [];};
    "Mod+Ctrl+d".action = {focus-monitor-right = [];};

    "Mod+Shift+Up".action = {move-workspace-up = [];};
    "Mod+Shift+Down".action = {move-workspace-down = [];};
    "Mod+Ctrl+Left".action = {move-workspace-to-monitor-left = [];};
    "Mod+Ctrl+Down".action = {move-workspace-to-monitor-down = [];};
    "Mod+Ctrl+Up".action = {move-workspace-to-monitor-up = [];};
    "Mod+Ctrl+Right".action = {move-workspace-to-monitor-right = [];};

    "Mod+comma".action = {consume-window-into-column = [];};
    "Mod+period".action = {expel-window-from-column = [];};

    # ----- Fullscreen / Tabbed / Floating -----
    "Mod+f".action = {expand-column-to-available-width = [];};
    "Mod+Ctrl+f".action = {maximize-column = [];};
    "Mod+Shift+f".action = {fullscreen-window = [];};
    "Mod+Shift+space".action = {toggle-window-floating = [];};
    "Mod+space".action = {switch-focus-between-floating-and-tiling = [];};

    "Mod+r".action = {switch-preset-column-width = [];};
    "Mod+c".action = {center-column = [];};
    "Mod+Left".action.set-column-width = "-10%";
    "Mod+Right".action.set-column-width = "+10%";
    "Mod+Up".action.set-window-height = "-10%";
    "Mod+Down".action.set-window-height = "+10%";

    # ----- Launch  -----
    "Mod+Shift+q" = {
      action.spawn = "helium";
      repeat = false;
    };
    "Mod+Shift+m" = {
      action.spawn = "yandex-music";
      repeat = false;
    };
    "Mod+v" = {
      action.spawn = "fuzzel-cliphist";
      repeat = false;
    };
    "Mod+Shift+L".action = {
      spawn = "swaylock";
    };

    # ----- Applications -----
    "Mod+Return" = {
      action.spawn = "kitty";
      repeat = false;
    };
    "Mod+Shift+Return" = {
      action.spawn = ["fuzzel"];
      repeat = false;
    };

    "Mod+q".action = {close-window = [];};
    "Mod+t" = {
      action.spawn = lib.getExe pkgs.telegram-desktop;
      repeat = false;
    };

    "XF86Launch1".action = {screenshot = [];};
    "Mod+Shift+e" = {
      action = spawn-cmd scripts.fuzzel_powermenu;
      repeat = false;
    };

    # ----- Media keys (using scripts) -----
    "XF86AudioRaiseVolume" = {
      action = spawn-cmd scripts.volume_up;
      allow-when-locked = true;
    };
    "XF86AudioLowerVolume" = {
      action = spawn-cmd scripts.volume_down;
      allow-when-locked = true;
    };
    "XF86AudioMute" = {
      action = spawn-cmd scripts.volume_mute;
      allow-when-locked = true;
    };
    "XF86AudioMicMute" = {
      action = spawn-cmd scripts.mic_mute;
      allow-when-locked = true;
    };
    "XF86MonBrightnessUp" = {
      action = spawn-cmd scripts.brightness_up;
      allow-when-locked = true;
    };
    "XF86MonBrightnessDown" = {
      action = spawn-cmd scripts.brightness_down;
      allow-when-locked = true;
    };
    "XF86TouchpadToggle" = {
      action = spawn-cmd scripts.touchpad_toggle;
      allow-when-locked = true;
    };
    "XF86AudioPlay".action = {spawn = "playerctl play-pause";};
    "XF86AudioNext".action = {spawn = "playerctl next";};
    "XF86AudioPrev".action = {spawn = "playerctl previous";};

    "Mod+question".action = {show-hotkey-overlay = [];};
    "Mod+tab".action = {toggle-overview = [];};
    "Mod+Shift+P".action = {power-off-monitors = [];};
  };
}
