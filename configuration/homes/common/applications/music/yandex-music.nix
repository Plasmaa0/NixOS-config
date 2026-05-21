{pkgs, ...}: let
  pkgsForYandexMusic =
    import (pkgs.fetchzip {
      url = "https://github.com/NixOS/nixpkgs/archive/f4df4db3be2a5c3926b406d1b2ddeb5d88a6d94d.tar.gz";
      hash = "sha256-xwHE1kv7ZjUfVLLoqfW6ZMtoWZXVv4m/A0flmhn2Ebs=";
    }) {
      inherit (pkgs.stdenv.hostPlatform) system;
      config.allowUnfree = true;
    };
in {
  home.packages = [pkgsForYandexMusic.yandex-music];
  home.persistence."/persist" = {
    directories = [".config/yandex-music"];
  };
}
