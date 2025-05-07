{pkgs, ...}: {
  services = {
    avahi = {
      enable = true;
      nssmdns4 = true;
      nssmdns6 = true;
    };
    printing = {
      enable = true;
      drivers = [pkgs.hplip];
      startWhenNeeded = true;
      defaultShared = true;
    };
  };
}
