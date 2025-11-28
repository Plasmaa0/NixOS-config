{...}: {
  imports = [
    ./hardware
    ../common
    ../common/modules/steam.nix
    ../common/modules/vial.nix
    ../common/modules/bluetooth.nix
    ../common/modules/ollama.nix
  ];
  security.polkit.enable = true;
  hardware.sensor.iio.enable = true;
  hidpi = {
    enable = true;
    dpi = 180;
  };
  hardware.bluetooth.powerOnBoot = false;
  programs.dconf.enable = true;

  services.asusd = {
    enable = true;
    enableUserService = true;
  };
}
