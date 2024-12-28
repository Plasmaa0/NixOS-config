{config, ...}: {
  services.copyq.enable = true;
  home.persistence."/persist/home/${config.home.username}".directories = [".local/share/copyq"];
}
