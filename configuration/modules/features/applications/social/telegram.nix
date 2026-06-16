{...}: {
  flake.homeModules.application-social-telegram = {pkgs, ...}: {
    home.packages = [pkgs.telegram-desktop];
    home.persistence."/persist".directories = [".local/share/TelegramDesktop"];
  };
}
