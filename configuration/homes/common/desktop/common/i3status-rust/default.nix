{
  config,
  pkgs,
  lib,
  hidpiScalingFactor,
  ...
}: let
  extraPackages = with pkgs; [
    xkb-switch-i3
  ];
  i3status-rust-wrapped = pkgs.symlinkJoin {
    name = "i3status-rust-wrapped";
    paths = [pkgs.i3status-rust];
    inherit (pkgs.i3status-rust) version;
    preferLocalBuild = true;
    nativeBuildInputs = [pkgs.makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/i3status-rs \
        --suffix PATH : ${lib.makeBinPath extraPackages}
    '';
  };
in {
  home.packages = with pkgs; [
    pulseaudio
    pavucontrol
    arandr
    brightnessctl
    playerctl
  ];
  xsession.windowManager.i3.config.bars = [
    {
      position = "top";
      trayOutput = "primary";
      trayPadding = 2; #px
      workspaceButtons = true;
      workspaceNumbers = true;
      colors = let
        c = config.lib.stylix.colors.withHashtag;
      in {
        background = c.base00;
        separator = c.base01;
        statusline = c.base06;
        focusedBackground = c.base00;
        focusedSeparator = c.base01;
        focusedStatusline = c.base06;
        bindingMode = {
          background = c.base08;
          border = c.base06;
          text = c.base05;
        };
        focusedWorkspace = {
          border = c.base0B;
          background = c.base0B;
          text = c.base01;
        };
        activeWorkspace = {
          border = c.base04;
          background = c.base04;
          text = c.base00;
        };
        inactiveWorkspace = {
          border = c.base02;
          background = c.base02;
          text = c.base05;
        };
        urgentWorkspace = {
          border = c.base0F;
          background = c.base0F;
          text = c.base07;
        };
      };
      fonts = {
        names = [config.stylix.fonts.serif.name];
        size = 5 * hidpiScalingFactor;
      };
      statusCommand = "${i3status-rust-wrapped}/bin/i3status-rs ~/.config/i3status-rust/config-top.toml";
    }
  ];
  programs.i3status-rust = {
    enable = true;
    package = i3status-rust-wrapped;
    # enableDefault = false;
    bars = {
      top = {
        settings = {
          theme = {
            theme = "plain";
            overrides = let
              c = config.lib.stylix.colors.withHashtag;
            in {
              idle_bg = c.base00;
              idle_fg = c.base05;

              info_bg = c.base04;
              info_fg = c.base00;

              good_bg = c.base0B;
              good_fg = c.base05;

              warning_bg = c.base09;
              warning_fg = c.base02;

              critical_bg = c.base08;
              critical_fg = c.base05;

              separator_bg = c.base00;
              separator_fg = c.base05;
            };
          };
        };
        theme = "plain";
        icons = "material-nf";
        blocks = let
          load = {
            block = "load";
            interval = 5;
            icons_format = "{icon} ";
          };
          memory = {
            block = "memory";
            format = " $icon  $mem_used_percents ";
            format_alt = " $icon  USED $mem_used.eng(w:3,u:B,p:Mi)/$mem_total.eng(w:3,u:B,p:Mi)($mem_used_percents.eng(w:2)) ";
            interval = 10;
            warning_mem = 70;
            critical_mem = 90;
          };
          temperature = {
            block = "temperature";
            format = " $icon $average ";
            format_alt = " $icon $min min, $max max, $average avg ";
            interval = 30;
            chip = "*-pci-*";
          };
          battery = {
            block = "battery";
            format = " $icon $percentage {$time_remaining.dur(hms:true, min_unit:m) |}";
            missing_format = " $icon missing";
            empty_format = " $icon $percentage {$time_remaining.dur(hms:true, min_unit:m) |}";
            charging_format = " $icon $percentage {$time_remaining.dur(hms:true, min_unit:m) |}";
            not_charging_format = " $icon N CH $percentage {$time_remaining.dur(hms:true, min_unit:m) |}";
            full_format = " $icon FULL $percentage";
            device = "DisplayDevice";
            driver = "upower";
            empty_threshold = 5;
            critical = 10;
            warning = 20;
            info = 50;
            good = 70;
            full_threshold = 95;
          };
          backlight = {
            block = "backlight";
            format = " $icon  $brightness ";
            click = [
              {
                button = "left";
                cmd = "arandr";
              }
            ];
          };
          music = {
            block = "music";
            format = " $icon {$combo.str(max_w:20,rot_interval:0.5) $play $next |}";
          };
          sound = {
            block = "sound";
            step_width = 3;
            format = " $icon  $volume|";
            click = [
              {
                button = "left";
                cmd = "pavucontrol";
              }
            ];
          };
          time = {
            block = "time";
            interval = 1;
            format = " $icon  $timestamp.datetime(f:'%d-%m-%Y - %H:%M:%S')  ";
            timezone = "Europe/Moscow";
          };
          cpu = {
            block = "cpu";
            interval = 1;
            format = " $icon  $barchart $utilization ";
            format_alt = " $icon $frequency{ $boost|} ";
            info_cpu = 20;
            warning_cpu = 50;
            critical_cpu = 90;
          };
          focused_window = {
            block = "focused_window";
            format = {
              full = " $title.str(max_w:80) | . ";
              short = " $title.str(max_w:40) | . ";
            };
          };
          keyboard_layout = {
            block = "keyboard_layout";
            driver = "xkbswitch";
            interval = 1;
          };
          notify = {
            block = "notify";
            format = " $icon {($notification_count.eng(w:1)) |} {$paused{Off}|On} ";
          };
          privacy = {
            block = "privacy";
            driver = [
              {
                name = "v4l";
              }
              {
                name = "pipewire";
              }
            ];
          };
          scratchpad = {
            block = "scratchpad";
          };
        in [
          scratchpad
          focused_window

          load
          memory
          temperature
          cpu
          battery
          music

          time
          keyboard_layout

          notify
          backlight
          sound

          privacy
        ];
      };
    };
  };
}
