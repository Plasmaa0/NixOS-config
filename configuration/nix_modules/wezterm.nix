{ config, ... }: 

let
  c = config.lib.stylix.colors;
in
{
  programs.wezterm.enable = true;
  home.file."${config.xdg.configHome}/wezterm" = {
    source = ./../dotfiles/wezterm;
    recursive = true;
  };
}