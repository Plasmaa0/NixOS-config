{
  pkgs,
  config,
  ...
}: {
  home.packages = [pkgs.yandex-music];
  home.persistence."/persist/home/${config.home.username}" = {
    directories = [".config/YandexMusic"];
  };
}
