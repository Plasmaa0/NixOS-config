{
  pkgs,
  config,
  ...
}: {
  home.packages = [pkgs.prismlauncher];
  home.persistence."/persist/home/${config.home.username}" = {
    directories = [".minecraft" ".local/share/PrismLauncher"];
  };
}
