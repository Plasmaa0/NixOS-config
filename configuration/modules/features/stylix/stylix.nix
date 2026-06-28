{...}: {
  flake.nixosModules.stylix = {
    inputs,
    pkgs,
    lib,
    config,
    self,
    ...
  }: let
    theme = import ./../../../themes/dark/glass-blue-hexagons.nix;
    recolor = false;
    gowall-recolored-wallpaper = pkgs.callPackage ./_gowall-recolor-wallpaper.nix {
      colorsList = config.lib.stylix.colors.withHashtag.toList;
      inputImage = ./../../../wallpapers/${theme.wallpaper};
    };
    wallpaper-path =
      if recolor
      then "${gowall-recolored-wallpaper}/default"
      else ./../../../wallpapers/${theme.wallpaper};
  in {
    imports = [inputs.stylix.nixosModules.stylix];
    stylix = {
      enable = true;
      autoEnable = true;
      image = wallpaper-path;
      targets = {
        qt.enable = false;
        plymouth.enable = false;
      };
      imageScalingMode = "fill";
      inherit (theme) polarity;
      base16Scheme =
        lib.mkIf (lib.elem "scheme" (lib.attrNames theme))
        "${pkgs.base16-schemes}/share/themes/${theme.scheme}.yaml";
      fonts = {
        serif = {
          package = pkgs.nerd-fonts.iosevka-term-slab;
          name = "IosevkaTermSlab Nerd Font";
        };
        sansSerif = {
          package = pkgs.nerd-fonts.lilex;
          name = "Lilex Nerd Font Propo";
        };
        monospace = {
          package = pkgs.nerd-fonts.lilex;
          name = "Lilex Nerd Font Mono";
        };
        emoji = {
          package = pkgs.noto-fonts-color-emoji;
          name = "Noto Color Emoji";
        };
        sizes.popups = builtins.ceil (config.stylix.fonts.sizes.desktop * 1.5);
      };
      cursor = {
        package = pkgs.bibata-cursors;
        name = let
          suffix =
            if theme.polarity == "dark"
            then "Ice"
            else "Classic";
        in "Bibata-Modern-${suffix}";
        size = 24;
      };
      icons = {
        enable = true;
        package = pkgs.papirus-icon-theme;
        dark = "Papirus-Dark";
        light = "Papirus-Light";
      };
    };

    home-manager.sharedModules = [
      self.homeModules.stylix
    ];
  };
  flake.homeModules.stylix = {dpi, ...}: {
    imports = [./_generate-theme-preview.nix];
    stylix.targets = {
      i3.enable = false;
      helix.enable = false;
      qt.enable = true;
    };
    xresources.properties."Xft.dpi" = dpi;
  };
}
