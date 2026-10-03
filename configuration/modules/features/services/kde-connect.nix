{...}: {
  flake.homeModules.service-kde-connect = {lib, ...}: {
    home.persistence."/persist".directories = [".cache/kdeconnect.app" ".config/kdeconnect"];
    services.kdeconnect = {
      # Disabled by default (host `nb`); hosts running Noctalia turn it on.
      enable = lib.mkDefault false;
      indicator = false;
    };
  };
}
