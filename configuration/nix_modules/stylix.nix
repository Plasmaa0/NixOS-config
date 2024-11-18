{ config, pkgs, ... }:

{
  stylix.enable = true;
  stylix.autoEnable = true;
  stylix.image = ./../wallpapers/monokai.jpg;
  stylix.targets.feh.enable = true;
  stylix.targets.i3.enable = false;
  stylix.targets.helix.enable = false;
  stylix.imageScalingMode = "fill";
  stylix.polarity = "dark";
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/monokai.yaml";  
  # see also common/fonts.nix
  stylix.fonts = {
    serif = {
      package = (pkgs.nerdfonts.override{fonts=["IosevkaTermSlab"];});
      name = "IosevkaTermSlab";
    };
    sansSerif = {
      package = (pkgs.nerdfonts.override{fonts=["Arimo"];});
      name = "Arimo";
    };
    monospace = {
      package = (pkgs.nerdfonts.override{fonts=["Iosevka"];});
      name = "Iosevka";
    };
    emoji = {
      package = pkgs.openmoji-color;
      name = "OpenMoji Color";
    };
  };
  stylix.cursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 36;
  };
  gtk.iconTheme = {
    package = pkgs.papirus-icon-theme;
    name = "Papirus-Dark";
  };
}
