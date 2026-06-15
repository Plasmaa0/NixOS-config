{...}: let
  module = {
    config,
    pkgs,
    lib,
    ...
  }: let
    c = config.lib.stylix.colors.withHashtag;
  in {
    services.polybar = {
      enable = true;
      package = pkgs.polybar.override {
        i3Support = true;
        alsaSupport = true;
        pulseSupport = true;
      };
      script = "polybar main &";
      extraConfig = "";
      settings = {
        "bar/main" = {
          monitor = "\${env:MONITOR:eDP-1}";
          width = "100%";
          height = 24;
          radius = 6;
          background = c.base00;
          foreground = c.base05;
          border-top-size = 0;
          border-bottom-size = 0;
          border-left-size = 0;
          border-right-size = 0;
          border-color = c.base00;
          padding-left = 1;
          padding-right = 1;
          module-margin = 1;
          separator = "|";
          separator-foreground = c.base04;
          font = ["${config.stylix.fonts.serif.name}:size=${toString (builtins.ceil (10 * (config.stylix.fonts.sizes.desktop / 12)))};2"];
          modules-left = "i3";
          modules-center = "date";
          modules-right = "pulseaudio backlight-acpi network cpu memory battery";
          cursor-click = "pointer";
          cursor-scroll = "ns-resize";
          wm-restack = "bspwm";
        };
        "module/i3" = {
          type = "internal/i3";
          pin-workspaces = true;
          strip-wsnumbers = true;
          index-sort = true;
          wrapping-scroll = false;
          enable-click = true;
          enable-scroll = true;
          ws-icon-0 = "1;";
          ws-icon-1 = "2;";
          ws-icon-2 = "3;";
          ws-icon-3 = "4;";
          ws-icon-4 = "5;";
          ws-icon-5 = "6;";
          ws-icon-6 = "7;";
          ws-icon-7 = "8;";
          ws-icon-8 = "9;";
          ws-icon-9 = "10;";
        };
        "module/date" = {
          type = "internal/date";
          interval = 1;
          date = "%d.%m.%y";
          time = "%H:%M:%S";
          date-alt = "%Y-%m-%d";
          time-alt = "%H:%M:%S";
          format-prefix = "";
          format-prefix-foreground = c.base05;
          format-foreground = c.base05;
          label = "%date% %time%";
        };
        "module/pulseaudio" = {
          type = "internal/pulseaudio";
          use-ui-max = false;
          format-volume-prefix = "VOL";
          format-volume-prefix-foreground = c.base0D;
          label-volume = "%percentage%%";
          format-muted-prefix = "VOL";
          format-muted-prefix-foreground = c.base08;
          label-muted = "muted";
        };
        "module/backlight-acpi" = {
          type = "internal/backlight";
          card = "amdgpu_bl1";
          format-backlight = "<label>";
          label = "%percentage%%";
        };
        "module/network" = {
          type = "internal/network";
          interface = "wlp2s0";
          interval = 3;
          format-connected = "<label-connected>";
          label-connected = "%essid%";
          format-disconnected = "<label-disconnected>";
          label-disconnected = "disconnected";
        };
        "module/cpu" = {
          type = "internal/cpu";
          interval = 2;
          format-prefix = "CPU";
          format-prefix-foreground = c.base0D;
          label = "%percentage%%";
        };
        "module/memory" = {
          type = "internal/memory";
          interval = 2;
          format-prefix = "MEM";
          format-prefix-foreground = c.base0D;
          label = "%gb_used%";
        };
        "module/battery" = {
          type = "internal/battery";
          battery = "BAT0";
          adapter = "ADP1";
          full-at = 98;
          format-charging = "<label-charging>";
          label-charging = "%percentage%%";
          format-discharging = "<label-discharging>";
          label-discharging = "%percentage%%";
          format-full = "<label-full>";
          label-full = "full";
        };
      };
    };
  };
in {
  flake.homeModules.desktop = module;
}
