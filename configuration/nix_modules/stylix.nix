{ config, pkgs, lib, ... }:

let
  wallpaper_dark = ./../wallpapers/monokai.jpg;
  wallpaper_light = ./../wallpapers/desert_day.jpg;
  activation-script = {
    reload = lib.hm.dag.entryAfter ["writeBoundary"] ''
      run ${pkgs.i3}/bin/i3-msg reload || true
      run ${pkgs.i3}/bin/i3-msg restart || true
      run ${pkgs.i3}/bin/i3-msg restart || true
      run ${pkgs.procps}/bin/pkill dunst || true
      run ${pkgs.libnotify}/bin/notify-send "Dunst" "Dunst reloaded successfully" || true
      run ${pkgs.procps}/bin/pkill -USR1 hx || true
    '';
  };
in
{
  stylix.enable = true;
  stylix.autoEnable = true;
  stylix.image = wallpaper_dark;
  stylix.targets.feh.enable = true;
  stylix.targets.i3.enable = false;
  stylix.targets.helix.enable = false;
  stylix.imageScalingMode = "fill";
  stylix.polarity = "dark";
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/monokai.yaml";
  home.packages = with pkgs; [
    (writeShellApplication {
      name = "toggle-theme";
      runtimeInputs = with pkgs; [ home-manager coreutils brightnessctl gnugrep ripgrep ];
      text =
        ''
        brightnessctl -s
        brightnessctl -q set 0% || true
        "$(home-manager generations | head -1 | rg -o '/[^ ]*')"/specialisation/light-theme/activate || "$(home-manager generations | head -2 | tail -1 | rg -o '/[^ ]*')"/activate
        brightnessctl -r
        '';
    })
  ];
  home.activation = activation-script;
  specialisation.light-theme.configuration = {
      # stylix.base16Scheme = lib.mkForce "${pkgs.base16-schemes}/share/themes/gruvbox-light-soft.yaml";  
      stylix.base16Scheme = lib.mkForce "${pkgs.base16-schemes}/share/themes/catppuccin-latte.yaml";  
      stylix.image = lib.mkForce wallpaper_light;
      stylix.polarity = lib.mkForce "light";
      home.activation = activation-script;
  };
  # home-manager generations | head -1 | tr " " "\n" | grep "/nix.*
  # see also common/fonts.nix
  stylix.fonts = {
    serif = {
      package = (pkgs.nerdfonts.override{fonts=["IosevkaTermSlab"];});
      name = "IosevkaTermSlab";
    };
    sansSerif = {
      package = (pkgs.nerdfonts.override{fonts=["Arimo"];});
      name = "Arimo";
    };
    monospace = {
      package = (pkgs.nerdfonts.override{fonts=["Iosevka"];});
      name = "Iosevka";
    };
    emoji = {
      package = pkgs.openmoji-color;
      name = "OpenMoji Color";
    };
  };
  stylix.cursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 36;
  };
  gtk.iconTheme = {
    package = pkgs.papirus-icon-theme;
    name = "Papirus-Dark";
  };
}
