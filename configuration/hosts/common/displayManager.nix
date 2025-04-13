{pkgs, ...}: {
  fonts.fontDir.enable = true;
  fonts.fontconfig.enable = true;
  fonts.packages = with pkgs; [
    nerd-fonts.victor-mono
  ];
  environment.systemPackages = with pkgs; [
    (where-is-my-sddm-theme.override {
      themeConfig.General = {
        background = "${../../homes/common/wallpapers/a_rocky_shore_with_waves_crashing_on_rocks.jpg}";
        blurRadius = 20;
        passwordInputWidth = 0.75;
        passwordFontSize = 64;
        font = "VictorMono NF";
        helpFont = "VictorMono NF";
        backgroundMode = "fill";
      };
      variants = ["qt5"];
    })
  ];
  services.displayManager.sddm = {
    enable = true;
    theme = "where_is_my_sddm_theme_qt5";
  };
  services.xserver = {
    enable = true;
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
}
