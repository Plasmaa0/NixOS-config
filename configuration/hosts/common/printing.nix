{pkgs, ...}: {
  services = {
    avahi = {
      enable = true;
      nssmdns4 = true;
      nssmdns6 = true;
      wideArea = false;
      # https://askubuntu.com/questions/1130175/avahi-daemon-uses-excessive-amounts-of-cpu
      extraConfig =
        # ratelimit-interval-usec: Takes an unsigned integer. Sets the per-interface packet rate-limiting interval parameter. Together with ratelimit-burst= this may be used to control the maximum number of packets Avahi will generated in a specific period of time on an interface.
        # ratelimit-burst: Takes an unsigned integer. Sets the per-interface packet rate-limiting burst parameter. Together with ratelimit-interval-usec= this may be used to control the maximum number of packets Avahi will generated in a specific period of time on an interface.
        ''
          [server]
          ratelimit-interval-usec=500000
          ratelimit-burst=500
        '';
    };
    printing = {
      enable = true;
      drivers = [pkgs.hplip];
      startWhenNeeded = true;
      defaultShared = true;
    };
  };
}
