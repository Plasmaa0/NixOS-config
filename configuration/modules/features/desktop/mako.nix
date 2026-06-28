{...}: {
  flake.homeModules.desktop-notifications-wayland-mako = {
    config,
    lib,
    pkgs,
    ...
  }: let
    c = config.lib.stylix.colors.withHashtag;
    # Optional: apply opacity from stylix if desired
    opacity = config.stylix.opacity.popups; # from stylix options
    alphaHex = lib.toHexString (builtins.ceil (opacity * 255));
  in {
    stylix.targets.mako.enable = false;

    services.mako = {
      enable = true;

      settings = {
        # ----- Global style (using Stylix colors with optional alpha) -----
        font = "${config.stylix.fonts.sansSerif.name} ${toString config.stylix.fonts.sizes.popups}";
        background-color = c.base01 + alphaHex; # apply opacity to background
        text-color = c.base06;
        border-color = c.base05;
        border-size = 2;
        border-radius = 10;
        width = 300;
        height = 100; # max height
        margin = 10; # outer margin
        padding = 5; # inner padding
        default-timeout = 5000; # default for low & normal
        anchor = "top-right";
        layer = "top";
        icons = 1;
        max-icon-size = 64;
        # icon-path = "";
        markup = 1;
        actions = 1;
        history = 1;
        max-history = 5;
        sort = "-time"; # newest first
        group-by = "app-name,summary"; # group by app and summary
      };
    };

    # ----- Utility scripts (test notifications, reload) -----
    home.packages = with pkgs; [
      libnotify

      (writeShellApplication {
        name = "mako-reload";
        runtimeInputs = [procps mako];
        text = ''
          pkill mako || true
          mako &
        '';
      })

      (writeShellApplication {
        name = "notify-test";
        runtimeInputs = [gnugrep pulseaudio libnotify];
        text = ''
          notify-send -u critical "Urgent message" "critical test 1"
          notify-send -u normal "Normal message" "normal test 2"
          notify-send -u low "Low message" "low test 3"
          notify-send -u normal "Test with icon" "text" -i reddit
          notify-send -u low -a Cassette -i stock_volume "Test message" "Music test"
          notify-send -u low -a volume -h "int:value:$(pactl get-sink-volume @DEFAULT_SINK@ | grep -o '[0-9]\+%' | head -1)" "Volume" --hint=string:x-dunst-stack-tag:volume
          notify-send -u low -a bright -h "int:value:$(brightnessctl | grep -o '[0-9]\+%')" "Brightness" --hint=string:x-dunst-stack-tag:brightness
        '';
      })
    ];
  };
}
