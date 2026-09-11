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
  };

  flake.homeModules.desktop-shell-wayland-noctalia = {
    inputs,
    lib,
    pkgs,
    ...
  }: let
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
    loginBox = output: cx: cy: placement_width: placement_height: {
      type = "login_box";
      inherit output cx cy placement_width placement_height;
      box_width = 810.0;
      box_height = 196.0;
      rotation = 0.0;
      settings = loginBoxSettings;
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
          screen_time_enabled = true;
          screenshot = {
            annotate = true;
            save_to_file = false;
          };
        };

        bar.main = {
          position = "top";
          thickness = 34;
          background_opacity = 0.75;
          radius = 12;
          margin_ends = 40;
          margin_edge = 5;
          margin_opposite_edge = 5;
          padding = 14;
          widget_spacing = 6;
          shadow = true;
          reserve_space = true;

          start = ["control-center" "workspaces" "active_window"];
          center = ["privacy" "notifications" "clock" "media" "audio_visualizer"];
          end = [
            "tray"
            "network"
            "bluetooth"
            "volume"
            "brightness"
            "battery"
            "keyboard_layout"
            "session"
          ];
        };

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

        audio.enable_sounds = true;

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
        };

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
        brightness.monitor."eDP-1" = {
          backend = "backlight";
          backlight_device = "amdgpu_bl1";
        };

        location.auto_locate = true;

        calendar = {
          enabled = true;
          account.personal_google = {
            name = "my-google";
            type = "google";
          };
        };
        control_center.calendar.show_week_numbers = true;

        # Lock screen login-box layout (disabled; kept declarative).
        lockscreen_widgets = {
          enabled = false;
          schema_version = 2;
          widget_order = [
            "lockscreen-login-box@winit"
            "lockscreen-login-box@HDMI-A-1"
            "lockscreen-login-box@eDP-1"
            "lockscreen-login-box@DP-2"
          ];
          grid = {
            cell_size = 16;
            major_interval = 4;
            visible = true;
          };
          widget = {
            "lockscreen-login-box@DP-2" = loginBox "DP-2" 960.0 1098.0 1920.0 1280.0;
            "lockscreen-login-box@HDMI-A-1" = loginBox "HDMI-A-1" 1024.0 970.0 2048.0 1152.0;
            "lockscreen-login-box@eDP-1" = loginBox "eDP-1" 854.0 885.00006103515625 1707.0 1067.0;
            "lockscreen-login-box@winit" = loginBox "winit" 619.0 1317.0 1238.0 1499.0;
          };
        };

        # screen-off 15m -> lock 30m -> lock-and-suspend 60m
        idle = {
          pre_action_fade_seconds = 2.0;
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
