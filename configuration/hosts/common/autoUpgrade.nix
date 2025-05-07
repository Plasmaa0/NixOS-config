{...}: {
  system.autoUpgrade = {
    enable = false;
    flake = "/etc/nixos";
    flags = [
      "--update-input"
      "nixpkgs"
      "-L" # print build logs
    ];
    dates = "weekly";
    randomizedDelaySec = "15min";
    allowReboot = false;
  };
}
