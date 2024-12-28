{config, ...}: {
  home.persistence."/persist/home/${config.home.username}".directories = [".local/share/flameshot"];
  services.flameshot = {
    enable = true;
    settings = {
      General = {
        uiColor = "#${config.lib.stylix.colors.base02}";
        contrastUiColor = "#${config.lib.stylix.colors.base07}";
        contrastOpacity = 180;
      };
    };
  };
}
