{config, ...}:{
  home.file."${config.xdg.configHome}/eww/images" = {
    source = ./../dotfiles/eww/images;
    recursive = true;
  };
  home.file."${config.xdg.configHome}/eww/scripts" = {
    source = ./../dotfiles/eww/scripts;
    recursive = true;
  };
  home.file."${config.xdg.configHome}/eww/eww.scss" = {
    source = ./../dotfiles/eww/eww.scss;
  };
  home.file."${config.xdg.configHome}/eww/eww.yuck" = {
    source = ./../dotfiles/eww/eww.yuck;
  };
  home.file."${config.xdg.configHome}/eww/colors.scss".text = ''
    // Colors //
    $bg: #${config.lib.stylix.colors.base00};
    $bg-alt: #${config.lib.stylix.colors.base01};
    $active: #${config.lib.stylix.colors.base02};
    $borderbg: #${config.lib.stylix.colors.base06};
    $fg: #${config.lib.stylix.colors.base05};
    $urgent: #${config.lib.stylix.colors.base0F};
    $selected: #${config.lib.stylix.colors.base0B};
  '';
}