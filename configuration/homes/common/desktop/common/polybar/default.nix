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
  home.file."${config.xdg.configHome}/polybar/colors.ini".text = let
    c = config.lib.stylix.colors.withHashtag;
  in
    # ini
    ''
      [colors]
      background = ${c.base00}
      background-alt = ${c.base01}
      foreground = ${c.base07}
      foreground-alt = ${c.base03}
      primary = ${c.base0A}
      secondary = ${c.base0C}
      alert = ${c.base09}
      disabled = ${c.base02}
      active = ${c.base03}
      blue = ${c.base0D}
      purple = ${c.base0E}
      urgent = ${c.base08}

      underline-1 = ${c.base05}
      underline-2 = ${c.base0D}
    '';
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
