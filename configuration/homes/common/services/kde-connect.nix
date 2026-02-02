{...}: {
  home.persistence."/persist".directories = [".cache/kdeconnect.app" ".config/kdeconnect"];
  services.kdeconnect = {
    enable = true;
    indicator = true;
  };
}
