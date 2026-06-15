{...}: {
  flake.homeModules.services = {...}: {
    home.persistence."/persist".directories = [".cache/kdeconnect.app" ".config/kdeconnect"];
    services.kdeconnect = {
      enable = false;
      indicator = false;
    };
  };
}
