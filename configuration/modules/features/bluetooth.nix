{...}: {
  flake.nixosModules.bluetooth = {pkgs, ...}: {
    hardware.bluetooth = {
      enable = true;
      settings.General = {
        Experimental = true;
        FastConnectable = true;
        Privacy = "device";
        JustWorksRepairing = "always";
        # ControllerMode = "bredr";
      };
    };
    services.blueman.enable = true;
    # systemd.services.bluetooth.serviceConfig.ExecStart = [
    #   ""
    #   "${pkgs.bluez}/libexec/bluetooth/bluetoothd --noplugin=sap"
    # ];
  };
}
