{...}: {
  flake.homeModules.plasmaa0 = {
    pkgs,
    self,
    ...
  }: {
    imports = [
      self.homeModules.common
      self.homeModules.secrets
      self.homeModules.shell-templates
      self.homeModules.stylix
      self.homeModules.cli
      self.homeModules.desktop
      self.homeModules.applications
      self.homeModules.services
      self.homeModules.dev
    ];

    home.packages = with pkgs; [
      networkmanagerapplet
      upower
      xbacklight
      brightnessctl
      feh
      arandr
      pulseaudio
      pavucontrol
      chromium
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
      simple-scan
      tealdeer
    ];

    mime.enable = true;
    mime.list = [
      {
        mimeTypes = ["image/png"];
        handler = pkgs.feh;
      }
    ];

    home.persistence."/persist" = {
      directories = [
        "infa"
        "uni"
        "games"
        "home-manager"
        ".local/share/Mindustry"
        ".local/share/qBittorrent"
        ".config/qBittorrent"
        ".config/darktable"
        ".cache/darktable"
        ".cache/tealdeer"
        ".config/libreoffice"
      ];
    };
  };
}
