{...}: {
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # Enable networking
  networking.networkmanager = {
    enable = true;
    wifi.powersave = true;
  };
  services.v2raya.enable = true;
  environment.persistence."/persist" = {
    directories = ["/etc/v2raya"];
  };
}
