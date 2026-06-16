{lib, ...}: let
  nixos-hardware = builtins.fetchTarball {
    url = "https://github.com/NixOS/nixos-hardware/archive/f6581f1c3b137086e42a08a906bdada63045f991.tar.gz";
    sha256 = "sha256:1qjivy929fpjf736f78v6hdhv64jgx2m1aff85w1d3cw7c4ppmag";
  };
in {
  imports = [
    "${nixos-hardware}/huawei/machc-wa"
  ];

  services.power-profiles-daemon.enable = lib.mkForce false;
}
