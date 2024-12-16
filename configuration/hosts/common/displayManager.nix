{pkgs, ...}: {
  fonts.fontDir.enable = true;
  fonts.fontconfig.enable = true;
  fonts.packages = with pkgs; [
    (nerdfonts.override {fonts = ["IosevkaTermSlab"];})
  ];
  environment.systemPackages = with pkgs; [
    (where-is-my-sddm-theme.override {
      themeConfig.General = {
        background = "${../../homes/common/wallpapers/monokai.jpg}";
        blurRadius = 40;
        showUsersByDefault = true;
        showSessionsByDefault = true;
        font = "IosevkaTermSlab";
        helpFont = "IosevkaTermSlab";
        backgroundMode = "fill";
      };
      variants = ["qt5"];
    })
  ];
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
    displayManager.sddm = {
      enable = true;
      theme = "where_is_my_sddm_theme_qt5";
    };
    displayManager.lightdm = {
      # enable = true;
      greeters.slick = {
        enable = true;
        font = {
          package = pkgs.nerdfonts.override {fonts = ["IosevkaTermSlab"];};
          name = "IosevkaTermSlab";
        };
        iconTheme = {
          package = pkgs.papirus-icon-theme;
          name = "Papirus-Dark";
        };
        extraConfig = ''
          [Greeter]
              background="#699ad7"
              logo="${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg"
              show-hostname=true
              show-power=true
              show-a11y=true
              show-keyboard=true
              show-clock=true
              show-quit=true
              xft-dpi=192
        '';
      };
    };
  };
}
