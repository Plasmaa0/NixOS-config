{...}: {
  # Noctalia Greeter (greetd-based) with a declarative Stylix appearance.
  # Replaces `greetd.nix` (tuigreet) on zep. `greetd.nix` is intentionally left
  # on disk but must not be imported together with this module.
  flake.nixosModules.greetd-noctalia = {
    inputs,
    config,
    lib,
    pkgs,
    ...
  }: let
    # Same base16 -> Noctalia role mapping Stylix uses for the shell, so the
    # greeter and the desktop share one palette.
    c = config.lib.stylix.colors.withHashtag;
    palette = with c; {
      primary = base0D;
      on_primary = base00;
      secondary = base0E;
      on_secondary = base00;
      tertiary = base0C;
      on_tertiary = base00;
      error = base08;
      on_error = base00;
      surface = base00;
      on_surface = base05;
      surface_variant = base01;
      on_surface_variant = base04;
      outline = base03;
      shadow = base00;
      hover = base0C;
      on_hover = base00;
    };
  in {
    imports = [inputs.noctalia-greeter.nixosModules.default];

    programs.noctalia-greeter = {
      enable = true;
      # Authenticated sync (greeter < 1.5.0 has no passwordless action).
      passwordless-sync-users = lib.mkDefault [];

      # eDP-1 advertises every mode at 240 Hz except 2560x1600@60, and the
      # greeter's wlroots compositor picks the *highest* refresh at the
      # preferred size. The amdgpu atomic test for 2560x1600@240 fails
      # ("Cannot allocate memory"), so the internal panel stays black and a
      # standalone boot cannot log in. Cap the mode search at 60 Hz (niri has no
      # such problem); outputs whose only modes are >60 Hz keep their preferred
      # mode. Patch the greeter rather than the compositor config because the
      # config has no refresh knob.
      package = inputs.noctalia-greeter.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs (old: {
        postPatch =
          (old.postPatch or "")
          + ''
            substituteInPlace src/compositor/noctalia_compositor.c \
              --replace-fail \
              'if (mode->refresh > best->refresh) {' \
              'if (mode->refresh <= 60000 && (best->refresh > 60000 || mode->refresh > best->refresh)) {'
          '';
      });

      settings = {
        session.default = "Niri";
        user.default = "plasmaa0";

        appearance = {
          scheme = "Synced";
          theme_mode = config.stylix.polarity;
          font_family = config.stylix.fonts.sansSerif.name;
          inherit palette;
          wallpaper = {
            path = config.stylix.image;
            fill_mode = "crop";
          };
        };

        cursor = {
          theme = config.stylix.cursor.name;
          size = config.stylix.cursor.size;
          path = "${config.stylix.cursor.package}/share/icons";
        };

        keyboard = {
          layout = "us,ru";
          options = "grp:alt_shift_toggle";
        };
      };
    };

    # zep is hybrid NVIDIA (card0, HDMI-A-1) + AMD (card1, internal eDP-1 and
    # DP-2). wlroots' atomic backend performs a real `TEST_ONLY` commit for
    # outputs on the primary GPU, and the AMD eDP-1 atomic check fails with
    # ENOMEM (niri's real commit is fine). The legacy KMS interface has no such
    # test (`legacy_crtc_test` only checks buffer size) and modesets eDP-1 via
    # drmModeSetCrtc, so force it with WLR_DRM_NO_ATOMIC and restrict the
    # greeter to the AMD GPU (the one that drives eDP-1). The multi-GPU path is
    # avoided entirely: with NVIDIA as primary the greeter fails format picking
    # ("Failed to pick primary buffer format"), and with AMD primary the
    # atomic test fails. The HDMI greeter is therefore not driven; it works
    # again once niri starts.
    services.greetd.settings.default_session.command = lib.mkForce (
      "${lib.getExe' pkgs.coreutils "env"} "
      + "WLR_DRM_DEVICES=/dev/dri/card1 "
      + "WLR_DRM_NO_ATOMIC=1 "
      + "${lib.getExe' config.programs.noctalia-greeter.package "noctalia-greeter-session"} --"
    );

    # Keep session choices and synced appearance across the impermanent root.
    environment.persistence."/persist".directories = [
      {
        directory = "/var/lib/noctalia-greeter";
        user = "greeter";
        group = "greeter";
        mode = "0750";
      }
    ];
  };
}
