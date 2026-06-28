{...}: {
  flake.homeModules.plasmaa0 = {
    pkgs,
    lib,
    self,
    ...
  }: {
    programs.home-manager.enable = true;
    home.stateVersion = "24.05";
    imports = with self.homeModules; [
      stylix
      kanshi
      cli-utils-common
      cli-editor-helix
      cli-editor-markdown-oxide
      cli-shell-fish
      cli-shell-starship
      cli-terminal-alacritty
      cli-terminal-kitty
      cli-terminal-wezterm
      cli-utils-btop
      cli-utils-direnv
      cli-utils-fastfetch
      cli-utils-git
      cli-utils-yazi
      desktop-window-manager-wayland-niri
      # desktop-window-manager-x11-i3
      # desktop-util-x11-conky
      # desktop-util-x11-picom
      # desktop-launcher-x11-rofi
      # desktop-bar-eww
      # desktop-bar-x11-polybar
      desktop-bar-wayland-waybar
      # desktop-lockscreen-x11-betterlockscreen
      # desktop-notifications-x11-dunst
      # desktop-notifications-wayland-mako
      desktop-notifications-wayland-swaync
      application-util-mime
      application-browser-helium
      application-browser-qutebrowser
      application-editor-vscode
      application-editor-texstudio
      application-editor-xournalpp
      application-games-minecraft
      application-media-obs
      application-media-vlc
      application-media-zathura
      application-media-easyeffects
      application-music-rmpc
      application-music-yandex-music
      application-music-cassette
      application-music-mpd
      application-social-telegram
      application-utils-mangohud
      application-utils-gparted
      service-powertop
      service-poweralertd
      service-udiskie
      service-kde-connect
      service-flameshot
      service-cliphist
      dev-python
      dev-latex
      dev-typst
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
      rura
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
