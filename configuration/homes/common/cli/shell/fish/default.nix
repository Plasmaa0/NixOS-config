{
  config,
  pkgs,
  lib,
  ...
}: {
  home.file."${config.xdg.configHome}/fish/config.fish".source = ./config.fish;
  home.persistence."/persist/home/${config.home.username}".directories = [".local/share/fish" ".jump"];
  home.activation.fish_update_completions = lib.hm.dag.entryAfter ["writeBoundary"] ''
    run ${pkgs.fish}/bin/fish -c fish_update_completions || true
  '';
  home.packages = with pkgs; [
    fish
    fishPlugins.done
    jump
    diffnav
    diff-so-fancy
  ];
}
