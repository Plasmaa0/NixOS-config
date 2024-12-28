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
  home.packages = with pkgs; [
    (nerdfonts.override {fonts = ["JetBrainsMono" "Iosevka"];})
    openmoji-color
  ];
  programs.rofi.enable = true;
  home.file."${config.xdg.configHome}/rofi" = {
    source = ./rofi;
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
