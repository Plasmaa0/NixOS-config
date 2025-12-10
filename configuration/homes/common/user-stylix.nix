{dpi, ...}: {
  imports = [./generate-theme-preview.nix];
  stylix.targets = {
    i3.enable = false;
    helix.enable = false;
  };
  xresources.properties."Xft.dpi" = dpi;
}
