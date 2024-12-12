{ config, ... }:

let
  c = config.lib.stylix.colors;
in 
{
  programs.rofi.enable = true;
  home.file."${config.xdg.configHome}/rofi" = {
    source = ./../dotfiles/rofi;
    recursive = true;
  };
  home.file."${config.xdg.dataHome}/fonts" = {
    source = ./../dotfiles/rofi/fonts;
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
  }
  '';
}
