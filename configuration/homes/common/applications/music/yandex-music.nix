{pkgs, ...}: let
  pkgsForYandexMusic =
    import (pkgs.fetchzip {
      url = "https://github.com/NixOS/nixpkgs/archive/d66115b18ccf2fbb03da4f2ea8a41499eb8d3136.tar.gz";
      hash = "sha256-XONo9xGd3zGt/iHmIDZ+Uj/FZxRRFmrDrIFqYtzoPnM=";
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
