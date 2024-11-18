{ config, lib, ... }: 
let
  c = config.lib.stylix.colors;
in 
{
  services.dunst.enable = true;
  # services.dunst.configFile = ../dotfiles/dunst/dunstrc;
  # home.file."${config.xdg.configHome}/dunst/dunstrc".text = ''
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
    font = "Iosevka NerdFont"
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

    icon_path = "/usr/share/icons/Paper/48x48/status/:/usr/share/icons/Paper/48x48/devices/:/usr/share/icons/Paper/48x48/apps/"

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

[Cider]
    appname="Cider"
    background = "#9F3046"
    foreground = "#DACDD1"
    frame_color = "#B7B5BA"
    timeout = 10

[volume]
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

[bright]
    appname="bright"
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
  '');
}
