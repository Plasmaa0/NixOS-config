{
  inputs,
  pkgs,
  lib,
  hidpiScalingFactor,
  ...
}: let
  theme = import ./themes/dark/anime.nix;
in {
  imports = [
    inputs.stylix.homeManagerModules.stylix
    ./themes/generate-preview.nix
  ];
  stylix = {
    enable = true;
    autoEnable = true;
    image = ./wallpapers/${theme.wallpaper};
    targets = {
      i3.enable = false;
      helix.enable = false;
    };
    imageScalingMode = "fill";
    inherit (theme) polarity;
    base16Scheme =
      lib.mkIf (lib.elem "scheme" (lib.attrNames theme))
      "${pkgs.base16-schemes}/share/themes/${theme.scheme}.yaml";
    # see also common/fonts.nix
    fonts = {
      serif = {
        package = pkgs.nerd-fonts.iosevka-term-slab;
        name = "IosevkaTermSlab";
      };
      sansSerif = {
        package = pkgs.nerd-fonts.arimo;
        name = "Arimo";
      };
      monospace = {
        package = pkgs.nerd-fonts.iosevka;
        name = "Iosevka";
      };
      emoji = {
        package = pkgs.openmoji-color;
        name = "OpenMoji Color";
      };
      sizes = {
        applications = 12 * hidpiScalingFactor;
        desktop = 10 * hidpiScalingFactor;
        popups = 10 * hidpiScalingFactor;
        terminal = 10 * hidpiScalingFactor;
      };
    };
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 34;
    };
  };
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      serif = ["IosevkaTermSlab"];
      sansSerif = ["Arimo"];
      monospace = ["Iosevka"];
      emoji = ["OpenMoji Color"];
    };
  };
  gtk.iconTheme = {
    package = pkgs.papirus-icon-theme;
    name = "Papirus-Dark";
  };
}
