{
  pkgs,
  config,
  ...
}: {
  home.packages = [
    pkgs.clementine
  ];
  imports = [
    ./rmpc
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
      audio_output {
         type   "fifo"
         name   "my_fifo"
         path   "/tmp/mpd.fifo"
         format "44100:16:2"
      }
    '';
  };
  programs.ncmpcpp.enable = true;
  programs.rmpc.enable = true;
}
