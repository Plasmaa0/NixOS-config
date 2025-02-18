{
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    ./bootloader.nix
    ./fonts.nix
    ./power_management.nix
    ./keymap.nix
    ./autoUpgrade.nix
    ./garbageCollect.nix
    ./displayManager.nix
    ./time_and_i18n.nix
    ./ssh.nix
    ./gnupg.nix
    ./touchpad.nix
    ./audio.nix
    ./networking.nix
    ./nix-ld.nix
    ./systemd-lock-handler.nix
    ./printing.nix
    ./impermanence.nix
    ./automount.nix
    ./ananicy.nix
    ./gamemode.nix
    ./modules/HighDPI.nix
    inputs.home-manager.nixosModules.home-manager
  ];
  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = _: true;
  };
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.package = lib.mkForce pkgs.nix;
}
