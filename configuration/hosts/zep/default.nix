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
  services.xserver = {
    # Set DPMS timeouts to zero (any timeouts managed by xidlehook)
    serverFlagsSection = ''
      Option "BlankTime" "0"
      Option "StandbyTime" "0"
      Option "SuspendTime" "0"
      Option "OffTime" "0"
    '';
  };
  systemd.sleep.extraConfig = ''HibernateDelaySec=30min''; # time after when pc will hibernate when using systemctl suspend-then-hibernate
  hardware.sensor.iio.enable = true;
  hidpi = {
    enable = true;
    dpi = 180;
  };
  services.autorandr.defaultTarget = "zep_240";
  hardware.bluetooth.powerOnBoot = false;
  programs.dconf.enable = true;

  services.asusd = {
    enable = true;
    enableUserService = true;
  };
}
