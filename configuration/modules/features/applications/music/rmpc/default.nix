{...}: {
  flake.homeModules.application-music-rmpc = {...}: {
    programs.rmpc = {
      enable = true;
      config = ''
        #![enable(implicit_some)]
        #![enable(unwrap_newtypes)]
        (
            address: "localhost:6600",
            status: (
                show_elapsed: true,
                show_remaining: false,
            ),
            audio: (
                visualizer: (
                    type: "disabled",
                ),
            ),
            album_art: (
                method: "/tmp/rmpc/album_art.jpg",
            ),
        )
      '';
    };
    xdg.configFile."rmpc/fetch_all_lyrics.sh".source = ./fetch_all_lyrics.sh;
    xdg.configFile."rmpc/fetch_album_lyrics.sh".source = ./fetch_album_lyrics.sh;
    xdg.configFile."rmpc/default_album_art.png".source = ./default_album_art.png;
  };
}
