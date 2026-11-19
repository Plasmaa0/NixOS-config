{...}: {
  flake.homeModules.service-syncthing = {...}: {
    # home.persistence."/persist".directories = [".cache/kdeconnect.app" ".config/kdeconnect"];
    services.syncthing = {
      enable = true;

      overrideDevices = true;
      overrideFolders = true;

      settings = {
        devices = {
          "op15" = {
            id = "PJCVEMJ-MNFSOII-AXYNZAK-4XWRVSR-V2V3V3J-XPSIQAJ-MTLMSA2-3S5ODAG";
          };
        };

        # 2. Описываем папку с музыкой
        folders = {
          "music-library" = {
            path = "/home/plasmaa0/data/music";

            devices = ["op15"];

            type = "sendreceive";

            ignorePatterns = [
              "Recordings/"
              "Merlin/"
              ".thumbnails/"
            ];
          };
        };
      };
    };
  };
}
