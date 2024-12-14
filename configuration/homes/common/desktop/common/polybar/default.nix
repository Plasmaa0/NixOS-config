{ config, pkgs, ... }: {
  programs.polybar.enable = true;
  # services.polybar.enable = true;
  services.polybar.package = (pkgs.polybar.override {
    alsaSupport = true;
    i3Support = true;
    pulseSupport = true;
  });
  home.file."${config.xdg.configHome}/polybar" = {
    source = ./polybar;
    recursive = true;
  };
  services.polybar.script = "polybar &";
  systemd.user.services.polybar = {
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
