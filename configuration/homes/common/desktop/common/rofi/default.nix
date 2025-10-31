{
  config,
  pkgs,
  ...
}: let
  c = config.lib.stylix.colors;
in {
  home.persistence."/persist/home/${config.home.username}" = {
    directories = [".local/share/rofi"];
    files = [".cache/rofi-2.sshcache" ".cache/rofi3.druncache" ".cache/rofi3.filebrowsercache"];
  };
  home.packages = with pkgs;
    [
      openmoji-color
    ]
    ++ (with pkgs.nerd-fonts; [
      iosevka
      jetbrains-mono
    ]);
  programs.rofi.enable = true;
  home.file."${config.xdg.configHome}/rofi/launchers" = {
    source = ./rofi/launchers;
    recursive = true;
  };
  home.file."${config.xdg.configHome}/rofi/powermenu" = {
    source = ./rofi/powermenu;
    recursive = true;
  };
  home.file."${config.xdg.configHome}/rofi/colors/stylix_theme.rasi".text = ''
    * {
      background: #${c.base00};
      background-alt: #${c.base01};
      foreground: #${c.base05};
      selected: #${c.base06};
      active: #${c.base0D};
      urgent: #${c.base08};
      powermenu-font: "JetBrains Mono Nerd Font ${toString (builtins.ceil config.stylix.fonts.sizes.applications)}";
      launcher-font: "VictorMono NF ${toString (builtins.ceil config.stylix.fonts.sizes.applications)}";
    }
  '';
  home.file."Documents/todo" = {
    source = ./rofi/todo;
    recursive = true;
  };
}
