{ config, lib, pkgs, ... }:
{
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

  home.packages = (with pkgs; [
    spaceFM
    (btop.override { cudaSupport = true; })
    networkmanagerapplet
    upower poweralertd
    xorg.xbacklight brightnessctl
    dconf
    feh
    arandr
    pulseaudio pavucontrol
    evince
    gparted
    # yandex-music
    cassette
    qbittorrent
    libreoffice
    xarchiver
    # cider
    # i3wsr # i3 workspace names
  ]);
}
