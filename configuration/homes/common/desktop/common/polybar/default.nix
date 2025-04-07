{
  config,
  pkgs,
  lib,
  ...
}: let
  polybar = pkgs.polybar.override {
    alsaSupport = true;
    i3Support = true;
    pulseSupport = true;
  };
in {
  home.file."${config.xdg.configHome}/polybar" = {
    source = ./polybar;
    recursive = true;
    onChange = "${polybar}/bin/polybar-msg cmd restart || true";
  };
  xsession.windowManager.i3.config.startup = [
    {
      notification = false;
      always = true;
      command = "${polybar}/bin/polybar-msg cmd restart || true";
    }
  ];
  services.polybar = {
    enable = true;
    script = "polybar &";
    package = polybar;
  };
  systemd.user.services.polybar = {
    # Install.WantedBy = ["graphical-session.target"];
    Service = {
      Restart = lib.mkForce "always";
      RestartSec = 3;
    };
  };
}
