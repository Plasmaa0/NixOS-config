{
  pkgs,
  config,
  ...
}: {
  home.packages = [
    pkgs.cantata
    pkgs.clementine
  ];
  services.mpd = {
    enable = true;
    dataDir = "${config.home.homeDirectory}/.config/mpd";
    musicDirectory = "${config.home.homeDirectory}/data/music";
    extraConfig = ''
      auto_update "yes"
      audio_output {
        type "pipewire"
        name "Pipewire Output 1"
      }
    '';
  };
  programs.ncmpcpp.enable = true;
  programs.rmpc.enable = true;
}
