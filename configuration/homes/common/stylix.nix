{
  inputs,
  pkgs,
  lib,
  config,
  hidpiScalingFactor,
  ...
}: let
  activation-script = {
    reload = lib.hm.dag.entryAfter ["writeBoundary"] ''
      run ${pkgs.i3}/bin/i3-msg reload || true
      run ${pkgs.i3}/bin/i3-msg restart || true
      run ${pkgs.procps}/bin/pkill dunst || true
      run ${pkgs.libnotify}/bin/notify-send "Dunst" "Dunst reloaded successfully" || true
      run ${pkgs.procps}/bin/pkill eww || true
      run ${pkgs.eww}/bin/eww open bar || true
      run ${pkgs.procps}/bin/pkill -USR1 hx || true
    '';
  };
  theme = import ./themes/dark/monokai.nix;
  alternateTheme = import ./themes/dark/xmas.nix;
in {
  imports = [
    inputs.stylix.homeManagerModules.stylix
  ];
  stylix.enable = true;
  stylix.autoEnable = true;
  stylix.image = ./wallpapers/${theme.wallpaper};
  stylix.targets = {
    i3.enable = false;
    helix.enable = false;
  };
  stylix.imageScalingMode = "fill";
  stylix.polarity = theme.polarity;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/${theme.scheme}.yaml";
  home.packages = with pkgs; [
    (writeShellApplication {
      name = "toggle-theme";
      runtimeInputs = with pkgs; [home-manager coreutils brightnessctl gnugrep ripgrep];
      text = ''
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
    stylix.base16Scheme = lib.mkForce "${pkgs.base16-schemes}/share/themes/${alternateTheme.scheme}.yaml";
    stylix.image = lib.mkForce ./wallpapers/${alternateTheme.wallpaper};
    stylix.polarity = lib.mkForce alternateTheme.polarity;
    home.activation = activation-script;
  };
  # home-manager generations | head -1 | tr " " "\n" | grep "/nix.*
  # see also common/fonts.nix
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      serif = ["IosevkaTermSlab"];
      sansSerif = ["Arimo"];
      monospace = ["Iosevka"];
      emoji = ["OpenMoji Color"];
    };
  };
  stylix.fonts = {
    serif = {
      package = pkgs.nerd-fonts.iosevka-term-slab;
      name = "IosevkaTermSlab";
    };
    sansSerif = {
      package = pkgs.nerd-fonts.arimo;
      name = "Arimo";
    };
    monospace = {
      package = pkgs.nerd-fonts.iosevka;
      name = "Iosevka";
    };
    emoji = {
      package = pkgs.openmoji-color;
      name = "OpenMoji Color";
    };
    sizes = {
      applications = 12 * hidpiScalingFactor;
      desktop = 10 * hidpiScalingFactor;
      popups = 10 * hidpiScalingFactor;
      terminal = 10 * hidpiScalingFactor;
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
  home.file."theme-preview.html".text = let
    c = config.lib.stylix.colors;
  in ''
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>${theme.scheme}</title>
        <style>
            body {
                margin: 0;
                display: flex;
                flex-wrap: wrap;
                height: 100vh;
                font-family: '${config.stylix.fonts.monospace.name}', monospace;
            }
            .color-box {
                flex: 1 0 12.5%;
                height: 50vh;
                display: flex;
                align-items: center;
                justify-content: center;
                font-weight: bold;
                font-size: 2em;
                color: #${c.base07};
                -webkit-text-stroke: 1px #${c.base00};
            }
        </style>
    </head>
    <body>
        <div class="color-box" style="background-color: #${c.base00};">----</div>
        <div class="color-box" style="background-color: #${c.base01};">---</div>
        <div class="color-box" style="background-color: #${c.base02};">--</div>
        <div class="color-box" style="background-color: #${c.base03};">-</div>
        <div class="color-box" style="background-color: #${c.base04};">+</div>
        <div class="color-box" style="background-color: #${c.base05};">++</div>
        <div class="color-box" style="background-color: #${c.base06};">+++</div>
        <div class="color-box" style="background-color: #${c.base07};">++++</div>

        <div class="color-box" style="background-color: #${c.base08};">red</div>
        <div class="color-box" style="background-color: #${c.base09};">orange</div>
        <div class="color-box" style="background-color: #${c.base0A};">yellow</div>
        <div class="color-box" style="background-color: #${c.base0B};">green</div>
        <div class="color-box" style="background-color: #${c.base0C};">cyan</div>
        <div class="color-box" style="background-color: #${c.base0D};">blue</div>
        <div class="color-box" style="background-color: #${c.base0E};">purple</div>
        <div class="color-box" style="background-color: #${c.base0F};">brown</div>
    </body>
    </html>
  '';
}
