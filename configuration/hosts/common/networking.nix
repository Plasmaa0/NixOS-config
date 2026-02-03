{pkgs, ...}: {
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # Enable networking
  networking.networkmanager = {
    enable = true;
    wifi.powersave = true;
    plugins = with pkgs; [
      networkmanager-openvpn
    ];
  };
  programs.openvpn3.enable = true;
  services.v2raya.enable = true;
  environment.persistence."/persist" = {
    directories = ["/etc/v2raya"];
  };
}
