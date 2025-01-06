{...}: {
  imports = [
    ./browser/qutebrowser.nix
    ./social/telegram.nix
    ./social/cassette.nix
    ./editor/vscode.nix
    ./editor/texstudio.nix
    ./media/zathura.nix
    ./media/vlc.nix
    ./media/easyeffects.nix
    ./utils/gparted.nix
  ];
}
