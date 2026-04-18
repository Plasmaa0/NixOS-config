{dpi, ...}: {
  imports = [./generate-theme-preview.nix];
  stylix.targets = {
    i3.enable = false;
    helix.enable = false;
    qt.enable = true;
  };
  xresources.properties."Xft.dpi" = dpi;
}
