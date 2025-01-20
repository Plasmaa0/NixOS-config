{
  config,
  pkgs,
  ...
}: let
  c = config.lib.stylix.colors;
  # fadeBrightness = pkgs.writeShellApplication {
  #   name = "fade-brightness";
  #   runtimeInputs = with pkgs; [brightnessctl coreutils];
  #   text = ''
  #     target_level="$1"
  #     fade_step_time="$2"
  #     get_brightness() {
  #         brightnessctl -m | awk -F, '{print substr($4, 0, length($4)-1)}' | tr -d '%'
  #     }
  #     set_brightness() {
  #         brightnessctl set "$1"% > /dev/null
  #     }
  #     fade_brightness() {
  #         local level
  #         for level in "$(eval echo {$(get_brightness)..$1})"; do
  #             set_brightness "$level"
  #             sleep "$fade_step_time"
  #         done
  #     }
  #     trap 'exit 0' TERM INT
  #     trap 'set_brightness "$(get_brightness)"; kill %%' EXIT
  #     fade_brightness "$target_level"
  #     sleep 2147483647 &
  #     wait
  #   '';
  # };
in {
  home.packages = with pkgs; [
    betterlockscreen
  ];
  services.screen-locker = {
    enable = true;
    inactiveInterval = 15; # minutes
    lockCmd = "${pkgs.betterlockscreen}/bin/betterlockscreen --lock --show-layout";
    xautolock = {
      enable = true;
      detectSleep = true;
      extraOptions = [
        # according to manual
        # -corners xxxx       : corner actions (0, +, -) in this order:
        #                       topleft topright bottomleft bottomright
        " -corners '----'" # put your cursor in one of corners of the screen to prevent locking
        " -bell 60"
        " -notify 15"
        ''-notifier '${pkgs.libnotify}/bin/notify-send -i system-lock-screen "xautolock" "Locking in 15 seconds"' ''
      ];
    };
    # xss-lock.extraOptions = [
    #   " -n ${fadeBrightness}/bin/fade-brightness 5 0.05"
    # ];
  };

  # services.logind.extraConfig = ''
  #   HandlePowerKey=suspend
  # '';

  home.file."${config.xdg.configHome}/betterlockscreen/betterlockscreenrc".text = ''
    # ~/.config/betterlockscreenrc
    # default options
    display_on=0
    span_image=false
    lock_timeout=300
    fx_list=(dim blur dimblur pixel dimpixel color)
    dim_level=40
    blur_level=1
    pixel_scale=10,1000
    solid_color=333333
    quiet=false

    base00=${c.base00} # "#272822"
    base01=${c.base01} # "#383830"
    base02=${c.base02} # "#49483e"
    base03=${c.base03} # "#75715e"
    base04=${c.base04} # "#a59f85"
    base05=${c.base05} # "#f8f8f2"
    base06=${c.base06} # "#f5f4f1"
    base07=${c.base07} # "#f9f8f5"
    base08=${c.base08} # "#f92672"
    base09=${c.base09} # "#fd971f"
    base0A=${c.base0A} # "#f4bf75"
    base0B=${c.base0B} # "#a6e22e"
    base0C=${c.base0C} # "#a1efe4"
    base0D=${c.base0D} # "#66d9ef"
    base0E=${c.base0E} # "#ae81ff"
    base0F=${c.base0F} # "#cc6633"

    # default theme
    loginbox=00000000
    loginshadow=000000ff
    locktext="Hello $(whoami)!"
    font="${config.stylix.fonts.monospace.name}"
    fontXL=${toString (builtins.ceil (config.stylix.fonts.sizes.applications * 3))}
    fontlg=${toString (builtins.ceil (config.stylix.fonts.sizes.applications * 2))}
    fontmd=${toString (builtins.ceil (config.stylix.fonts.sizes.applications * 1.5))}
    fontsm=${toString (builtins.ceil config.stylix.fonts.sizes.applications)}
    ringcolor=$base0E
    insidecolor="''${base01}aa"
    separatorcolor=00000000
    ringvercolor=$base0E
    insidevercolor="''${base03}aa"
    ringwrongcolor=$base08
    insidewrongcolor="''${base02}aa"
    timecolor=$base0B
    time_format="%H:%M:%S"
    greetercolor=$base0B
    layoutcolor=$base0A
    keyhlcolor=$base02
    bshlcolor=$base02
    veriftext="Verifying"
    verifcolor=$base0B
    wrongtext="Failure!"
    wrongcolor=$ringwrongcolor
    modifcolor=$base0F
    bgcolor="''${base00}bb"

    lockargs+=(-k)

    # scaling=2
    # index_x=$(xrandr --listactivemonitors | grep '*' | awk 'BEGIN { FS="[ /x]" } ; { print $4/2/"'$scaling'" }')
    # index_y=$(xrandr --listactivemonitors | grep '*' | awk 'BEGIN { FS="[ /x]" } ; { print $6/2/"'$scaling'" }')

    lockargs+=(--ind-pos="x+w/2:y+h/2")

    lockargs+=(--time-pos="ix:iy-h/2+h/10")
    lockargs+=(--time-align 0)
    lockargs+=(--time-size=$fontXL)

    lockargs+=(--date-str "$(date '+%d %B %Y')")
    lockargs+=(--date-pos="ix:iy-h/2+h/6")
    lockargs+=(--date-align 0)
    lockargs+=(--date-color="''${timecolor}")
    lockargs+=(--date-font="$font")
    lockargs+=(--date-size=$fontlg)

    lockargs+=(--greeter-pos="ix:iy")
    lockargs+=(--greeter-align 0)
    lockargs+=(--greeter-size=$fontmd)

    lockargs+=(--layout-pos="ix-w/2+w/20:iy+h/2-h/20")
    lockargs+=(--layout-align 1)
    lockargs+=(--layout-size=$fontsm)

    lockargs+=(--radius=250)
    lockargs+=(--ring-width=20)

    lockargs+=(--verif-pos="ix:iy+h/20")
    lockargs+=(--verif-align 0)
    lockargs+=(--verif-size=$fontsm)

    lockargs+=(--wrong-pos="ix:iy+h/20")
    lockargs+=(--wrong-align 0)
    lockargs+=(--wrong-size=$fontlg)

    lockargs+=(--modif-pos="ix:iy+h/20")
    lockargs+=(--modif-align 0)
    lockargs+=(--modif-size=$fontsm)
  '';
}
