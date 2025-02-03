{...}: {
  hardware.bluetooth = {
    enable = true;
    settings.General = {
      Experimental = true;
      FastConnectable = true;
    };
  };
  services.blueman.enable = true;
}
