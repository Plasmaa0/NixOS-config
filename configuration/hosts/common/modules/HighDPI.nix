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
    home-manager.extraSpecialArgs = {hidpiScalingFactor = scale;}; # for personal use
    services.xserver.dpi = cfg.dpi;
    # Scale programs
    environment.variables = {
      GDK_SCALE = toString scale;
      GDK_DPI_SCALE = toString dpiScale;
      _JAVA_OPTIONS = "-Dsun.java2d.uiScale=${toString scale}";
    };
  });
}
