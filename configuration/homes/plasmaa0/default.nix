{
  pkgs,
  config,
  ...
}: let
  # to look for proper names of apps
  # ls $(echo $XDG_DATA_DIRS | tr ":" "\n")/applications 2>/dev/null | grep <name>
  mimeapps = {
    "application/pdf" = ["org.pwmt.zathura.desktop"];
  };
in {
  imports = [
    ../common
    ../common/desktop/i3
    ../common/cli
    ../common/dev
    ../common/applications
    ../common/services
    ../common/services/poweralertd.nix
    ../common/services/autorandr.nix
  ];

  home.packages = with pkgs; [
    spaceFM
    networkmanagerapplet
    upower
    poweralertd
    xorg.xbacklight
    brightnessctl
    feh
    arandr
    pulseaudio
    pavucontrol
    gparted
    # yandex-music
    cassette
    qbittorrent
    libreoffice
    xarchiver
    # cider
    # i3wsr # i3 workspace names
  ];

  xdg = {
    enable = true;
    mime.enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = mimeapps;
      associations.added = mimeapps;
    };
  };

  home.persistence."/persist/home/${config.home.username}" = {
    allowOther = true;
    directories = [
      "infa"
      "uni"
      "games"
      "home-manager"
    ];
  };
}
