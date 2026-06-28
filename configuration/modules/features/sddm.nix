{...}: {
  flake.nixosModules.sddm = {
    pkgs,
    config,
    self,
    ...
  }: {
    environment.systemPackages = with pkgs; [
      (where-is-my-sddm-theme.override {
        themeConfig.General = {
          background = config.stylix.image;
          blurRadius = 20;
          passwordInputWidth = 0.75;
          passwordFontSize = 64;
          font = config.stylix.fonts.serif.name;
          helpFont = config.stylix.fonts.serif.name;
          backgroundMode = "fill";
        };
      })
    ];
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      # theme = "where_is_my_sddm_theme";
    };
    services.xserver = {
      enable = false;
      displayManager.session = [
        {
          manage = "window";
          name = "home-manager";
          start = ''
            ${pkgs.runtimeShell} $HOME/.hm-xsession &
            waitPID=$!
          '';
        }
      ];
    };
    home-manager.sharedModules = [
      self.homeModules.xsession-script-path
    ];
  };
  flake.homeModules.xsession-script-path = {...}: {
    xsession.scriptPath = ".hm-xsession";
  };
}
