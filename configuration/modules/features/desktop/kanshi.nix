{...}: {
  flake.homeModules.kanshi = {config, ...}: let
    reloadCmd = "awww img ${config.stylix.image}"; # optional, may not work
  in {
    services.kanshi = {
      enable = true;

      # DP-9 right
      # DP-2 left
      settings = [
        # ---- Profile: zep_home (laptop + AOC + Huawei) ----
        {
          profile = {
            name = "zep_home";
            outputs = [
              {
                criteria = "eDP-1";
                scale = 1.5;
                status = "enable";
                position = "2048,1280"; # x=2560, y=2560
                mode = "2560x1600@240"; # 240 Hz
              }
              {
                criteria = "HDMI-A-1"; # AOC monitor
                scale = 1.25;
                status = "enable";
                position = "0,491"; # x=0, y=1440
                mode = "2560x1440@59.95";
              }
              {
                criteria = "DP-2"; # Huawei (left USB-C)
                scale = 2.0;
                status = "enable";
                position = "2048,0";
                mode = "3840x2560@59.98";
              }
            ];
            exec = [reloadCmd];
          };
        }

        # ---- Profile: zep_home2 (same but DP-9 instead of DP-2) ----
        {
          profile = {
            name = "zep_home2";
            outputs = [
              {
                criteria = "eDP-1";
                scale = 1.5;
                status = "enable";
                position = "2048,1280";
                mode = "2560x1600@240";
              }
              {
                criteria = "HDMI-A-1";
                scale = 1.25;
                status = "enable";
                position = "0,491";
                mode = "2560x1440@59.95";
              }
              {
                criteria = "DP-9"; # Huawei (right USB-C)
                scale = 2.0;
                status = "enable";
                position = "2048,0";
                mode = "3840x2560@59.98";
              }
            ];
            exec = [reloadCmd];
          };
        }

        # ---- Profile: zep_home3 (eDP + DP-9 only) ----
        {
          profile = {
            name = "zep_home3";
            outputs = [
              {
                criteria = "eDP-1";
                scale = 1.5;
                status = "enable";
                position = "2560,2560";
                mode = "2560x1600@60"; # 60 Hz for this profile
              }
              {
                criteria = "DP-9";
                scale = 2.0;
                status = "enable";
                position = "2048,0";
                mode = "3840x2560@59.98";
              }
            ];
            exec = [reloadCmd];
          };
        }

        # ---- Profile: zep_240 (eDP only, 240 Hz) ----
        {
          profile = {
            name = "zep_240";
            outputs = [
              {
                criteria = "eDP-1";
                scale = 1.5;
                status = "enable";
                position = "0,0";
                mode = "2560x1600@240";
              }
            ];
            exec = [reloadCmd];
          };
        }

        # ---- Profile: zep_60 (eDP only, 60 Hz) ----
        {
          profile = {
            name = "zep_60";
            outputs = [
              {
                criteria = "eDP-1";
                scale = 1.5;
                status = "enable";
                position = "0,0";
                mode = "2560x1600@60";
              }
            ];
            exec = [reloadCmd];
          };
        }
      ];
    };
  };
}
