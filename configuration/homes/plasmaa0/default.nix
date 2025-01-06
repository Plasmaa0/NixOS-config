{
  pkgs,
  config,
  ...
}: {
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
    chromium
    # yandex-music
    cassette
    qbittorrent
    libreoffice
    xarchiver
    # cider
    # i3wsr # i3 workspace names
  ];

  mime.enable = true;

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
