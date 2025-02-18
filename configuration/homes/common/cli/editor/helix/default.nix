{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./theme.nix
    ./settings
    ./languages
  ];
  home.persistence."/persist/home/${config.home.username}".directories = [".cache/helix"];
  programs.helix = {
    enable = true;
    defaultEditor = true;
  };
  home.activation.helix_reload = lib.hm.dag.entryAfter ["writeBoundary"] ''
    run ${pkgs.procps}/bin/pkill -USR1 hx || true
  '';
}
