{
  config,
  pkgs,
  ...
}: {
  home.file."${config.xdg.configHome}/fish/config.fish".source = ./config.fish;
  home.persistence."/persist/home/${config.home.username}".directories = [".local/share/fish" ".jump"];
  home.packages = with pkgs; [
    fish
    fishPlugins.done
    jump
    diffnav
    diff-so-fancy
  ];
}
