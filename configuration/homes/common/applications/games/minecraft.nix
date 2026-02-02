{pkgs, ...}: {
  home.packages = with pkgs; [prismlauncher atlauncher];
  home.persistence."/persist" = {
    directories = [".minecraft" ".local/share/PrismLauncher" ".local/share/ATLauncher"];
  };
}
