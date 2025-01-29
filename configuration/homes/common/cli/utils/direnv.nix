{config, ...}: {
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  home.persistence."/persist/home/${config.home.username}" = {
    directories = [".local/share/direnv"];
  };
}
