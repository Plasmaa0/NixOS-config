{pkgs, ...}:{
  services.xserver.displayManager.lightdm = {
    enable = true;
    greeters.slick = {
      enable = true;
      font = {
        package = (pkgs.nerdfonts.override{fonts=["IosevkaTermSlab"];});
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
}
