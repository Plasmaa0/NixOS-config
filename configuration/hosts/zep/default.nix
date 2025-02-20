{...}: {
  imports = [
    ./hardware
    ../common
    ../common/modules/steam.nix
    ../common/modules/vial.nix
    ../common/modules/bluetooth.nix
  ];
  hardware.sensor.iio.enable = true;
  hidpi = {
    enable = true;
    dpi = 180;
  };
  hardware.bluetooth.powerOnBoot = false;
  programs.dconf.enable = true;

  services.supergfxd = {
    enable = true;
    settings = {
      supergfxctl-mode = "Integrated";
      gfx-vfio-enable = true;
    };
  };
  services.asusd = {
    enable = true;
    enableUserService = true;
  };
  # services.power-profiles-daemon.enable = true;
  #systemd.services.power-profiles-daemon = {
  #  enable = true;
  #  wantedBy = ["multi-user.target"];
  #};
  hardware.nvidia.powerManagement = {
    enable = true;
    finegrained = true;
  };
  # $ asusctl led-mode sleep-enable false
}
