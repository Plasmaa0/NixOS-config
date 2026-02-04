{...}: {
  nix = {
    optimise.automatic = true;
    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      dates = "monthly";
      options = "--delete-older-than 30d";
      randomizedDelaySec = "15min";
    };
  };
}
