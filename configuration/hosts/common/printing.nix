{pkgs, ...}: {
  services = {
    avahi = {
      enable = true;
    };
    printing = {
      enable = true;
      drivers = [pkgs.hplip];
      startWhenNeeded = true;
      defaultShared = true;
    };
  };
}
