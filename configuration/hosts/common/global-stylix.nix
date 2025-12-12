{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: let
  theme = import ./../../themes/dark/monokai.nix;
  recolor = false;
  gowall-recolored-wallpaper = pkgs.callPackage ./modules/gowall-recolor-wallpaper.nix {
    colorsList = config.lib.stylix.colors.withHashtag.toList;
    inputImage = ./../../wallpapers/${theme.wallpaper};
  };
  wallpaper-path =
    if recolor
    then "${gowall-recolored-wallpaper}/default"
    else ./../../wallpapers/${theme.wallpaper};
in {
  imports = [inputs.stylix.nixosModules.stylix];
  stylix = {
    enable = true;
    autoEnable = true;
    image = wallpaper-path;
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
        package = pkgs.nerd-fonts.iosevka-term-slab;
        name = "IosevkaTermSlab Nerd Font";
      };
      sansSerif = {
        package = pkgs.nerd-fonts.iosevka;
        name = "Iosevka Nerd Font";
      };
      monospace = {
        package = pkgs.nerd-fonts.iosevka-term;
        name = "IosevkaTerm Nerd Font";
      };
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
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
    icons = {
      enable = true;
      package = pkgs.papirus-icon-theme;
      dark = "Papirus-Dark";
      light = "Papirus-Light";
    };
  };
}
