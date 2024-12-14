{ config, pkgs, ... }: {
  home.file."${config.xdg.configHome}/fish/config.fish".source = ./config.fish;
  home.packages = with pkgs; [
    fish fishPlugins.done jump
  ];
}
