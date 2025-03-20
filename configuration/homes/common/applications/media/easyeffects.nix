{
  pkgs,
  config,
  ...
}: {
  services.easyeffects = {
    enable = true;
  };

  # don't start by default
  # override default value which is
  # Install.WantedBy = [ "graphical-session.target" ];
  systemd.user.services.easyeffects.Install.WantedBy = pkgs.lib.mkForce [];
  home.persistence."/persist/home/${config.home.username}" = {
    directories = [".config/easyeffects"];
  };
}
