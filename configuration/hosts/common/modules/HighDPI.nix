{
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption mkEnableOption types;
  cfg = config.hidpi;
  defaultDpi = 96;
in {
  options.hidpi = {
    enable = mkEnableOption "scaling for hidpi screens";
    dpi = mkOption {
      type = types.int;
      description = "Dpi of screen";
      default = defaultDpi;
      example = 192;
    };
    scalingFactor = mkOption {
      type = types.float;
      description = ''
        Readonly scaling factor calculated from dpi.
        Intended for use in other user-defined programs.
      '';
      readOnly = true;
    };
  };
  config = lib.mkIf cfg.enable (let
    scale = cfg.dpi * 1.0 / defaultDpi;
    dpiScale = defaultDpi * 1.0 / cfg.dpi;
  in {
    hidpi.scalingFactor = scale; # for personal use
    home-manager.extraSpecialArgs = {
      # for personal use for configuring apps which refuse to account for xserver dpi set / envenvironment variables for scaling
      # e.g. rofi, dunst
      hidpiScalingFactor = scale;

      # to insert Xft.dpi into .Xresources in user-stylix.nix
      inherit (cfg) dpi;
    };
    services.xserver.dpi = cfg.dpi;
    # Scale programs
    environment.variables = {
      GDK_SCALE = toString scale;
      GDK_DPI_SCALE = toString dpiScale;
      _JAVA_OPTIONS = "-Dsun.java2d.uiScale=${toString scale}";
    };
  });
}
