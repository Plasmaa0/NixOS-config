{...}: {
  # System-side bits for the Noctalia shell (zep only). The shell itself is a
  # user service started by niri; this only wires up shared system facilities.
  flake.nixosModules.host-enable-noctalia-support = {lib, ...}: {
    # Prebuilt noctalia binaries; nixConfig in flake.nix may be ignored as
    # untrusted, so set the substituter at the system level too.
    nix.settings = {
      extra-substituters = ["https://noctalia.cachix.org"];
      extra-trusted-public-keys = [
        "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      ];
    };

    # Noctalia's bluetooth widget replaces blueman entirely. `bluetooth.nix`
    # enables blueman globally; force it off on hosts that run Noctalia.
    services.blueman.enable = lib.mkForce false;

    # ddcutil (external-monitor brightness) needs the i2c device nodes.
    hardware.i2c.enable = true;
  };

  flake.homeModules.desktop-shell-wayland-noctalia = {
    inputs,
    lib,
    pkgs,
    ...
  }: let
    # Same derivation the `cli-utils-elio` module installs.
    elio = pkgs.callPackage ../cli/utils/elio/_elio_package.nix {};
    loginBoxSettings = {
      background_color = "surface_variant";
      background_opacity = 0.88;
      background_radius = 12.0;
      center_password_text = false;
      input_opacity = 1.0;
      input_radius = 6.0;
      layout = "regular";
      show_caps_lock = true;
      show_keyboard_layout = true;
      show_login_button = true;
      show_media = true;
      show_session_buttons = true;
      show_unlock_hint = true;
      show_weather = true;
    };
    loginBox = {
      output,
      cx,
      cy,
      placement_width,
      placement_height,
      settings ? {},
    }: {
      type = "login_box";
      inherit output cx cy placement_width placement_height;
      box_width = 810.0;
      box_height = 196.0;
      rotation = 0.0;
      settings = loginBoxSettings // settings;
    };
  in {
    imports = [inputs.noctalia.homeModules.default];

    programs.noctalia = {
      enable = true;

      # NOTE: theme/palette/mode/font/wallpaper are supplied by Stylix's
      # automatic `noctalia` target. Do not set those keys here.
      settings = {
        shell = {
          settings_show_advanced = true;
          niri_overview_type_to_launch_enabled = true;
          clipboard_enabled = true;
          password_style = "random";
          polkit_agent = true;
          screen_time_enabled = true;
          panel = {
            control_center_position = "top_right";
            open_near_click_control_center = true;
            open_near_click_session = true;
          };
          screenshot = {
            annotate = true;
            remember_last_region = true;
            save_to_file = false;
          };
        };

        bar.main = {
          position = "top";
          thickness = 34;
          background_opacity = 0.85;
          radius = 12;
          margin_ends = 120;
          margin_edge = 0;
          padding = 14;
          widget_spacing = 6;
          shadow = true;
          reserve_space = true;

          start = ["control-center" "workspaces" "active_window"];
          center = ["privacy" "caffeine" "notifications" "clock" "media" "audio_visualizer"];
          end = [
            "tray"
            "udiskie"
            "network"
            "bluetooth"
            "group:quick"
            "volume"
            "brightness"
            "battery"
            "keyboard_layout"
            "session"
          ];

          # Collapsed to the icon-only niri-displays anchor, unfolding printers +
          # phone while hovered. `direction = "start"` renders the anchor at the
          # capsule's trailing edge: the `end` lane is right-justified, so that
          # edge is fixed and the anchor stays under the pointer while the other
          # members unfold to its left.
          capsule_group = [
            {
              id = "quick";
              members = ["niri-displays" "printers" "phone"];
              accordion = true;
              accordion_direction = "start";
            }
          ];
        };

        # Community plugins. Sources are seeded to the built-in `official` +
        # `community` git sources when `[[plugins.source]]` is absent.
        plugins.enabled = [
          "aristides/udiskie"
          "andrewdems/printers"
          "icefish/phone-operate"
          "raycursive/niri-displays"
        ];

        widget.clock = {
          format = "{:%d-%m-%Y %H:%M}";
          anchor = true;
        };
        widget."control-center" = {
          custom_image = "${pkgs.nixos-icons}/share/icons/hicolor/256x256/apps/nix-snowflake.png";
          custom_image_colorize = false;
        };
        widget.media = {
          hide_when_no_media = true;
          show_progress = true;
          title_scroll = "always";
        };
        widget.keyboard_layout.display = "short";
        widget.network.show_label = false;
        widget.privacy.hide_inactive = true;

        # Plugin-provided bar widgets; the keys must match the names used in
        # the `bar.main` lists above.
        widget.udiskie = {
          type = "aristides/udiskie:status";
          hide_when_empty = true;
        };
        widget.printers.type = "andrewdems/printers:printer";
        # Phone-operate's bar presence: renders its no-device label until a
        # phone is connected; revealed by the `group:quick` accordion.
        widget.phone.type = "icefish/phone-operate:status";
        # Icon only: the port/name/resolution labels take too much bar space.
        widget.niri-displays = {
          type = "raycursive/niri-displays:bar";
          show_resolution = false;
        };

        # Plugin-level settings live at the top level, not under `plugins`.
        # Keeps the file manager the removed udiskie daemon used to open.
        plugin_settings."aristides/udiskie".file_manager_cmd = "${pkgs.kitty}/bin/kitty -e ${elio}/bin/elio";

        audio.enable_sounds = true;
        battery.warning_threshold = 20;

        # Inert while Stylix pins `theme.source = "custom"`, but synced so
        # switching source later keeps these choices.
        theme = {
          builtin = "Noctalia";
          community_palette = "Oxocarbon";
          wallpaper_scheme = "m3-content";
        };

        notification = {
          enable_daemon = true;
          position = "top_right";
          layer = "overlay";
          # Stylix writes notification.background_opacity (= 1.0); GUI wins.
          background_opacity = lib.mkForce 0.75;
        };

        # Stylix writes osd.background_opacity (= 1.0); the GUI value wins.
        osd.background_opacity = lib.mkForce 0.75;

        lockscreen.enabled = true;

        # Overview: blurred Noctalia backdrop placed inside niri's overview
        # (see the matching layer-rule in niri.nix).
        backdrop = {
          enabled = true;
          blur_intensity = 0.5;
          tint_intensity = 0.3;
        };

        wallpaper = {
          enabled = true;
          fill_mode = "crop";
        };

        # zep has two backlights (nvidia_0 + amdgpu_bl1); pin the internal
        # panel to its real sysfs device, matching the old brightnessctl script.
        # DDC/CI is enabled for the external monitors.
        brightness = {
          enable_ddcutil = true;
          monitor."eDP-1" = {
            backend = "backlight";
            backlight_device = "amdgpu_bl1";
          };
        };

        location.auto_locate = true;

        calendar = {
          enabled = true;
          account.personal_google = {
            name = "my-google";
            type = "google";
          };
        };
        # Home-tab shortcut row. Declaring the list replaces the built-in
        # default set, so the defaults are repeated here; the control center
        # renders at most six of them, hence `caffeine` is dropped (the bar's
        # `caffeine` widget covers it) to keep the plugin tile visible.
        control_center = {
          calendar.show_week_numbers = true;
          shortcuts = [
            {type = "wifi";}
            {type = "bluetooth";}
            {type = "nightlight";}
            {type = "notification";}
            {type = "power_profile";}
            {type = "icefish/phone-operate:tile";}
          ];
        };

        # Lock screen: login boxes plus a few widgets on the internal panel.
        lockscreen_widgets = {
          enabled = true;
          schema_version = 2;
          widget_order = [
            "lockscreen-widget-0000000000000003"
            "lockscreen-login-box@winit"
            "lockscreen-login-box@HDMI-A-1"
            "lockscreen-login-box@eDP-1"
            "lockscreen-login-box@DP-2"
            "lockscreen-widget-0000000000000001"
            "lockscreen-widget-0000000000000002"
            "lockscreen-widget-0000000000000004"
          ];
          grid = {
            cell_size = 16;
            major_interval = 4;
            visible = true;
          };
          widget = {
            "lockscreen-login-box@DP-2" = loginBox {
              output = "DP-2";
              cx = 960.0;
              cy = 1098.0;
              placement_width = 1920.0;
              placement_height = 1280.0;
            };
            "lockscreen-login-box@HDMI-A-1" = loginBox {
              output = "HDMI-A-1";
              cx = 1024.0;
              cy = 970.0;
              placement_width = 2048.0;
              placement_height = 1152.0;
            };
            "lockscreen-login-box@eDP-1" = loginBox {
              output = "eDP-1";
              cx = 853.5;
              cy = 885.5;
              placement_width = 1707.0;
              placement_height = 1067.0;
              settings.show_media = false;
            };
            "lockscreen-login-box@winit" = loginBox {
              output = "winit";
              cx = 619.0;
              cy = 1317.0;
              placement_width = 1238.0;
              placement_height = 1499.0;
            };

            # eDP-1 widgets: now playing, clock, date, audio visualizer.
            "lockscreen-widget-0000000000000001" = {
              type = "media_player";
              output = "eDP-1";
              cx = 853.5;
              cy = 533.5;
              box_width = 384.0;
              box_height = 176.0;
              placement_width = 1707.0;
              placement_height = 1067.0;
              rotation = 0.0;
              settings = {
                background = true;
                hide_when_no_media = true;
                layout = "horizontal";
              };
            };
            "lockscreen-widget-0000000000000002" = {
              type = "clock";
              output = "eDP-1";
              cx = 853.5;
              cy = 229.5;
              box_width = 688.0;
              box_height = 320.0;
              placement_width = 1707.0;
              placement_height = 1067.0;
              rotation = 0.0;
              settings = {
                background = false;
                clock_style = "digital";
                format = "{:%H:%M}";
                shadow = true;
              };
            };
            "lockscreen-widget-0000000000000003" = {
              type = "audio_visualizer";
              output = "eDP-1";
              cx = 861.5;
              cy = 675.5;
              box_width = 800.0;
              box_height = 80.0;
              placement_width = 1707.0;
              placement_height = 1067.0;
              rotation = 0.0;
              settings = {
                background = false;
                bands = 64;
                color_1 = "primary";
                color_2 = "primary";
                mirrored = true;
                reversed = false;
                show_when_idle = false;
              };
            };
            "lockscreen-widget-0000000000000004" = {
              type = "clock";
              output = "eDP-1";
              cx = 853.5;
              cy = 389.5;
              box_width = 0.0;
              box_height = 0.0;
              placement_width = 1707.0;
              placement_height = 1067.0;
              rotation = 0.0;
              settings = {
                background = false;
                format = "{:%d %B}";
              };
            };
          };
        };

        # screen-off 15m -> lock 30m -> lock-and-suspend 60m
        idle = {
          pre_action_fade_seconds = 10.0;
          behavior_order = ["screen-off" "lock" "suspend"];
          behavior = {
            "screen-off" = {
              timeout = 900;
              action = "screen_off";
              enabled = true;
            };
            lock = {
              timeout = 1800;
              action = "lock";
              enabled = true;
            };
            suspend = {
              timeout = 3600;
              action = "lock_and_suspend";
              enabled = true;
            };
          };
        };
      };
    };

    # Noctalia shells out to `ddcutil` for external-monitor brightness; the
    # rest are runtime dependencies of the enabled plugins.
    home.packages = [
      pkgs.ddcutil
      pkgs.udiskie # aristides/udiskie: `udiskie` + `udiskie-info`
      pkgs.sshfs # icefish/phone-operate: SFTP browse
      pkgs.glib.bin # icefish/phone-operate: `gdbus`
    ];

    # icefish/phone-operate: kdeconnectd + kdeconnect-cli.
    services.kdeconnect.enable = true;

    # Zep-scoped disables: these modules are still imported by the shared
    # plasmaa0 profile, so force them off only where Noctalia takes over.
    programs.waybar.enable = lib.mkForce false;
    services.swaync.enable = lib.mkForce false;
    services.cliphist.enable = lib.mkForce false;
    services.flameshot.enable = lib.mkForce false;

    # Noctalia persists UI changes to its state dir; keep them across the
    # impermanent /home.
    home.persistence."/persist".directories = [
      ".local/state/noctalia"
      ".local/share/noctalia"
    ];
  };
}
