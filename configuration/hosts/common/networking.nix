{...}: {
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # Enable networking
  networking.networkmanager = {
    enable = true;
    wifi.powersave = true;
  };
  programs.amnezia-vpn.enable = true;
}
