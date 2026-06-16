{...}: let
  module = {pkgs, ...}: {
    home.packages = [pkgs.rofi];
    xdg.configFile."rofi/config.rasi".source = ./rofi/config.rasi;
    xdg.configFile."rofi/launchers".source = ./rofi/launchers;
    xdg.configFile."rofi/powermenu".source = ./rofi/powermenu;
    xdg.configFile."rofi/todo".source = ./rofi/todo;
  };
in {
  flake.homeModules.desktop-launcher-x11-rofi = module;
}
