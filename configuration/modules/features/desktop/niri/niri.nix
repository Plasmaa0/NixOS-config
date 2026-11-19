{...}: {
  flake.nixosModules.host-enable-niri-support = {
    inputs,
    pkgs,
    ...
  }: {
    imports = [inputs.niri.nixosModules.niri];
    nixpkgs.overlays = [inputs.niri.overlays.niri];
    programs.niri = {
      enable = true;
      package = pkgs.niri-unstable;
    };
    services.gnome.gnome-keyring.enable = true;
    programs.seahorse.enable = true;
    environment.systemPackages = [pkgs.nautilus];

    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gnome
      ];
      config = {
        common.default = ["gnome"];
        niri = {
          default = ["gnome"];
          "org.freedesktop.impl.portal.FileChooser" = ["elio"];
        };
      };
    };
    security.pam.services.login.enableGnomeKeyring = true;
    security.pam.services.sddm.enableGnomeKeyring = true;
    security.pam.services.gdm.enableGnomeKeyring = true;

    environment.sessionVariables.NIXOS_OZONE_WL = "1";
  };
  flake.homeModules.desktop-window-manager-wayland-niri = {
    config,
    pkgs,
    lib,
    ...
  }: let
    # Stylix colours
    c = config.lib.stylix.colors.withHashtag;
    sessionEnv = {
      DISPLAY = ":0";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      QT_QPA_PLATFORM = "wayland";
      _JAVA_AWT_WM_NONREPARENTING = "1";
    };
  in {
    imports = [
      ./_binds.nix
      # ./_outputs.nix
      ./_animations.nix
    ];
    home.packages = [pkgs.wdisplays pkgs.wl-mirror];
    home.persistence."/persist".directories = [".local/share/keyrings"];
    # waybar / swaync / fuzzel / swaylock / swayidle are superseded by Noctalia
    # (see the force-disables in the Noctalia module).

    programs.niri.settings.prefer-no-csd = true;

    # Startup commands
    programs.niri.settings.spawn-at-startup = [
      {argv = ["noctalia"];}
      {argv = ["asusctl" "slash" "-l" "128" "--mode" "Flux" "-B" "true" "-S" "true" "-s" "false" "-b" "false" "-w" "true"];}
      {
        argv = [
          "asusctl"
          "aura"
          "effect"
          "static"
          "-c"
          (import ../_aura-color.nix {
            inherit lib;
            colors = config.lib.stylix.colors;
          })
        ];
      }
      {argv = ["asusctl" "leds" "set" "low"];}
      {argv = [(lib.getExe pkgs.kanshi)];}
      {argv = [(lib.getExe pkgs.xwayland-satellite)];}
      # {command = [(lib.getExe pkgs.mako)];}
      {command = ["${pkgs.gnome-keyring}/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh"];}
    ];

    programs.niri.settings.environment = sessionEnv;

    systemd.user.sessionVariables = sessionEnv;

    # Input configuration
    programs.niri.settings.input = {
      keyboard = {
        xkb = {
          layout = "us,ru";
          options = "grp:alt_shift_toggle";
        };
        repeat-delay = 600;
        repeat-rate = 25;
        numlock = false;
      };
      touchpad = {
        natural-scroll = true;
        tap = true;
        accel-profile = "flat";
        click-method = "clickfinger";
        scroll-method = "two-finger";
      };
      warp-mouse-to-focus = {
        enable = true;
        mode = "center-xy";
      };
      workspace-auto-back-and-forth = true;
      focus-follows-mouse = {
        enable = true;
        max-scroll-amount = "0%";
      };
    };

    # Layout: gaps, borders, focus ring, shadows
    programs.niri.settings.layout = {
      background-color = "transparent";
      gaps = 16;
      center-focused-column = "on-overflow";
      always-center-single-column = true;

      struts.top = -12;
      border = {
        enable = true;
        width = 2;
        active = {color = c.base03;};
        inactive = {color = c.base00;};
        urgent = {color = c.base0F;};
      };

      focus-ring = {
        enable = true;
        width = 2;
        active = {color = c.base03;};
        inactive = {color = c.base02;};
        urgent = {color = c.base0F;};
      };

      shadow = {
        enable = true;
        color = "#00000070";
        softness = 30;
        spread = 5;
        offset = {
          x = 0;
          y = 5;
        };
      };

      default-column-width = {proportion = 0.5;};

      preset-column-widths = [
        {proportion = 2.0 / 3.0;}
        {proportion = 1.0 / 2.0;}
        {proportion = 1.0 / 3.0;}
      ];
    };
    programs.niri.settings.overview = {
      workspace-shadow = {
        enable = true;
        offset = {
          x = 0;
          y = 0;
        };
        softness = 80;
        spread = 20;
        color = "#000000ff";
      };
    };
    programs.niri.settings.hotkey-overlay.skip-at-startup = true;

    # Window rules
    programs.niri.settings.window-rules = [
      {
        matches = [{app-id = "dev.noctalia.Noctalia";}];
        open-floating = true;
        default-column-width = {fixed = 1080;};
        default-window-height = {fixed = 920;};
      }
      {
        matches = [
          {app-id = "Yad";}
          {app-id = "copyq";}
          {app-id = "QuteTextEdit";}
          {app-id = "feh";}
          {app-id = "simplescreenrecorder";}
          {app-id = "gnome-calculator";}
          {app-id = "org.gnome.Nautilus";}
          {title = "Picture in picture";}
        ];
        open-floating = true;
      }
      {
        matches = [
          {title = "Picture in picture";}
        ];
        open-floating = true;
        default-column-width = {proportion = 0.2;};
        default-window-height = {proportion = 0.2;};
      }
      {
        matches = [
          {app-id = "pavucontrol";}
        ];
        default-column-width = {proportion = 0.8;};
        default-window-height = {proportion = 0.8;};
        open-floating = true;
      }
      {
        # icefish/phone-operate casts through scrcpy; keep the mirror window
        # floating and opaque.
        matches = [{app-id = "scrcpy";}];
        open-floating = true;
        opacity = 1.0;
      }
      {
        matches = [
          {
            app-id = "org.telegram.desktop";
            title = "Media viewer";
          }
        ];
        open-fullscreen = false;
        open-floating = true;
        open-maximized = false;
        default-column-width = {proportion = 0.9;};
        default-window-height = {proportion = 0.9;};
        shadow = {
          enable = true;
          softness = 50;
          spread = 5;
          offset = {
            x = 10;
            y = 15;
          };
          color = "#000000cc";
        };
      }
      {
        geometry-corner-radius = {
          bottom-left = 12.0;
          bottom-right = 12.0;
          top-left = 12.0;
          top-right = 12.0;
        };
        # opacity = 0.975; # FIXME
        # background-effect.blur = true; # FIXME
        clip-to-geometry = true;
      }
      {
        matches = [{app-id = "Darktable";}];
        # opacity = 1; # FIXME
        # background-effect.blur = false; # FIXME
      }
      {
        matches = [
          {app-id = "io.github.elio_fm.elio.filechooser";}
          {title = "elio File Chooser";}
        ];
        open-floating = true;
        default-column-width = {proportion = 0.6;};
        default-window-height = {proportion = 0.7;};
      }
    ];
    programs.niri.settings.layer-rules = [
      {
        matches = [{namespace = "^noctalia-backdrop";}];
        place-within-backdrop = true;
      }
    ];
    programs.niri.settings.gestures.hot-corners = {
      top-left = false;
      top-right = false;
      bottom-left = false;
      bottom-right = false;
    };
    programs.niri.settings.debug = {
      render-drm-device = "/dev/dri/card1";
      honor-xdg-activation-with-invalid-serial = true;
    };
  };
}
