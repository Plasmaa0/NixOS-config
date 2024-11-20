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
    $highlight: #${config.lib.stylix.colors.base08};

    $critical_frame_color: #${config.lib.stylix.colors.base08};
    $critical_background: #${config.lib.stylix.colors.base0F};
    $critical_foreground: #${config.lib.stylix.colors.base00};

    $normal_frame_color: #${config.lib.stylix.colors.base0B};
    $normal_background: #${config.lib.stylix.colors.base0B};
    $normal_foreground: #${config.lib.stylix.colors.base01};

    $low_frame_color: #${config.lib.stylix.colors.base05};
    $low_background: #${config.lib.stylix.colors.base01};
    $low_foreground: #${config.lib.stylix.colors.base06};

    $base00:#${config.lib.stylix.colors.base00};
    $base01:#${config.lib.stylix.colors.base01};
    $base02:#${config.lib.stylix.colors.base02};
    $base03:#${config.lib.stylix.colors.base03};
    $base04:#${config.lib.stylix.colors.base04};
    $base05:#${config.lib.stylix.colors.base05};
    $base06:#${config.lib.stylix.colors.base06};
    $base07:#${config.lib.stylix.colors.base07};
    $base08:#${config.lib.stylix.colors.base08};
    $base09:#${config.lib.stylix.colors.base09};
    $base0A:#${config.lib.stylix.colors.base0A};
    $base0B:#${config.lib.stylix.colors.base0B};
    $base0C:#${config.lib.stylix.colors.base0C};
    $base0D:#${config.lib.stylix.colors.base0D};
    $base0E:#${config.lib.stylix.colors.base0E};
    $base0F:#${config.lib.stylix.colors.base0F};
  '';
}
