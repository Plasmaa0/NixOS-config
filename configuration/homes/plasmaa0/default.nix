{ config, lib, pkgs, ... }:
{
  imports = [
    ../common
  ];
  home.username = "plasmaa0";
  home.homeDirectory = "/home/plasmaa0";

  home.packages = (with pkgs; [
    alacritty
    fish eza bat starship ripgrep fzf fastfetch yad fd entr cloc moreutils speedtest-cli unzip
    fishPlugins.done jump
    hyperfine
    gnumake
    powertop
    telegram-desktop
    betterlockscreen
    spaceFM
    vscode
    glow mdcat
    (btop.override { cudaSupport = true; })
    networkmanagerapplet
    upower poweralertd
    xorg.xbacklight brightnessctl
    dconf
    libnotify
    feh
    arandr
    pulseaudio pavucontrol
    eww playerctl jq
    flameshot copyq
    evince
    gparted
    # yandex-music
    cassette
    qbittorrent
    texlive.combined.scheme-full texstudio tectonic zathura
    libreoffice
    xarchiver
    # cider
    # i3wsr # i3 workspace names
    ((pkgs.python3.override { enableOptimizations = true; reproducibleBuild = false;}).withPackages (ppkgs: [
      ppkgs.numpy
      ppkgs.matplotlib
      ppkgs.tabulate
      ppkgs.sympy
      ppkgs.scipy
    ]))
  ]);
}
