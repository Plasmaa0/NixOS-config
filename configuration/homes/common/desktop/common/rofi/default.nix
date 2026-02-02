{
  config,
  pkgs,
  hidpiScalingFactor,
  ...
}: {
  home.persistence."/persist" = {
    directories = [".local/share/rofi"];
    files = [".cache/rofi-2.sshcache" ".cache/rofi3.druncache" ".cache/rofi3.filebrowsercache"];
  };
  home.packages = [pkgs.nerd-fonts.jetbrains-mono];
  programs.rofi.enable = true;
  home.file."${config.xdg.configHome}/rofi/launchers" = {
    source = ./rofi/launchers;
    recursive = true;
  };
  home.file."${config.xdg.configHome}/rofi/powermenu" = {
    source = ./rofi/powermenu;
    recursive = true;
  };
  home.file."${config.xdg.configHome}/rofi/colors/stylix_theme.rasi".text = let
    c = config.lib.stylix.colors.withHashtag;
  in ''
    * {
      background: ${c.base00};
      background-alt: ${c.base01};
      foreground: ${c.base05};
      selected: ${c.base06};
      active: ${c.base0D};
      urgent: ${c.base08};
      powermenu-font: "${config.stylix.fonts.serif.name} ${toString (builtins.ceil (config.stylix.fonts.sizes.applications * hidpiScalingFactor))}";
      launcher-font: "${config.stylix.fonts.serif.name} ${toString (builtins.ceil (config.stylix.fonts.sizes.applications * hidpiScalingFactor))}";
    }
  '';
  home.file."Documents/todo" = {
    source = ./rofi/todo;
    recursive = true;
  };
}
