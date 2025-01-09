{pkgs, ...}: {
  services.easyeffects = {
    enable = true;
  };

  # don't start by default
  # override default value which is
  # Install.WantedBy = [ "graphical-session.target" ];
  systemd.user.services.easyeffects.Install.WantedBy = pkgs.lib.mkForce [];
}
