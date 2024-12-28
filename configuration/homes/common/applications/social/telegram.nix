{
  pkgs,
  config,
  ...
}: {
  home.packages = [pkgs.telegram-desktop];
  home.persistence."/persist/home/${config.home.username}".directories = [".local/share/TelegramDesktop"];
}
