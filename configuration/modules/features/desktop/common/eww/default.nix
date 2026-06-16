{...}: let
  module = {pkgs, ...}: {
    home.packages = with pkgs; [eww];
    xdg.configFile."eww/eww.yuck".source = ./eww/eww.yuck;
    xdg.configFile."eww/eww.scss".source = ./eww/eww.scss;
    xdg.configFile."eww/colors.scss".source = ./eww/colors.scss;
    xdg.configFile."eww/scripts".source = ./eww/scripts;
    xdg.configFile."eww/images".source = ./eww/images;
  };
in {
  flake.homeModules.desktop-bar-eww = module;
}
