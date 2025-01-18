{config, ...}: {
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
}
