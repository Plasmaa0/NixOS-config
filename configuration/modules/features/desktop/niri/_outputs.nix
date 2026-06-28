{...}: {
  programs.niri.settings.outputs = {
    # ----- Built-in laptop display -----
    "eDP-1" = {
      # Use 2560x1600 at 240 Hz (or 60 Hz if you prefer)
      mode = {
        width = 2560;
        height = 1600;
        refresh = 240.00; # change to 60.00 for the 60 Hz profile
      };
      scale = 1.5;
      position = {
        x = 2560; # to the right of the external monitors
        y = 2560; # below them (as in zep_home profiles)
      };
      # This monitor is not primary (primary is an external one)
      focus-at-startup = false;
    };

    # ----- HDMI monitor (AOC) -----
    "HDMI-1-0" = {
      mode = {
        width = 2560;
        height = 1440;
        refresh = 59.95;
      };
      scale = 1.0; # adjust if needed
      position = {
        x = 0;
        y = 1440; # below the primary? (position varies)
      };
      focus-at-startup = false;
    };

    # ----- DisplayPort monitor (Huawei) – right side USB-C -----
    "DP-1-0" = {
      mode = {
        width = 3840;
        height = 2560;
        refresh = 59.98;
      };
      scale = 1.5; # if you need scaling for 4K
      position = {
        x = 2560;
        y = 0;
      };
      focus-at-startup = true; # primary monitor
    };

    # ----- Alternative DisplayPort name (sometimes differs) -----
    "DisplayPort-1" = {
      mode = {
        width = 3840;
        height = 2560;
        refresh = 59.98;
      };
      scale = 1.5;
      position = {
        x = 2560;
        y = 0;
      };
      focus-at-startup = true;
    };
  };
}
