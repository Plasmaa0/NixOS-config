{...}: {
  flake.homeModules.desktop-notifications-wayland-swaync = {
    config,
    pkgs,
    ...
  }: let
    c = config.lib.stylix.colors.withHashtag;
    rgb = colorName: let
      r = builtins.fromJSON (builtins.getAttr "${colorName}-rgb-r" config.lib.stylix.colors);
      g = builtins.fromJSON (builtins.getAttr "${colorName}-rgb-g" config.lib.stylix.colors);
      b = builtins.fromJSON (builtins.getAttr "${colorName}-rgb-b" config.lib.stylix.colors);
    in "${toString r}, ${toString g}, ${toString b}";
    pillAlpha = "0.85";
    ccAlpha = "0.95";
  in {
    stylix.targets.swaync.enable = false;
    services.swaync.enable = true;
    services.swaync.style = ''
      /* ---- Liquid glass – matches Waybar pill style ---- */

      @define-color base00 ${c.base00}; @define-color base01 ${c.base01};
      @define-color base02 ${c.base02}; @define-color base03 ${c.base03};
      @define-color base04 ${c.base04}; @define-color base05 ${c.base05};
      @define-color base06 ${c.base06}; @define-color base07 ${c.base07};
      @define-color base08 ${c.base08}; @define-color base09 ${c.base09};
      @define-color base0A ${c.base0A}; @define-color base0B ${c.base0B};
      @define-color base0C ${c.base0C}; @define-color base0D ${c.base0D};
      @define-color base0E ${c.base0E}; @define-color base0F ${c.base0F};

      /* Reset everything – we will reapply glass backgrounds explicitly */
      * {
          border: none !important;
          box-shadow: none !important;
          outline: none !important;
          background-color: transparent !important;
          background-image: none !important;
      }

      /* ---- Control center – glass panel ---- */
      .control-center {
          background-color: rgba(${rgb "base00"}, ${ccAlpha}) !important;
          border: 1px solid rgba(${rgb "base03"}, 0.3) !important;
          border-radius: 12px;
          margin: 10px;
          box-shadow: 0 2px 8px rgba(0,0,0,0.25) !important;
          backdrop-filter: blur(20px);
          -gtk-backdrop-filter: blur(20px);
      }

      .notification-row {
          background-color: transparent !important;
          background-image: none !important;
          margin: 0 !important;
          padding: 4px 8px !important;
      }

      /* ---- The main notification pill – glass background ---- */
      .notification {
          background-color: rgba(${rgb "base00"}, ${pillAlpha}) !important;
          background-image: none !important;
          color: ${c.base07} !important;
          /* Explicit longhand borders to avoid GTK4 shorthand bugs */
          border-top: 1px solid rgba(${rgb "base03"}, 0.3) !important;
          border-right: 1px solid rgba(${rgb "base03"}, 0.3) !important;
          border-bottom: 1px solid rgba(${rgb "base03"}, 0.3) !important;
          border-left: 3px solid rgba(${rgb "base03"}, 0.8) !important;
          border-radius: 12px;
          padding: 0;
          margin: 0;
          box-shadow: 0 2px 8px rgba(0,0,0,0.25) !important;
          transition: all 0.2s ease;
      }

      /* Urgency left borders */
      .notification.low {
          border-left: 3px solid rgba(${rgb "base03"}, 0.8) !important;
      }
      .notification.normal {
          border-left: 3px solid rgba(${rgb "base0D"}, 0.8) !important;
      }
      .notification.critical {
          border-left: 3px solid ${c.base08} !important;
          /* Use background-image for the tint so it layers over the background-color */
          background-image: linear-gradient(to bottom, rgba(${rgb "base08"}, 0.1), rgba(${rgb "base08"}, 0.1)) !important;
      }

      /* Hover effect – matches Waybar */
      .notification-row:hover .notification {
          background-color: rgba(${rgb "base01"}, 0.6) !important;
          background-image: none !important;
          box-shadow: 0 4px 12px rgba(0,0,0,0.35) !important;
      }
      /* Hover for critical keeps red tint */
      .notification-row:hover .notification.critical {
          background-color: rgba(${rgb "base01"}, 0.6) !important;
          background-image: linear-gradient(to bottom, rgba(${rgb "base08"}, 0.2), rgba(${rgb "base08"}, 0.2)) !important;
      }

      /* Focus/highlight for the selected notification */
      .notification-row:focus {
          background-color: transparent !important;
      }

      /* All children inside the notification – keep transparent */
      .notification * {
          border: none !important;
          box-shadow: none !important;
          outline: none !important;
          background-color: transparent !important;
          background-image: none !important;
      }

      /* ---- Content ---- */
      .notification-content {
          padding: 10px 14px;
      }

      .summary {
          color: @base07;
          font-weight: bold;
          font-style: normal;
      }

      .body {
          color: @base06;
          font-weight: normal;
      }

      .time {
          color: @base04;
          font-size: 0.9em;
      }

      .close-button {
          background-color: rgba(${rgb "base00"}, 0.7) !important;
          color: @base08 !important;
          border-radius: 100%;
          min-width: 24px;
          min-height: 24px;
          padding: 0;
          margin: 8px 10px 0 0;
          transition: all 0.2s ease;
      }
      .close-button:hover {
          background-color: @base08 !important;
          color: @base00 !important;
      }

      .notification-default-action,
      .notification-action {
          background-color: transparent !important;
          border-radius: 8px;
          color: @base06;
          padding: 6px 12px;
          margin: 4px;
          transition: all 0.2s ease;
      }
      .notification-default-action:hover,
      .notification-action:hover {
          background-color: rgba(${rgb "base01"}, 0.6) !important;
          color: @base07;
      }

      /* ---- Progress bars (contrasty) ---- */
      .notification progress,
      .notification trough {
          border: none !important;
          border-radius: 4px;
          min-height: 6px;
          background-color: rgba(${rgb "base01"}, 0.8) !important;
      }
      .notification progress {
          background-color: @base0D !important;
      }
      .notification.low progress {
          background-color: @base03 !important;
      }
      .notification.normal progress {
          background-color: @base0D !important;
      }
      .notification.critical progress {
          background-color: @base08 !important;
      }

      /* ---- Floating notifications ---- */
      .floating-notifications .notification {
          background-color: rgba(${rgb "base00"}, ${pillAlpha}) !important;
          background-image: none !important;
          color: ${c.base07} !important;
          border-top: 1px solid rgba(${rgb "base03"}, 0.3) !important;
          border-right: 1px solid rgba(${rgb "base03"}, 0.3) !important;
          border-bottom: 1px solid rgba(${rgb "base03"}, 0.3) !important;
          border-left: 3px solid rgba(${rgb "base03"}, 0.8) !important;
          border-radius: 12px;
          box-shadow: 0 2px 8px rgba(0,0,0,0.25) !important;
          backdrop-filter: blur(10px);
          -gtk-backdrop-filter: blur(10px);
      }
      .floating-notifications .notification.normal {
          border-left: 3px solid rgba(${rgb "base0D"}, 0.8) !important;
      }
      .floating-notifications .notification.critical {
          border-left: 3px solid ${c.base08} !important;
          background-image: linear-gradient(to bottom, rgba(${rgb "base08"}, 0.1), rgba(${rgb "base08"}, 0.1)) !important;
      }
      .floating-notifications .notification-row:hover .notification {
          background-color: rgba(${rgb "base01"}, 0.6) !important;
          background-image: none !important;
          box-shadow: 0 4px 12px rgba(0,0,0,0.35) !important;
      }
      .floating-notifications .notification-row:hover .notification.critical {
          background-color: rgba(${rgb "base01"}, 0.6) !important;
          background-image: linear-gradient(to bottom, rgba(${rgb "base08"}, 0.2), rgba(${rgb "base08"}, 0.2)) !important;
      }

      /* ---- Widgets ---- */
      .widget-title {
          color: @base07;
          font-weight: bold;
          font-style: normal;
          margin: 12px 20px 8px;
      }
      .widget-title > button {
          background-color: rgba(${rgb "base00"}, 0.5) !important;
          border-radius: 8px;
          color: @base06;
      }
      .widget-title > button:hover {
          background-color: rgba(${rgb "base01"}, 0.6) !important;
      }

      .widget-dnd {
          color: @base06;
          margin: 8px 20px;
      }
      .widget-dnd > switch {
          background-color: rgba(${rgb "base00"}, 0.6) !important;
          border-radius: 999px;
          padding: 1px;
      }
      .widget-dnd > switch:checked {
          background-color: @base0B !important;
      }
      .widget-dnd > switch slider {
          background-color: @base06 !important;
          border-radius: 999px;
      }

      .widget-mpris {
          background-color: rgba(${rgb "base00"}, 0.5) !important;
          border-radius: 12px;
          padding: 10px;
          margin: 8px 20px;
      }
      .widget-mpris-title {
          font-weight: bold;
          color: @base07;
      }
      .widget-mpris-subtitle {
          color: @base05;
      }

      .widget-buttons-grid {
          background-color: rgba(${rgb "base00"}, 0.5) !important;
          border-radius: 12px;
          padding: 8px;
          margin: 8px 20px;
      }
      .widget-buttons-grid > flowbox > flowboxchild > button {
          background-color: transparent !important;
          border-radius: 8px;
          color: @base06;
          padding: 6px 10px;
      }
      .widget-buttons-grid > flowbox > flowboxchild > button:hover {
          background-color: rgba(${rgb "base01"}, 0.6) !important;
          color: @base07;
      }

      .widget-volume {
          background-color: rgba(${rgb "base00"}, 0.5) !important;
          border-radius: 12px;
          padding: 8px 16px;
          margin: 8px 20px;
          color: @base0B;
      }
      .widget-backlight {
          background-color: rgba(${rgb "base00"}, 0.5) !important;
          border-radius: 12px;
          padding: 8px 16px;
          margin: 8px 20px;
          color: @base0A;
      }

      .widget-inhibitors {
          margin: 8px 20px;
      }
      .widget-inhibitors > button {
          background-color: rgba(${rgb "base00"}, 0.5) !important;
          border-radius: 8px;
          color: @base06;
          padding: 4px 10px;
      }
      .widget-inhibitors > button:hover {
          background-color: rgba(${rgb "base01"}, 0.6) !important;
      }

      /* ---- Misc ---- */
      .blank-window {
          background-color: transparent !important;
      }
      .control-center-list-placeholder {
          opacity: ${ccAlpha};
          color: @base05;
      }
      .toggle:checked { color: @base0B; }
    '';

    # ----- Utility scripts (test notifications, reload) -----
    home.packages = with pkgs; [
      libnotify

      (writeShellApplication {
        name = "notify-test";
        runtimeInputs = [gnugrep pulseaudio libnotify];
        text = ''
          notify-send -u critical "Urgent message" "critical test 1"
          notify-send -u normal "Normal message" "normal test 2"
          notify-send -u low "Low message" "low test 3"
          notify-send -u normal "Test with icon" "text" -i reddit
          notify-send -u low -a Cassette -i stock_volume "Test message" "Music test"
          notify-send -u low -a volume -h "int:value:$(pactl get-sink-volume @DEFAULT_SINK@ | grep -o '[0-9]\+%' | head -1)" "Volume" --hint=string:x-dunst-stack-tag:volume
          notify-send -u low -a bright -h "int:value:$(brightnessctl | grep -o '[0-9]\+%')" "Brightness" --hint=string:x-dunst-stack-tag:brightness
        '';
      })
    ];
  };
}
