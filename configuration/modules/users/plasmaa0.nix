{...}: {
  flake.homeModules.plasmaa0 = {
    pkgs,
    lib,
    self,
    ...
  }: {
    programs.home-manager.enable = true;
    home.stateVersion = "24.05";
    imports = [
      self.homeModules.stylix
      self.homeModules.cli-utils-common
      self.homeModules.cli-editor-helix
      self.homeModules.cli-editor-markdown-oxide
      self.homeModules.cli-shell-fish
      self.homeModules.cli-shell-starship
      self.homeModules.cli-terminal-alacritty
      self.homeModules.cli-terminal-kitty
      self.homeModules.cli-terminal-wezterm
      self.homeModules.cli-utils-btop
      self.homeModules.cli-utils-direnv
      self.homeModules.cli-utils-fastfetch
      self.homeModules.cli-utils-git
      self.homeModules.cli-utils-yazi
      self.homeModules.desktop-window-manager-x11-i3
      self.homeModules.desktop-util-x11-conky
      self.homeModules.desktop-util-x11-picom
      self.homeModules.desktop-launcher-x11-rofi
      self.homeModules.desktop-bar-eww
      self.homeModules.desktop-bar-x11-polybar
      self.homeModules.desktop-lockscreen-x11-betterlockscreen
      self.homeModules.desktop-notifications-x11-dunst
      self.homeModules.application-util-mime
      self.homeModules.application-browser-helium
      self.homeModules.application-browser-qutebrowser
      self.homeModules.application-editor-vscode
      self.homeModules.application-editor-texstudio
      self.homeModules.application-editor-xournalpp
      self.homeModules.application-games-minecraft
      self.homeModules.application-media-obs
      self.homeModules.application-media-vlc
      self.homeModules.application-media-zathura
      self.homeModules.application-media-easyeffects
      self.homeModules.application-music-rmpc
      self.homeModules.application-music-yandex-music
      self.homeModules.application-music-cassette
      self.homeModules.application-music-mpd
      self.homeModules.application-social-telegram
      self.homeModules.application-utils-mangohud
      self.homeModules.application-utils-gparted
      self.homeModules.service-powertop
      self.homeModules.service-poweralertd
      self.homeModules.service-udiskie
      self.homeModules.service-kde-connect
      self.homeModules.service-flameshot
      self.homeModules.service-copyq
      self.homeModules.dev-python
      self.homeModules.dev-latex
      self.homeModules.dev-typst
    ];

    programs.git.settings = {
      user.name = "Andrey Kuprin";
      user.email = "plasmaa0@gmail.com";
    };

    home.activation.symlink_persist_data = lib.hm.dag.entryAfter ["linkGeneration"] ''
      run ln -s /data $HOME/data || true
    '';

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
        {
          directory = "data";
          home = lib.mkForce null;
        }
        "Desktop"
        "Documents"
        "Downloads"
        "Music"
        "Pictures"
        "Videos"

        ".gnupg"
        ".ssh"
        ".password-store"
        ".cache/dconf"
        ".config/pulse"
        ".config/Throne"
        ".local/share/applications"
        ".local/share/Steam"
        ".local/share/CKAN"
        ".steam"
        ".factorio"

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
      files = [
        ".steampath"
        ".local/share/nix/trusted-settings.json"
      ];
    };
  };
}
