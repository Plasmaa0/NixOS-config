{
  config,
  inputs,
  pkgs,
  lib,
  ...
}: let
  theme = import ./../../themes/dark/kyoto.nix;
in {
  imports = [inputs.stylix.nixosModules.stylix];
  stylix = {
    enable = true;
    autoEnable = true;
    image = ./../../wallpapers/${theme.wallpaper};
    targets = {
      plymouth.enable = false;
    };
    imageScalingMode = "fill";
    inherit (theme) polarity;
    base16Scheme =
      lib.mkIf (lib.elem "scheme" (lib.attrNames theme))
      "${pkgs.base16-schemes}/share/themes/${theme.scheme}.yaml";
    # stylix font config
    # see also common/fonts.nix
    fonts = {
      serif = {
        package = pkgs.nerd-fonts.fantasque-sans-mono;
        name = "FantasqueSansM Nerd Font";
      };
      sansSerif = {
        package = pkgs.nerd-fonts.arimo;
        name = "Arimo";
      };
      monospace = {
        package = pkgs.nerd-fonts.iosevka-term;
        name = "IosevkaTerm Nerd Font";
      };
      emoji = {
        package = pkgs.openmoji-color;
        name = "OpenMoji Color";
      };
      sizes = {
        applications = 12 * config.hidpi.scalingFactor;
        desktop = 10 * config.hidpi.scalingFactor;
        popups = 10 * config.hidpi.scalingFactor;
        terminal = 10 * config.hidpi.scalingFactor;
      };
    };
    cursor = {
      package = pkgs.bibata-cursors;
      name = let
        suffix =
          if theme.polarity == "dark"
          then "Ice"
          else "Classic";
      in "Bibata-Modern-${suffix}";
      size = 34;
    };
  };
}
