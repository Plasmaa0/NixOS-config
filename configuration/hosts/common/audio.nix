{...}: {
  security.rtkit.enable = true;

  services.pulseaudio.enable = false;

  # avahi required for service discovery
  services.avahi.enable = true;

  services.pipewire = {
    enable = true;

    wireplumber.extraConfig = {
      "10-bluez" = {
        "monitor.bluez.properties" = {
          "bluez5.enable-sbc-xq" = true;
          "bluez5.enable-msbc" = true;
          "bluez5.enable-hw-volume" = true;
          "bluez5.roles" = [
            "hsp_hs"
            "hsp_ag"
            "hfp_hf"
            "hfp_ag"
          ];
        };
      };
    };

    # opens UDP ports 6001-6002
    raopOpenFirewall = true;

    extraConfig.pipewire = {
      # https://leon_plickat.srht.site/writing/pipewire-external-dac/article.html
      # https://wierd161.home.xs4all.nl/using-your-usb-dac-with-linux/index.html
      # https://discovery.endeavouros.com/audio/audiophile/2022/01/
      "80-sample-rate" = {
        "context.properties" = {
          "default.clock.allowed-rates" = [44100 48000 88200 96000 176400 192000 352800 384000 705600 768000];
        };
      };
      "10-airplay" = {
        "context.modules" = [
          {
            name = "libpipewire-module-raop-discover";

            # increase the buffer size if you get dropouts/glitches
            # args = {
            #   "raop.latency.ms" = 500;
            # };
          }
        ];
      };
    };
  };
}
