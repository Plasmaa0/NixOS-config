{...}: {
  flake.nixosModules.host-enable-niri-support = {
    inputs,
    pkgs,
    ...
  }: {
    imports = [inputs.niri.nixosModules.niri];
    # TEMP (2026-08-24): resurrect libdisplay-info 0.2.0 for niri-flake
    # nixpkgs removed libdisplay-info_0_2 (default is now 0.4, throw alias
    # left behind), but niri-flake hard-asserts version 0.2.0 to match niri's
    # vendored bindings, breaking eval after the lock bump. Upstream fix
    # (sodiboo/niri-flake#1851, PR #1853) is not merged, and our niri pin is
    # already at branch tip, so bumping cannot help yet. Overlay rebuilds the
    # old derivation via overrideAttrs -- 0.2.0 and 0.4.0 have identical
    # deps/patches/mesonFlags, only src differs. Drop once #1853 lands and
    # the niri pin is bumped.
    nixpkgs.overlays = [
      (final: prev: {
        libdisplay-info_0_2 = prev.libdisplay-info.overrideAttrs (old: {
          name = "libdisplay-info-0.2.0";
          version = "0.2.0";
          src = prev.fetchFromGitLab {
            domain = "gitlab.freedesktop.org";
            owner = "emersion";
            repo = "libdisplay-info";
            rev = "0.2.0";
            hash = "sha256-6xmWBrPHghjok43eIDGeshpUEQTuwWLXNHg7CnBUt3Q=";
          };
        });
      })
      inputs.niri.overlays.niri
    ];
    programs.niri = {
      enable = true;
      package = pkgs.niri-unstable;
    };
    services.gnome.gnome-keyring.enable = true;
    programs.seahorse.enable = true;
    environment.systemPackages = with pkgs; [
      nautilus
      #   (runCommandLocal "nautilus-portal" {} ''
      #     mkdir -p $out/share/xdg-desktop-portal/portals
      #     cat > $out/share/xdg-desktop-portal/portals/nautilus.portal <<EOF
      #     [portal]
      #     DBusName=org.gnome.Nautilus
      #     Interfaces=org.freedesktop.impl.portal.FileChooser
      #     EOF
      #   '')
    ];

    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      # wlr.enable = true;
      extraPortals = [
        # pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-gnome
      ];
      config.common.default = ["gnome"];
      # config.common = {
      #   default = ["gtk"];
      #   "org.freedesktop.impl.portal.FileChooser" = "nautilus";
      # };
    };
    security.pam.services.login.enableGnomeKeyring = true;
    security.pam.services.sddm.enableGnomeKeyring = true;
    security.pam.services.gdm.enableGnomeKeyring = true;

    environment.sessionVariables.NIXOS_OZONE_WL = "1";
  };
  flake.homeModules.desktop-window-manager-wayland-niri = {
    inputs,
    config,
    pkgs,
    lib,
    ...
  }: let
    # Stylix colours
    c = config.lib.stylix.colors.withHashtag;
  in {
    imports = [
      ./_binds.nix
      # ./_outputs.nix
      ./_animations.nix
    ];
    home.packages = [pkgs.wdisplays pkgs.wl-mirror];
    home.persistence."/persist".directories = [".local/share/keyrings"];
    home.persistence."/persist".files = [".cache/fuzzel"];
    programs.fuzzel.enable = true;
    programs.swaylock.enable = true;
    services.awww = {
      enable = true;
      package = inputs.awww.packages.${pkgs.stdenv.hostPlatform.system}.awww;
    };
    services.swayidle = let
      seconds = 1;
      minutes = 60 * seconds;
      screen-blank-timeout = 15 * minutes;
      lock-after-blank-timeout = 15 * minutes;
      sleep-timeout = 60 * minutes;

      niri-bin = "${pkgs.niri-unstable}/bin/niri";
      loginctl = "${pkgs.systemd}/bin/loginctl";
      systemctl = "${pkgs.systemd}/bin/systemctl";
      swaylock = "${pkgs.swaylock}/bin/swaylock";

      lock-session = pkgs.writeShellScript "lock-session" ''
        ${swaylock} -f
        ${niri-bin} msg action power-off-monitors
      '';

      before-sleep = pkgs.writeShellScript "before-sleep" ''
        ${loginctl} lock-session
      '';
    in {
      enable = true;
      timeouts = [
        {
          timeout = screen-blank-timeout;
          command = "${niri-bin} msg action power-off-monitors";
        }
        {
          timeout = screen-blank-timeout + lock-after-blank-timeout;
          command = "${loginctl} lock-session";
        }
        {
          timeout = sleep-timeout;
          command = "${systemctl} suspend";
        }
      ];
      events = {
        lock = lock-session.outPath;
        before-sleep = before-sleep.outPath;
      };
    };

    programs.niri.settings.prefer-no-csd = true;

    # Startup commands
    programs.niri.settings.spawn-at-startup = [
      {argv = ["nm-applet" "--indicator"];}
      {argv = ["blueman-applet"];}
      {argv = ["asusctl" "slash" "-l" "128" "--mode" "Flux" "-B" "true" "-S" "true" "-s" "false" "-b" "false" "-w" "true"];}
      {
        argv = let
          inherit (builtins) floor fromJSON;
          inherit (lib) toHexString stringLength min max;
          inherit (config.lib.stylix) colors;

          r = fromJSON colors.base03-rgb-r;
          g = fromJSON colors.base03-rgb-g;
          b = fromJSON colors.base03-rgb-b;

          min-val = min (min r g) b;
          max-val = max (max r g) b;
          range = max-val - min-val;

          mid-val = r + g + b - min-val - max-val;

          sat-mid =
            if range == 0
            then 0
            else floor (255.0 * (mid-val - min-val) / range);

          saturate = ch:
            if ch == max-val
            then 255
            else if ch == min-val
            then 0
            else sat-mid;

          sat-r =
            if range == 0
            then 148
            else saturate r;
          sat-g =
            if range == 0
            then 103
            else saturate g;
          sat-b =
            if range == 0
            then 189
            else saturate b;

          pad2 = s:
            if stringLength s == 1
            then "0${s}"
            else s;
          toHex = n: pad2 (toHexString n);

          color = "${toHex sat-r}${toHex sat-g}${toHex sat-b}";
        in ["asusctl" "aura" "effect" "static" "-c" color];
      }
      {argv = ["asusctl" "leds" "set" "low"];}
      {command = ["awww-daemon -l background"];}
      {command = ["awww" "img" config.stylix.image];}
      {argv = [(lib.getExe pkgs.kanshi)];}
      {argv = [(lib.getExe pkgs.xwayland-satellite)];}
      {command = [(lib.getExe pkgs.waybar)];}
      # {command = [(lib.getExe pkgs.mako)];}
      {command = ["${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"];}
      {command = ["${pkgs.gnome-keyring}/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh"];}
    ];

    programs.niri.settings.screenshot-path = "~/Pictures/Screenshots/Screenshot_%Y-%m-%d_%H-%M-%S.png";

    programs.niri.settings.environment = {
      QT_QPA_PLATFORM = "wayland";
      SDL_VIDEODRIVER = "wayland";
      _JAVA_AWT_WM_NONREPARENTING = "1";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      DISPLAY = ":0";
    };

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
        matches = [
          {app-id = "Yad";}
          {app-id = "copyq";}
          {app-id = "QuteTextEdit";}
          {app-id = "feh";}
          {app-id = "simplescreenrecorder";}
          {app-id = "gnome-calculator";}
          {app-id = "org.gnome.Nautilus";}
          {app-id = "blueman-manager";}
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
    ];
    programs.niri.settings.layer-rules = [
      {
        matches = [{namespace = "^wallpaper$";} {namespace = "^background$";} {namespace = "^awww";}];
        place-within-backdrop = true;
      }
    ];
    programs.niri.settings.gestures.hot-corners.enable = false;
    programs.niri.settings.debug = {
      render-drm-device = "/dev/dri/card1";
    };
  };
}
