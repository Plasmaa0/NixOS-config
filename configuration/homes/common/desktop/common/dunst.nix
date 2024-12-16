{
  config,
  lib,
  pkgs,
  ...
}: let
  c = config.lib.stylix.colors;
  icons_path = "${builtins.unsafeDiscardStringContext config.gtk.iconTheme.package}/share/icons/${builtins.unsafeDiscardStringContext config.gtk.iconTheme.name}/128x128";
in {
  services.dunst.enable = true;
  # services.dunst.configFile = ../dotfiles/dunst/dunstrc;
  # home.file."${config.xdg.configHome}/dunst/dunstrc".text = ''
  home.file."${config.xdg.configHome}/dunst/logger.sh" = {
    text = ''
      DUNST_LOG="${config.xdg.configHome}/dunst/out.log"
      DUNST_ERR="${config.xdg.configHome}/dunst/err.log"
      LAST_LOG="${config.xdg.configHome}/dunst/last.log"

      handle_dunst_signal(){
        echo DUNST_APP_NAME: $DUNST_APP_NAME DUNST_SUMMARY: $DUNST_SUMMARY DUNST_BODY: $DUNST_BODY DUNST_ICON_PATH: $DUNST_ICON_PATH DUNST_URGENCY: $DUNST_URGENCY DUNST_ID: $DUNST_ID DUNST_PROGRESS: $DUNST_PROGRESS DUNST_CATEGORY: $DUNST_CATEGORY DUNST_STACK_TAG: $DUNST_STACK_TAG DUNST_URLS: $DUNST_URLS DUNST_TIMEOUT: $DUNST_TIMEOUT DUNST_TIMESTAMP: $DUNST_TIMESTAMP DUNST_DESKTOP_ENTRY: $DUNST_DESKTOP_ENTRY DUNST_STACK_TAG: $DUNST_STACK_TAG > $LAST_LOG
        case "$DUNST_URGENCY" in
          "LOW") exit;;
          "NORMAL"|"CRITICAL") urgency="$DUNST_URGENCY";;
          *) urgency="OTHER";;
        esac

        [ "$DUNST_SUMMARY" = "" ] && summary="Summary unavailable." || summary="$DUNST_SUMMARY"
        [ "$DUNST_BODY" = "" ] && body="Body unavailable." || body="$(${pkgs.coreutils}/bin/echo "$DUNST_BODY" | ${pkgs.recode}/bin/recode html)"

        case "$urgency" in
          "LOW") glyph="";;
          "NORMAL") glyph="";;
          "CRITICAL") glyph="";;
          *) glyph="";;
        esac

        if [[ $DUNST_ICON_PATH == "" ]]
        then
          ICON_PATH=$(${pkgs.findutils}/bin/find ${icons_path}/apps -iname "*$DUNST_APP_NAME*" | ${pkgs.coreutils}/bin/head -1)
        else
          ICON_PATH=$DUNST_ICON_PATH
        fi

        if [[ $DUNST_APP_NAME == "Cassette" ]]
        then
          url=$(${pkgs.playerctl}/bin/playerctl metadata mpris:artUrl)
          name="${config.xdg.configHome}/dunst/cover_$(${pkgs.coreutils}/bin/echo $url | ${pkgs.coreutils}/bin/tr '/' '-' | ${pkgs.coreutils}/bin/tr ':' '_')"
          ${pkgs.curl}/bin/curl $(${pkgs.playerctl}/bin/playerctl metadata mpris:artUrl) --output $name -s 2>/dev/null
          ICON_PATH=$name
        fi

        if [[ $ICON_PATH == "" ]]
        then
          ICON_PATH=${icons_path}/mimetypes/unknown.svg
        fi

        ${pkgs.coreutils}/bin/echo '(notification-card :class "notification-card notification-card-'$urgency' notification-card-'$DUNST_APP_NAME'" :SL "'$DUNST_ID'" :L "dunstctl history-pop '$DUNST_ID'" :body "'$body'" :summary "'$glyph' '$summary'" :image "'$ICON_PATH'" :application "'$DUNST_APP_NAME'")' \
          | ${pkgs.coreutils}/bin/cat - "$DUNST_LOG" \
          | ${pkgs.moreutils}/bin/sponge "$DUNST_LOG"
      }

      # remove top of the stack
      pop() {
        ${pkgs.gnused}/bin/sed -i '1d' "$DUNST_LOG"
      }

      # remove bottom of the stacl
      drop() {
        ${pkgs.gnused}/bin/sed -i '$d' "$DUNST_LOG"
      }

      remove_line() {
        ${pkgs.gnused}/bin/sed -i '/SL "'$1'"/d' "$DUNST_LOG"
      }

      critical_count() {
        crits=$(${pkgs.coreutils}/bin/cat $DUNST_LOG | ${pkgs.gnugrep}/bin/grep -c CRITICAL)
        total=$(${pkgs.coreutils}/bin/cat $DUNST_LOG | ${pkgs.coreutils}/bin/wc --lines)
        [ $total -eq 0 ] && ${pkgs.coreutils}/bin/echo 0 || ${pkgs.coreutils}/bin/echo $(((crits*100)/total))
      }

      normal_count() {
        norms=$(${pkgs.coreutils}/bin/cat $DUNST_LOG | ${pkgs.gnugrep}/bin/grep -c NORMAL)
        total=$(${pkgs.coreutils}/bin/cat $DUNST_LOG | ${pkgs.coreutils}/bin/wc --lines)
        [ "$total" -eq 0 ] && ${pkgs.coreutils}/bin/echo 0 || ${pkgs.coreutils}/bin/echo $(((norms*100)/total))
      }

      low_count() {
        lows=$(${pkgs.coreutils}/bin/cat $DUNST_LOG | ${pkgs.gnugrep}/bin/grep -c LOW)
        total=$(${pkgs.coreutils}/bin/cat $DUNST_LOG | ${pkgs.coreutils}/bin/wc --lines)
        [ "$total" -eq 0 ] && ${pkgs.coreutils}/bin/echo 0 || ${pkgs.coreutils}/bin/echo $(((lows*100)/total))
      }

      total_count() {
        total=$(${pkgs.coreutils}/bin/cat $DUNST_LOG | ${pkgs.coreutils}/bin/tr ' ' '\n' | ${pkgs.gnugrep}/bin/grep -c body)
        ${pkgs.coreutils}/bin/echo $total
      }

      clear_logs() {
        ${pkgs.coreutils}/bin/rm $DUNST_LOG
        ${pkgs.coreutils}/bin/touch $DUNST_LOG
        ${pkgs.coreutils}/bin/rm ${config.xdg.configHome}/dunst/cover_*
      }

      compile_caches() {
        ${pkgs.coreutils}/bin/tr '\n' ' ' < "$DUNST_LOG"
      }

      make_literal() {
        caches="$(compile_caches)"
        [[ "$caches" == "" ]] \
          && ${pkgs.coreutils}/bin/echo '(box :class "notifications-empty-box" :height 600 :orientation "vertical" :space-evenly "false" (image :class "notifications-empty-banner" :valign "end" :vexpand true :path "images/no-notifications.svg" :image-width 300 :image-height 300) (label :vexpand true :valign "start" :wrap true :class "notifications-empty-label" :text "No Notifications :("))' \
          || ${pkgs.coreutils}/bin/echo '(scroll :height 600 :vscroll true (box :orientation "vertical" :class "notification-scroll-box" :spacing 20 :space-evenly 'false' '$caches'))'
      }


      subscribe() {
        # clear_logs
        export DUNST_LOG
        export -f make_literal
        export -f compile_caches
        ${pkgs.coreutils}/bin/echo $DUNST_LOG | ${pkgs.entr}/bin/entr -ns make_literal
      }

      case "$1" in
        "pop") pop;;
        "drop") drop;;
        "clear") clear_logs;;
        "subscribe") subscribe 2> $DUNST_ERR;;
        "rm_id") remove_line $2;;
        "crits") critical_count;;
        "lows") low_count;;
        "norms") normal_count;;
        "get") make_literal;;
        "total") total_count;;
        *) handle_dunst_signal 2> $DUNST_ERR;;
      esac
    '';
    executable = true;
  };
  services.dunst.settings = lib.mkForce (builtins.fromTOML ''
    [global]
        monitor = 0

        # If this option is set to mouse or keyboard, the monitor option
        # will be ignored.
        follow = "mouse"

        # Geometery reference --> [{width}]x{height}[+/-{x}+/-{y}]
        width = 300
        height = 150
        origin = "top-center"
        offset = "0x55"

        # Radius of the four corners of the notification
        corner_radius = 20
        progress_bar_corner_radius = 5

        # Show how many messages are currently hidden (because of geometry).
        indicate_hidden = "yes"

        # Shrink window if it's smaller than the width.  Will be ignored if width is 0.
        shrink = "yes"

        # The transparency of the window.  Range: [0; 100].
        transparency = 80

        # The height of the entire notification.  If the height is smaller
        # than the font height and padding combined, it will be raised
        # to the font height and padding.
        # notification_height = 0

        # Show multiple notifications in the same box
        separator_height = 2

        # Define a color for the separator.
        # possible values are:
        #  * auto: dunst tries to find a color fitting to the background;
        #  * foreground: use the same color as the foreground;
        #  * frame: use the same color as the frame;
        #  * anything else will be interpreted as a X color.
        separator_color = "auto"

        # Add vertical padding to the inside of the notification
        padding = 10

        # Add horizontal padding for when the text gets long enough
        horizontal_padding = 10

        # The frame color and width of the notification
        frame_width = 1

        sort = "yes"

        # How long a user needs to be idle for sticky notifications
        idle_threshold = 120

        # Font and typography settings
        font = "${config.stylix.fonts.serif.name}"
        alignment = "left"
        word_wrap = "yes"

        # The spacing between lines.  If the height is smaller than the font height, it will get raised to the font height.
        line_height = 0

        # Allow some HTML tags like <i> and <u> in notifications
        markup = "full"

        # Format for how notifications will be displayed
        #format = "<b>%s</b>\n%b"
        format = "<span><b>%s %p</b></span>\n%b"

        show_age_threshold = 60

        # When word_wrap is set to no, specify where to make an ellipsis in long lines.
        # Possible values are "start", "middle" and "end".
        ellipsize = "middle"

        # Ignore newlines '\n' in notifications.
        ignore_newline = "no"

        # Stack together notifications with the same content
        stack_duplicates = "true"

        # Hide the count of stacked notifications with the same content
        hide_duplicate_count = "false"

        # Display indicators for URLs (U) and actions (A).
        show_indicators = "no"

        # Align icons left/right/off
        icon_position = "left"

        # Scale larger icons down to this size, set to 0 to disable
        max_icon_size = 64
        icon_corner_radius = 5

        icon_path = "${icons_path}/status/:${icons_path}/devices/:${icons_path}/apps/"

        history_length = 20
        sticky_history = "true"

        # Always run rule-defined scripts, even if the notification is suppressed
        always_run_script = "true"

        startup_notification = "true"

        force_xinerama = "false"

        mouse_left_click = "do_action"
        # mouse_middle_click = close_all
        # mouse_right_click = close_current

    [urgency_critical]
        frame_color = "#${c.base08}"
        background = "#${c.base0F}"
        foreground = "#${c.base00}"
        timeout = 0

    [urgency_normal]
        background = "#${c.base0B}"
        foreground = "#${c.base01}"
        frame_color = "#${c.base0B}"
        timeout = 10

    [urgency_low]
        # This urgency should be used only
        # for volume/brightness notification
        frame_color = "#${c.base05}"
        foreground = "#${c.base06}"
        background = "#${c.base01}"
        timeout = 5

    [z_Cassette]
        appname="Cassette"
        background = "#9F3046"
        foreground = "#DACDD1"
        frame_color = "#B7B5BA"
        timeout = 10

    # In process of creating dunstrc all TOML elements are sorted alphabetically
    # for volume and brightness notifications to work properly
    # rule for them need to be defined AFTER `urgency_low`
    # volume and brightness rules are prefixed with z to define them after `urgency_low`
    [z_volume]
        appname="volume"
        background = "#${c.base01}"
        foreground = "#${c.base0D}"
        highlight = "#${c.base0D}"
        alignment="center"
        max_icon_size = 128
        # hide_text = true
        icon_position="off"
        format = "<span><b>%s %n%%</b></span>\n%b"
        progress_bar_horizontal_alignment = "center"
        timeout = 1

    [z_bright]
        appname="bright"
        background = "#${c.base01}"
        foreground = "#${c.base0A}"
        highlight = "#${c.base0A}"
        alignment="center"
        max_icon_size = 128
        # hide_text = true
        icon_position="off"
        format = "<span><b>%s %n%%</b></span>\n%b"
        progress_bar_horizontal_alignment = "center"
        timeout = 1

    [logger]
        summary="*"
        script="${config.xdg.configHome}/dunst/logger.sh"
  '');
  home.packages = with pkgs; [
    libnotify
    (writeShellApplication {
      name = "dunst-reload";
      runtimeInputs = with pkgs; [procps dunst];
      text = ''
        pkill dunst
        dunst -config ~/.config/dunst/dunstrc &
      '';
    })
    (writeShellApplication {
      name = "dunst-test";
      runtimeInputs = with pkgs; [gnugrep pulseaudio libnotify];
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
}
