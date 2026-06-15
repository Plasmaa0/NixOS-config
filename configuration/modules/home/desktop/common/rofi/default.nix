{...}: let
  module = {
    config,
    pkgs,
    ...
  }: {
    programs.rofi = {
      enable = true;
      cycle = true;
      pass = {
        enable = true;
      };
      extraConfig = {
        modi = "run,drun,window,ssh,combi";
      };
      font = "${config.stylix.fonts.serif.name} 12";
    };
    xdg.configFile."rofi/config.rasi".source = ./rofi/config.rasi;
    xdg.configFile."rofi/launchers".source = ./rofi/launchers;
    xdg.configFile."rofi/powermenu".source = ./rofi/powermenu;
    xdg.configFile."rofi/todo".source = ./rofi/todo;
  };
in {
  flake.homeModules.desktop = module;
}
