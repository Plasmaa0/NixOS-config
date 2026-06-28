{...}: {
  flake.homeModules.desktop-bar-wayland-waybar = {
    config,
    lib,
    pkgs,
    ...
  }: let
    c = config.lib.stylix.colors.withHashtag;
    fonts = config.stylix.fonts;

    # Helper to get RGB string
    rgb = colorName: let
      r = builtins.fromJSON (builtins.getAttr "${colorName}-rgb-r" config.lib.stylix.colors);
      g = builtins.fromJSON (builtins.getAttr "${colorName}-rgb-g" config.lib.stylix.colors);
      b = builtins.fromJSON (builtins.getAttr "${colorName}-rgb-b" config.lib.stylix.colors);
    in "${toString r}, ${toString g}, ${toString b}";

    pillAlpha = "0.5";
    wsActiveBg = "rgba(${rgb "base0A"}, 0.2)";
    wsActiveBorder = "rgba(${rgb "base0A"}, 0.6)";
    wsOccupiedBg = "rgba(${rgb "base0A"}, 0.08)";
    wsActiveOccupiedBg = "rgba(${rgb "base0A"}, 0.15)";
  in {
    programs.waybar = {
      enable = true;
      systemd.enable = false;

      settings = [
        {
          layer = "top";
          position = "top";
          spacing = 0;
          height = 34; # compact, just enough for the font

          modules-left = ["image/snowflake" "niri/workspaces" "niri/window"];
          modules-center = ["clock" "custom/notification"];
          modules-right = [
            "tray"
            "pulseaudio"
            "backlight"
            "battery"
            "niri/language"
          ];

          "image/snowflake" = {
            path = "${pkgs.nixos-icons}/share/icons/hicolor/256x256/apps/nix-snowflake.png";
            size = 24;
            tooltip = true;
            tooltip-format = "NixOS ❄️";
            on-click = "nixos-version";
          };

          "niri/workspaces" = {
            format = "{icon} {index}";
            format-icons = {
              default = "○";
              active = "";
              focused = "●";
            };
            hide-empty = true;
          };

          "niri/window" = {
            format = "󰣆 {title}";
          };

          "clock" = {
            format = "󰃭 {:%d-%m-%Y %H:%M}";
            interval = 1;
            tooltip-format = "<tt><small>{calendar}</small></tt>";
          };

          "custom/notification" = {
            "tooltip" = true;
            "format" = "{0} <span size='16pt'>{icon}</span>";
            "format-icons" = {
              "notification" = "󱅫";
              "none" = "󰂜";
              "dnd-notification" = "󰂠";
              "dnd-none" = "󰪓";
              "inhibited-notification" = "󰂛";
              "inhibited-none" = "󰪑";
              "dnd-inhibited-notification" = "󰂛";
              "dnd-inhibited-none" = "󰪑";
            };
            "return-type" = "json";
            "exec-if" = "which swaync-client";
            "exec" = "swaync-client -swb";
            "on-click" = "swaync-client -t -sw";
            "on-click-right" = "swaync-client -d -sw";
            "escape" = true;
          };

          "tray" = {
            icon-size = 16;
            spacing = 4;
          };

          "pulseaudio" = {
            format = "{icon} {volume}%";
            format-muted = "󰖁 Muted";
            format-icons = {default = ["󰕿" "󰖀" "󰕾"];};
            scroll-step = 5;
            on-click = "pavucontrol";
          };

          "backlight" = {
            device = "amdgpu_bl1";
            format = "{icon} {percent}%";
            format-icons = ["🌑" "🌒" "🌓" "🌔" "🌕"];
            scroll-step = 5;
          };

          "battery" = {
            bat = "BAT1";
            interval = 10;
            full-at = 99;
            low-at = 10;
            format = "{icon} {capacity}%";
            format-charging = "󰂄 {capacity}%";
            format-discharging = "{icon} {capacity}%";
            format-full = "󰁹 FULL";
            format-low = "󰁺 {capacity}%";
            format-icons = {
              default = ["󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
            };
          };

          "niri/language" = {
            format-en = "🇬🇧 en";
            format-ru = "🇷🇺 ru";
          };
        }
      ];

      style = ''
        * {
            font-family: "${fonts.serif.name}", "Font Awesome 6 Free", "Font Awesome 6 Brands", "${fonts.emoji.name}";
            font-size: ${toString (fonts.sizes.desktop * 2)}pt;
            font-weight: normal;
        }

        window#waybar {
            background: transparent;
            color: ${c.base07};
            border: none;
            border-radius: 0;
            min-height: 0;
        }

        /* Glass pills – minimal vertical padding */
        #workspaces,
        #window,
        #clock,
        #cpu,
        #memory,
        #temperature,
        #pulseaudio,
        #battery,
        #backlight,
        #network,
        #tray,
        #language,
        #custom-power,
        #image,
        #custom-notification {
            background: rgba(${rgb "base00"}, ${pillAlpha});
            color: ${c.base07};
            border: 1px solid rgba(${rgb "base03"}, 0.3);
            border-radius: 12px;
            padding: 0 10px;
            margin: 2px 3px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.25);
            transition: all 0.2s ease;
            min-height: 0;
        }

        /* Hide window module when empty */
        window#waybar.empty #window {
            background: transparent;
            border: none;
            box-shadow: none;
            padding: 0;
            margin: 0;
            min-width: 0;
            min-height: 0;
            opacity: 0;
        }

        /* ---- Workspace buttons – fixed height and consistent border ---- */
        #workspaces button {
            color: ${c.base03};
            background: transparent;
            border: 2px solid transparent;       /* always 2px */
            border-radius: 8px;
            padding: 0 6px;
            margin: 1px 4px;
            transition: all 0.2s ease;
            min-width: 0;
            min-height: 28px;                   /* fixed minimum height */
        }

        /* Occupied but not active */
        #workspaces button:not(.empty):not(.active) {
            color: ${c.base05};
            background: ${wsOccupiedBg};
        }

        /* Active but not focused */
        #workspaces button.active:not(.focused) {
            color: ${c.base07};
            background: ${wsActiveOccupiedBg};
            border-bottom: 2px solid rgba(${rgb "base0A"}, 0.4);
        }

        /* Focused workspace */
        #workspaces button.focused {
            color: ${c.base07};
            background: ${wsActiveBg};
            border: 2px solid ${wsActiveBorder};
            border-radius: 8px;
            padding: 0 6px;
        }

        #workspaces button.urgent {
            color: ${c.base08};
            background: rgba(${rgb "base08"}, 0.25);
            border-bottom: 2px solid ${c.base08};
        }

        /* Module colours */
        #pulseaudio { color: ${c.base07}; }
        #pulseaudio.muted { color: ${c.base0C}; }
        #battery { color: ${c.base0D}; }
        #battery.Charging { color: ${c.base0E}; }
        #battery.warning { color: ${c.base09}; }
        #backlight { color: ${c.base0A}; }
        #network { color: ${c.base0B}; }
        #network.disconnected { color: ${c.base08}; }
        #clock { color: ${c.base07}; }
        #tray { color: ${c.base07}; }
        #language { color: ${c.base0E}; }

        /* Module group spacing */
        .modules-left { margin-left: 8px; }
        .modules-right { margin-right: 8px; }
        .modules-left, .modules-center, .modules-right {
            padding: 0 2px;
        }

        /* Hover effect */
        #workspaces:hover,
        #window:hover,
        #clock:hover,
        #pulseaudio:hover,
        #battery:hover,
        #backlight:hover,
        #network:hover,
        #tray:hover,
        #language:hover,
        #image:hover,
        #custom-notification:hover  {
            background: rgba(${rgb "base01"}, 0.6);
            box-shadow: 0 4px 12px rgba(0,0,0,0.35);
        }

        tooltip {
            background: rgba(${rgb "base00"}, 0.9);
            border: 1px solid ${c.base03};
            border-radius: 8px;
            color: ${c.base07};
        }
        tooltip label { color: ${c.base07}; }
      '';
    };

    stylix.targets.waybar = {
      enableLeftBackColors = false;
      enableCenterBackColors = false;
      enableRightBackColors = false;
      addCss = false;
      background = lib.mkForce null;
      font = "serif";
      fonts.enable = false;
    };
  };
}
