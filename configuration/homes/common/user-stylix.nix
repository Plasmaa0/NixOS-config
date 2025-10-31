{
  config,
  pkgs,
  ...
}: {
  imports = [./generate-theme-preview.nix];
  stylix = {
    targets = {
      i3.enable = false;
      helix.enable = false;
    };
  };
  gtk.iconTheme = {
    package = pkgs.papirus-icon-theme;
    name = let
      suffix =
        if config.stylix.polarity == "dark"
        then "Dark"
        else "Light";
    in "Papirus-${suffix}";
  };
}
