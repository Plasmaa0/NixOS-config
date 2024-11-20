{ config, lib, pkgs, pkgs_stable, ... }:

{
  imports = [
    ./nix_modules
    ./secrets/secrets.nix
  ];
  home.username = "plasmaa0";
  home.homeDirectory = "/home/plasmaa0";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.package = lib.mkForce pkgs.nix;

  home.packages = (with pkgs; [
    alacritty
    fish eza bat starship ripgrep fzf fastfetch yad entr cloc moreutils speedtest-cli
    telegram-desktop
    betterlockscreen
    spaceFM
    vscode
    glow
    (btop.override { cudaSupport = true; })
    chromium
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
    texlive.combined.scheme-full texstudio
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
  # ++ (with pkgs_stable; [
  #   # wezterm
  # ]);
  services.flameshot.enable = true;
  services.copyq.enable = true;
  services.poweralertd.enable = true; # notifications about "power"-related things
  home.sessionVariables = {
    # EDITOR = "emacs";
    # SUDO_EDITOR="code --wait";
  };

  programs.home-manager.enable = true;
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.
}
