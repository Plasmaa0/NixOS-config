{pkgs, ...}: {
  imports = [
    ./hardware
    ../common
    ../common/modules/steam.nix
    ../common/modules/vial.nix
    ../common/modules/HighDPI.nix
  ];
  users.users.plasmaa0.shell = pkgs.fish;
  programs.fish.enable = true;
}
