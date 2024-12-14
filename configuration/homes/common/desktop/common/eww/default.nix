{
  config,
  pkgs,
  ...
}: let
  c = config.lib.stylix.colors;
in {
  home.packages = with pkgs; [
    pulseaudio
    pavucontrol
    arandr
    brightnessctl
    eww
    playerctl
  ];
  home.file."${config.xdg.configHome}/eww/images" = {
    source = ./eww/images;
    recursive = true;
  };
  home.file."${config.xdg.configHome}/eww/scripts" = {
    source = ./eww/scripts;
    recursive = true;
  };
  home.file."${config.xdg.configHome}/eww/eww.scss".source = ./eww/eww.scss;
  home.file."${config.xdg.configHome}/eww/eww.yuck".source = ./eww/eww.yuck;
  home.file."${config.xdg.configHome}/eww/colors.scss".text = ''
    // Colors //
    $bg: #${c.base00};
    $bg-alt: #${c.base01};
    $active: #${c.base02};
    $borderbg: #${c.base06};
    $fg: #${c.base05};
    $urgent: #${c.base0F};
    $selected: #${c.base0B};
    $highlight: #${c.base08};

    $critical_frame_color: #${c.base08};
    $critical_background: #${c.base0F};
    $critical_foreground: #${c.base00};

    $normal_frame_color: #${c.base0B};
    $normal_background: #${c.base0B};
    $normal_foreground: #${c.base01};

    $low_frame_color: #${c.base05};
    $low_background: #${c.base01};
    $low_foreground: #${c.base06};

    $base00:#${c.base00};
    $base01:#${c.base01};
    $base02:#${c.base02};
    $base03:#${c.base03};
    $base04:#${c.base04};
    $base05:#${c.base05};
    $base06:#${c.base06};
    $base07:#${c.base07};
    $base08:#${c.base08};
    $base09:#${c.base09};
    $base0A:#${c.base0A};
    $base0B:#${c.base0B};
    $base0C:#${c.base0C};
    $base0D:#${c.base0D};
    $base0E:#${c.base0E};
    $base0F:#${c.base0F};

    $yellow:#${c.base0A};
    $blue:#${c.base0D};
  '';
}
