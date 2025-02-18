{...}: {
  imports = [
    ./hardware
    ../common
    ../common/modules/steam.nix
    ../common/modules/vial.nix
    ../common/modules/bluetooth.nix
  ];
  hidpi = {
    enable = true;
    dpi = 192;
  };
  hardware.bluetooth.powerOnBoot = false;
  programs.dconf.enable = true;

  services.supergfxctl = {
    enable = true;
    gfx-mode = "Integrated";
    gfx-vfio-enable = true;
  };
  # services.power-profiles-daemon.enable = true;
  systemd.services.power-profiles-daemon = {
    enable = true;
    wantedBy = ["multi-user.target"];
  };
  services.asusctl.enable = true;
  hardware.nvidia.powerManagement = {
    enable = true;
    finegrained = true;
  };
  # $ asusctl led-mode sleep-enable false
}
