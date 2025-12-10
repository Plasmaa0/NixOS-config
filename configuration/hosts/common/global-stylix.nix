{
  inputs,
  pkgs,
  lib,
  ...
}: let
  theme = import ./../../themes/dark/simplex.nix;
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
