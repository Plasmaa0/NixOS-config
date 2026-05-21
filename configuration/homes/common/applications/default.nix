{...}: {
  imports = [
    ./mime.nix
    ./browser/qutebrowser.nix
    ./browser/helium.nix
    ./social/telegram.nix
    ./music/cassette.nix
    ./music/yandex-music.nix
    ./music/mpd.nix
    ./editor/vscode.nix
    ./editor/texstudio.nix
    ./editor/xournalpp.nix
    ./media/zathura.nix
    ./media/vlc.nix
    ./media/easyeffects.nix
    ./media/obs.nix
    ./utils/gparted.nix
    ./utils/mangohud.nix
    ./games/minecraft.nix
  ];
}
