{
  pkgs,
  config,
  ...
}: let
  obscure-sddm-theme-package = {
    lib,
    formats,
    stdenvNoCC,
    fetchFromGitHub,
    qt6,
    libsForQt5,
    themeConfig ? null,
  }:
    stdenvNoCC.mkDerivation
    (_: {
      pname = "obscure-sddm-theme";
      version = "1.1";

      src = fetchFromGitHub {
        owner = "saatvik333";
        repo = "obscure-sddm-theme";
        rev = "main";
        hash = "sha256-WMx1SSG1L687ScPSeaZa4FuIoZSdnUidB3n44vyLCwY=";
      };

      propagatedUserEnvPkgs = [
        libsForQt5.qtgraphicaleffects
        libsForQt5.qt5.qtgraphicaleffects
        qt6.qt5compat
        qt6.qtsvg
      ];

      installPhase =
        ''
          mkdir -p $out/share/sddm/themes/obscure
        ''
        + ''
          cp -r * $out/share/sddm/themes/obscure
        ''
        + lib.optionalString (lib.isAttrs themeConfig) ''
          ln -sf ${(formats.ini {}).generate "theme.conf.user" themeConfig} $out/share/sddm/themes/obscure/theme.conf.user
        '';

      meta = {
        description = "A minimal yet customizable SDDM theme that uses IPA (International Phonetic Alphabet) characters for password masking, creating an obscure and unique look for your login experience.";
        homepage = "https://github.com/saatvik333/obscure-sddm-theme";
        license = lib.licenses.mit;
        platforms = lib.platforms.linux;
      };
    });
  obscure-sddm-theme = pkgs.callPackage obscure-sddm-theme-package {
    themeConfig.General = let
      c = config.lib.stylix.colors.withHashtag;
    in {
      textColor = c.base06;
      errorColor = c.base08;
      backgroundColor = c.base01;

      # Background
      backgroundImage = config.stylix.image;
      backgroundFillMode = "aspectCrop"; #aspectCrop, aspectFit, stretch, tile, center
      backgroundOpacity = 1;
      backgroundGlassEnabled = true; # blurring
      backgroundGlassIntensity = 75; # blurring strength 0-100
      backgroundTintColor = c.base02;
      backgroundTintIntensity = 25; # 0-100

      # Typography
      fontFamily = config.stylix.fonts.serif.name;
      baseFontSize = builtins.ceil (24 * config.hidpi.scalingFactor);

      # Controls
      controlCornerRadius = 30; # Corner radius for inputs, selectors, and power buttons
      controlOpacity = 0.75; # Single accent color driving button fills/borders
      controlBlurEnabled = true;
      controlBlurIntensity = 75;
      controlAccentColor = c.base03; # Base opacity controlling control fill/border strength
      allowEmptyPassword = false; # Permit logging in without a password
      showUserSelector = false; # Show user selection carousel by default
      showSessionSelector = false; # Show session selection carousel by default
      randomizePasswordMask = false; # Shuffle IPA mask characters each keystroke
      autoFocusPassword = true;
      animationDuration = 320; # Base animation length in milliseconds
      passwordFlashLoops = 3; # How many times the password field flashes on error
      passwordFlashOnDuration = 200; # Duration of each flash highlight (ms)
      passwordFlashOffDuration = 260; # Duration of the fade-out between flashes (ms)
    };
  };
in {
  services.displayManager.sddm = {
    enable = true;
    theme = "${obscure-sddm-theme}/share/sddm/themes/obscure";
    extraPackages = with pkgs; [
      qt6.qt5compat
      qt6.qtsvg
    ];
  };
  services.xserver = {
    enable = true;
    displayManager.session = [
      {
        manage = "window";
        name = "home-manager";
        start = ''
          ${pkgs.runtimeShell} $HOME/.hm-xsession &
          waitPID=$!
        '';
      }
    ];
  };
}
