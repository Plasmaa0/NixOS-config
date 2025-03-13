{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [prismlauncher atlauncher];
  home.persistence."/persist/home/${config.home.username}" = {
    directories = [".minecraft" ".local/share/PrismLauncher" ".local/share/ATLauncher"];
  };
}
