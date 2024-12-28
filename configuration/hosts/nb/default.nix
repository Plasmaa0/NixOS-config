{...}: {
  imports = [
    ./hardware
    ../common
    ../common/modules/steam.nix
    ../common/modules/vial.nix
    ../common/modules/HighDPI.nix
    ../common/modules/bluetooth.nix
  ];
  hardware.bluetooth.powerOnBoot = false;
  programs.dconf.enable = true;
}
