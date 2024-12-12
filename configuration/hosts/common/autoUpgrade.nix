{...}:{
  system.autoUpgrade = {
    enable = true;
    flake = "/etc/nixos";
    flags = [
      "--update-input"
      "nixpkgs nixpkgs-stable home-manager styliix nixvim"
      "-L" # print build logs
    ];
    dates = "daily";
    randomizedDelaySec = "45min";
    allowReboot = true;
  };
}
