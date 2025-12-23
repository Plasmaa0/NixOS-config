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
  ];

  home.packages = with pkgs; [
    networkmanagerapplet
    upower
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
    simplescreenrecorder
    gimp
    darktable
    mindustry
    nvtopPackages.full
    aria2
    heroic
    kdePackages.dolphin
    pandoc
    tealdeer # a very fast version of tldr
    # cider
    # i3wsr # i3 workspace names
  ];

  mime.enable = true;
  mime.list = [
    {
      mimeTypes = ["image/png"];
      handler = pkgs.feh;
    }
  ];

  home.persistence."/persist/home/${config.home.username}" = {
    allowOther = true;
    directories = [
      "infa"
      "uni"
      "games"
      "home-manager" # i put this flake here, dont look that i call it home-manager
      ".local/share/Mindustry"
      ".local/share/qBittorrent"
      ".config/qBittorrent"
      ".config/darktable"
      ".cache/darktable"
      ".cache/tealdeer"
      ".config/libreoffice"
    ];
  };
}
