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
}
