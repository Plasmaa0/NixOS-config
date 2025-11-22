# refactored https://github.com/ericmckevitt/rmpc-config
# and https://github.com/startup-dotfiles/mpd-clients
{
  pkgs,
  lib,
  config,
  ...
}: let
  extraPackages = with pkgs; [
    cava
  ];
  rmpc-wrapped = pkgs.symlinkJoin {
    name = "rmpc-wrapped";
    paths = [pkgs.rmpc];
    inherit (pkgs.rmpc) version;
    preferLocalBuild = true;
    nativeBuildInputs = [pkgs.makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/${pkgs.rmpc.meta.mainProgram} --suffix PATH : ${lib.makeBinPath extraPackages}
    '';
  };
in {
  programs.rmpc = {
    enable = true;
    package = rmpc-wrapped;
    config =
      # ron (for language injection in syntax highlighting)
      ''
        #![enable(implicit_some)]
        #![enable(unwrap_newtypes)]
        #![enable(unwrap_variant_newtypes)]
        (
            // MPD 🤝 rmpc
            // NOTE: Check your mpd.conf. Ensure the corresponding item's data matches.
            address: "127.0.0.1:6600",     // see `bind_to_address` (Network)
            // address: "/tmp/mpd_socket", // see `bind_to_address` (Socket)
            password: None,                // see `password`

            // Paths
            cache_dir: None,                  // WARNING: Currently used only to store files downloaded from YouTube.
            lyrics_dir: Some("~/data/music"), // WARNING: hardcode

            // Theme
            theme: Some("default"), // -> themes/xxx.ron

            // Performance
            max_fps: 60,
            status_update_interval_ms: 1000,

            // Triggers
            on_song_change: ["~/.config/rmpc/bin/notify",
                             "~/.config/rmpc/bin/playcount"], // when the song changes
            select_current_song_on_change: false,
            keep_state_on_song_change: true,

            // TODO: Themes must be designed for different sizes.
            // See https://mierak.github.io/rmpc/next/guides/on_resize/
            //
            // on_resize: ["~/.config/rmpc/bin/onresize"], // auto change theme for different size.

            // Misc
            volume_step: 5,
            scrolloff: 0,
            wrap_navigation: false,
            enable_mouse: false, // I perfer to use my keyboard.
            enable_config_hot_reload: true, // default enabled

            // ------------------------------------------------------------------------------------

            keybinds: (
                global: {
                    // Show Infos
                    "~":       ShowHelp,
                    "I":       ShowCurrentSongInfo,
                    "O":       ShowOutputs,
                    "P":       ShowDecoders,

                    // Base
                    ":":       CommandMode,
                    "s":       Stop,
                    "q":       Quit,
                    ",":       VolumeDown,    // 󰝞
                    ".":       VolumeUp,      // 󰝝
                    "p":       TogglePause,   //  / 
                    "f":       SeekForward,   // 
                    "b":       SeekBack,      // 
                    ">":       NextTrack,     // next song
                    "<":       PreviousTrack, // previous song

                    // Switch Tabs
                    "1":       SwitchToTab("Main"),
                    "2":       SwitchToTab("Queue"),
                    "3":       SwitchToTab("Lyrics"),
                    // "4":       SwitchToTab("Visualizer"),
                    "4":       SwitchToTab("Directories"),
                    "5":       SwitchToTab("Playlists"),
                    "6":       SwitchToTab("Search"),
                    // "3":       SwitchToTab("Artists"),
                    // "4":       SwitchToTab("Album Artists"),
                    // "5":       SwitchToTab("Albums"),
                    "<Tab>":   NextTab,
                    "<S-Tab>": PreviousTab,

                    // Playback state
                    // NOTE: These options can be combined to produce different effects.
                    // See
                    // - https://github.com/mierak/rmpc/discussions/571
                    // - https://github.com/MusicPlayerDaemon/MPD/issues/539
                    "z":       ToggleRepeat,  // 
                    "x":       ToggleRandom,  // 
                    "c":       ToggleConsume, // Remove played tracks
                    "v":       ToggleSingle,  // Stop after playing all tracks
                },
                navigation: {
                    // Navigation
                    "<Up>":      Up,
                    "<Down>":    Down,
                    "<Left>":    Left,
                    "<Right>":   Right,
                    //// Vim style ////
                    "k":         Up,
                    "j":         Down,
                    "h":         Left,
                    "l":         Right,
                    "<C-k>":     PaneUp,
                    "<C-j>":     PaneDown,
                    "<C-h>":     PaneLeft,
                    "<C-l>":     PaneRight,
                    "g":         Top,
                    "G":         Bottom,
                    "<C-u>":     UpHalf,
                    "<C-d>":     DownHalf,
                    "K":         MoveUp,   // move up a song in queue
                    "J":         MoveDown, // move down a song in queue

                    // Common
                    "/":         EnterSearch,
                    "<Space>":   Select, // mark a `M`

                    // Playlist
                    "a":         Add,    // add a song to the queue from a playlist
                    "A":         AddAll, // add all songs to the queue from a playlist
                    "D":         Delete, // delete a playlist
                    "r":         Rename, // rename a playlist

                    // Popup menu
                    "<C-c>":     Close,
                    "<Esc>":     Close,
                    "<CR>":      Confirm,
                    "N":         PreviousResult,
                    "n":         NextResult,
                    "<C-Space>": InvertSelection,
                    "i":         FocusInput,
                },
                queue: {
                    "<CR>":    Play,     // play the selected track
                    "i":       ShowInfo, // show the selected track's info
                    "C":       JumpToCurrent, // jump to the currently playing track
                    "<C-s>":   Save, // save current queue as new playlist
                    "d":       Delete,    // delete a song in the queue
                    "D":       DeleteAll, // delete all songs in the queue
                    "a":       AddToPlaylist, // add a song in the queue to a playlist
                },
            ),

            // https://mierak.github.io/rmpc/next/configuration/tabs/
            // ----------------------------------------------------------------------
            //        | Queue | Directories | Playlists | Visualizer | Search |
            // -----------------------------------------------------------------------
            tabs: [
                // (
                //     name: "Queue",
                //     pane: Split(
                //         direction: Horizontal,
                //         borders: "ALL",
                //         panes: [
                //             (size: "35%", pane: Split(
                //                 direction: Vertical,
                //                 borders: "RIGHT",
                //                 panes: [
                //                     (size: "80%", pane: Pane(AlbumArt), borders: "BOTTOM"),
                //                     (size: "20%", pane: Pane(Cava)),
                //                 ]
                //             )),
                //             (size: "65%", pane: Split(
                //                 direction: Vertical,
                //                 panes: [
                //                     (size: "40%", pane: Pane(Queue), borders: "BOTTOM"),
                //                     (size: "60%", pane: Pane(Lyrics)),
                //                 ],
                //             )),
                //         ],
                //     ),
                // ),
                (
                    name: "Main",
                    pane: Split(
                        direction: Horizontal,
                        panes: [
                            (size: "40%", pane: Pane(Queue), borders: "RIGHT"),
                            (size: "60%", pane: Pane(Lyrics)),
                            // (size: "60%", pane: Split(
                            //    direction: Vertical,
                            //    panes: [
                            //        (size: "80%", pane: Pane(Lyrics)),
                            //        (size: "20%", pane: Pane(Cava)),
                            //    ]
                            // )),
                        ],
                    ),
                ),
                (
                    name: "Queue",
                    pane: Pane(Queue),
                ),
                (
                    name: "Lyrics",
                    pane: Pane(Lyrics),
                ),
                // (
                //     name: "Visualizer",
                //     pane: Pane(Cava),
                // ),
                (
                    name: "Directories",
                    pane: Pane(Directories),
                ),
                // (
                //    name: "Artists",
                //    pane: Pane(Artists),
                // ),
                // (
                //    name: "Album Artists",
                //    pane: Pane(AlbumArtists),
                // ),
                // (
                //    name: "Albums",
                //    pane: Pane(Albums),
                // ),
                (
                    name: "Playlists",
                    pane: Pane(Playlists),
                ),
                (
                    name: "Search",
                    pane: Pane(Search),
                ),
            ],

            // -> Pane(Search)
            // see `browser_song_format` in themes/default.ron
            search: (
                case_sensitive: false,  // a/A
                mode: Contains,
                tags: [
                    (value: "any",         label: "Any Tag"),
                    (value: "artist",      label: "Artist"),
                    (value: "album",       label: "Album"),
                    (value: "albumartist", label: "Album Artist"),
                    (value: "title",       label: "Title"),
                    (value: "filename",    label: "Filename"),
                    (value: "genre",       label: "Genre"),
                ],
            ),

            // -> Pane(Artists)
            artists: (
                album_display_mode: SplitByDate,
                album_sort_by: Date,
            ),

            // -> Pane(AlbumArt)
            // https://mierak.github.io/rmpc/next/configuration/album-art/#configuration
            album_art: (
                // NOTE: You maybe need to install `kitty` or `ueberzugpp`  which supports display images
                // in your terminal.
                method: Auto, // kitty -> Ueberzug -> Block
                max_size_px: (width: 1200, height: 1200),
                disabled_protocols: ["http://", "https://"],
                vertical_align: Center,
                horizontal_align: Center,
            ),

            // -> Pane(Cava)
            // https://mierak.github.io/rmpc/next/configuration/cava/
            // Theme part: see `cava` in themes/default.ron
            cava: (
                framerate: 60,              // FPS
                autosens: true,             // default true
                sensitivity: 100,           // default 100
                lower_cutoff_freq: 50,      // not passed to cava if not provided
                higher_cutoff_freq: 10000,  // not passed to cava if not provided
                input: (
                    // NOTE: see audio_output in `mpd.conf`
                    // Ensure the corresponding item's data matches.
                    method: Fifo,
                    source: "/tmp/mpd.fifo",
                    sample_rate: 44100,
                    channels: 2,
                    sample_bits: 16,
                ),
                smoothing: (
                    noise_reduction: 77, // default 77
                    monstercat: false,   // default false
                    waves: false,        // default false
                ),
                // this is a list of floating point numbers thats directly passed to cava
                // they are passed in order that they are defined
                eq: []
            ),
        )'';
  };
  xdg.configFile."rmpc/default_album_art.png".source = ./default_album_art.png;
  xdg.configFile."rmpc/bin/notify" = {
    executable = true;
    text =
      # bash
      ''
        #!/usr/bin/env bash
        # Desktop notification on song change
        ## https://mierak.github.io/rmpc/next/guides/on_song_change/#desktop-notification-on-song-change

        # Directory where to store temporary data
        TMP_DIR="/tmp/rmpc"

        # Ensure the directory is created
        mkdir -p "$TMP_DIR"

        # Where to temporarily store the album art received from rmpc
        ALBUM_ART_PATH="$TMP_DIR/notification_cover"

        # Path to fallback album art if no album art is found by rmpc/mpd
        # Change this to your needs.
        DEFAULT_ALBUM_ART_PATH="$HOME/.config/rmpc/default_album_art.png"

        # Save album art of the currently playing song to a file
        if ! rmpc albumart --output "$ALBUM_ART_PATH"; then
            # Use default album art if rmpc returns non-zero exit code
            ALBUM_ART_PATH="''${DEFAULT_ALBUM_ART_PATH}"
        fi

        # Send the notification
        ## TODO: [Customizable] Maybe switch to a different notification program, such as `mako` or `swaync`.
        notify-send -u low -i "''${ALBUM_ART_PATH}" "Now Playing" "$ARTIST - $TITLE"
      '';
  };
  xdg.configFile."rmpc/bin/playcount" = {
    executable = true;
    text =
      # bash
      ''
        #!/usr/bin/env bash
        # Track song play count
        ## https://mierak.github.io/rmpc/next/guides/on_song_change/#track-song-play-count

        sticker=$(rmpc sticker get "$FILE" "playCount" | ${lib.getExe pkgs.jq} -r '.value')
        if [ -z "$sticker" ]; then
            rmpc sticker set "$FILE" "playCount" "1"
        else
            rmpc sticker set "$FILE" "playCount" "$((sticker + 1))"
        fi
      '';
  };
  xdg.configFile."rmpc/themes/default.ron".text = let
    c = let
      c = config.lib.stylix.colors.withHashtag;
    in {
      "dark0" = c.base00; #----
      "dark1" = c.base01; #---
      "dark2" = c.base02; #--
      "dark3" = c.base03; #-
      "light0" = c.base04; #+
      "light1" = c.base05; #++
      "light2" = c.base06; #+++
      "light3" = c.base07; #++++
      "red" = c.base08; #red
      "orange" = c.base09; #orange
      "yellow" = c.base0A; #yellow
      "green" = c.base0B; #green
      "cyan" = c.base0C; #cyan
      "blue" = c.base0D; #blue
      "purple" = c.base0E; #purple
      "brown" = c.base0F; #brown
    };

    # mycolors
    black = ''"${c.dark0}"'';
    dark0 = ''"${c.dark1}"'';
    dark2 = ''"${c.dark2}"'';
    dark3 = ''"${c.dark3}"'';

    white = ''"${c.light0}"'';

    red = ''"${c.red}"'';
    blue = ''"${c.blue}"'';
    green = ''"${c.green}"'';
    yellow = ''"${c.yellow}"'';
    purple = ''"${c.purple}"'';
    pale_yellow = ''"${c.brown}"'';
    cyan = ''"${c.cyan}"'';

    # only use in cava
    light0 = ''"${c.light1}"'';
    pink = ''"${c.red}"'';
    light_blue = ''"${c.cyan}"'';
    pinkish_purple = ''"${c.purple}"'';
    # black = "black";
    # dark0 = "#1e2030";
    # dark2 = "#444444";
    # dark3 = "#68727A";
    # white = "white";
    # red = "#ea403f";
    # blue = "#34B1FF";
    # green = "#8ccf7e";
    # yellow = "#FABD2F";
    # purple = "#af87d7";
    # pale_yellow = "#e5c76b";
    # cyan = "#6cbfbf";
    # # only use in cava
    # light0 = "#b3b9b8";
    # pink = "#e57474";
    # light_blue = "#67b0e8";
    # pinkish_purple = "#c47fd5";
  in
    #ron
    ''
      #![enable(implicit_some)]
      #![enable(unwrap_newtypes)]
      #![enable(unwrap_variant_newtypes)]
      (
          default_album_art_path: None,

          background_color: None,
          header_background_color: None,
          modal_background_color: None,
          modal_backdrop: true, // increased visual clarity
          text_color: None,

          // Item
          highlighted_item_style: (fg: ${black}, bg: ${dark3}, modifiers: "Bold | Italic"),
          current_item_style: (fg: ${black}, bg: ${blue}, modifiers: "Italic"),

          // Border
          draw_borders: true,
          borders_style: (fg: ${green}),
          highlight_border_style: (fg: ${blue}),

          // Misc
          format_tag_separator: " | ",
          lyrics: (
              timestamp: false, // show [00:00]
          ),
          symbols: (song: "S", dir: "D", marker: "M", ellipsis: "..."),

          // ----------------------------------------------------------------------------------------

          tab_bar: (
              // enabled: true, // WARNING: Deprecated
              active_style: (fg: ${black}, bg: ${blue}, modifiers: "Bold"),
              inactive_style: (),
          ),
          progress_bar: (
              symbols: ["-", ">", " "],   // ->
              track_style: (fg: ${dark0}),
              elapsed_style: (fg: ${blue}),
              thumb_style: (fg: ${blue}, bg: ${dark0}),
          ),
          scrollbar: (
              symbols: ["│", "█", "▲", "▼"],
              track_style: (),
              ends_style: (),
              thumb_style: (fg: ${blue}),
          ),

          // NOTE: Components are reusable blocks of panes.
          // https://mierak.github.io/rmpc/next/configuration/layout/#components
          components: {
              "play_state": Pane(Property(
                  content: [
                      (kind: Text("["), style: (fg: ${yellow}, modifiers: "Bold")),
                      (kind: Property(Status(StateV2())), style: (fg: ${yellow}, modifiers: "Bold")),
                      (kind: Text("]"), style: (fg: ${yellow}, modifiers: "Bold")),
                  ],
                  align: Left,
              )),
              "album_title": Pane(Property(
                  content: [
                      (kind: Property(Song(Title)), style: (modifiers: "Bold"),
                          default: (kind: Text("No Song"), style: (modifiers: "Bold")))
                  ],
                  align: Center,
                  scroll_speed: 1
              )),
              "volume": Pane(Property(
                  content: [
                      (kind: Property(Widget(Volume)), style: (fg: ${blue}, modifiers: "Bold")),
                  ],
                  align: Right,
              )),
              "header_1": Split(
                  direction: Horizontal,
                  panes: [
                      (size: "23", pane: Component("play_state")),
                      (size: "100%", pane: Component("album_title")),
                      (size: "23", pane: Component("volume")),
                  ],
              ),
              "progress_time": Pane(Property(
                  content: [
                      (kind: Property(Status(Elapsed))),
                      (kind: Text(" / ")),
                      (kind: Property(Status(Duration))),
                      (kind: Text(" (")),
                      (kind: Property(Status(Bitrate))),
                      (kind: Text(" kbps)"))
                  ],
                  align: Left,
              )),
              "artist_album": Pane(Property(
                  content: [
                      (kind: Property(Song(Artist)), style: (fg: ${yellow}, modifiers: "Bold"),
                          default: (kind: Text("Unknown"), style: (fg: ${yellow}, modifiers: "Bold"))
                      ),
                      (kind: Text(" - ")),
                      (kind: Property(Song(Album)),
                          default: (kind: Text("Unknown Album"))
                      )
                  ],
                  align: Center,
                  scroll_speed: 1
              )),
              "playback_state": Pane(Property(
                  content: [
                      (
                          kind: Property(Widget(States(
                              active_style: (fg: ${white}, modifiers: "Bold"),
                              separator_style: (fg: ${white})))
                          ),
                          style: (fg: "dark_gray")
                      ),
                  ],
                  align: Right,
              )),
              "header_2": Split(
                  direction: Horizontal,
                  panes: [
                      (size: "23", pane: Component("progress_time")),
                      (size: "100%", pane: Component("artist_album")),
                      (size: "23", pane: Component("playback_state")),
                  ],
              ),
          },


          // NOTE: Because terminal font size affects display, you may need to adjust the size manually.
          // https://mierak.github.io/rmpc/next/configuration/layout/
          layout: Split(
              direction: Vertical,
              panes: [
                  (
                      size: "15",
                      pane: Split(
                          direction: Horizontal,
                          panes: [
                              (
                                  size: "20%",
                                  pane: Pane(AlbumArt),
                                  borders: "RIGHT",
                              ),
                              (
                                  size: "80%",
                                  pane: Split(
                                      direction: Vertical,
                                      panes: [
                                          (size: "20%", pane: Pane(Header)),
                                          // (size: "10%", pane: Component("header_1")),
                                          // (size: "10%", pane: Component("header_2")),
                                          (size: "70%", pane: Pane(Cava)),
                                          (size: "10%", pane: Pane(ProgressBar)),
                                      ]
                                  )
                              ),
                          ]
                      ),
                  ),
                  (
                      size: "6%",
                      pane: Pane(Tabs),
                  ),
                  (
                      size: "70%",
                      pane: Pane(TabContent),
                  ),
              ],
          ),

          // -> Pane(Header)
          // https://mierak.github.io/rmpc/next/configuration/header/
          // --------------------------------------------------------------------
          // [Playing/Paused]         Song Title                 Volume: ▁▂▃▄▅▆▇█
          // 0:38/3:09 (192 kbps)   Artist - Album    Repeat/Random/Cosume/Single
          // --------------------------------------------------------------------
          header: (
              rows: [
                  (
                      // State: [Playing/Paused/...]
                      left: [
                          (kind: Text("[ "), style: (fg: ${yellow}, modifiers: "Bold")),
                          // (kind: Property(Status(State)), style: (fg: ${yellow}, modifiers: "Bold")),
                          (kind: Property(Status(StateV2(
                              playing_label: " Playing", playing_style: (fg: ${yellow}),
                              paused_label: " Paused", paused_style: (fg: ${yellow}),
                              stopped_label: " Stopped", stopped_style: (fg: ${yellow}),
                          )))),
                          (kind: Text(" ]"), style: (fg: ${yellow}, modifiers: "Bold")),

                          (kind: Text(" ("), style: (fg: ${purple})),
                          (kind: Property(Status(QueueTimeTotal(separator: "/"))), style: (fg: ${purple})),
                          (kind: Text("<"), style: (fg: ${purple})),
                          (kind: Property(Status(QueueLength(thousands_separator: ","))), style: (fg: ${purple})),
                          (kind: Text(">"), style: (fg: ${purple})),
                          (kind: Text(")"), style: (fg: ${purple})),
                      ],
                      // Song Title
                      center: [
                          (kind: Property(Song(Title)), style: (fg: ${red}, modifiers: "Bold"),
                              default: (kind: Text("No Song"), style: (modifiers: "Bold"))
                          )
                      ],
                      // Volume: ▁▂▃▄▅▆▇█
                      right: [
                          (kind: Property(Widget(ScanStatus)), style: (fg: ${green})),
                          (kind: Property(Widget(Volume)), style: (fg: ${green}))
                      ]
                  ),
                  (
                      // [ 0:38/3:09 ] (192 kbps)
                      left: [
                          (kind: Text("[ "), style: (fg: ${yellow}, modifiers: "Bold")),
                          (kind: Property(Status(Elapsed)), style: (fg: ${yellow})),
                          (kind: Text("/"),style: (fg: ${yellow})),
                          (kind: Property(Status(Duration)),style: (fg: ${yellow})),
                          (kind: Text(" ]"), style: (fg: ${yellow}, modifiers: "Bold")),
                          (kind: Text(" ("), style: (fg: ${purple})),
                          (kind: Property(Status(Bitrate)), style: (fg: ${purple})),
                          (kind: Text(" kbps)"), style: (fg: ${purple})),
                      ],
                      // Artist - Album
                      center: [
                          (kind: Property(Song(Artist)), style: (fg: ${yellow}, modifiers: "Bold"),
                              default: (kind: Text("Unknown"), style: (fg: ${yellow}, modifiers: "Bold"))
                          ),
                          (kind: Text(" - ")),
                          (kind: Property(Song(Album)), style: (fg: ${green}),
                              default: (kind: Text("Unknown Album"))
                          )
                      ],
                      // Repeat/Random/Cosume/Single
                      right: [
                          // (
                          //    kind: Property(Widget(States(
                          //        active_style: (fg: ${white}, modifiers: "Bold"),
                          //        separator_style: (fg: ${white})))
                          //    ),
                          //    style: (fg: "dark_gray")
                          // ),
                          (kind: Text("[ "), style: (fg: ${blue})),
                          (kind: Property(Status(RepeatV2(
                              on_label: " ", on_style: (fg: ${blue}),
                              off_label: " ", off_style: (fg: ${dark2}),
                          )))),
                          (kind: Text(" | "), style: (fg: ${blue})),
                          (kind: Property(Status(RandomV2(
                              on_label: " ", on_style: (fg: ${blue}),
                              off_label: " ", off_style: (fg: ${dark2}),
                          )))),
                          (kind: Text(" | "), style: (fg: ${blue})),
                          (kind: Property(Status(ConsumeV2(
                              on_label: "󰮯 ", on_style: (fg: ${blue}),
                              off_label: "󰮯 ", off_style: (fg: ${dark2}),
                              oneshot_label: " ", oneshot_style: (fg: ${blue}),
                          )))),
                          (kind: Text(" | "), style: (fg: ${blue})),
                          (kind: Property(Status(SingleV2(
                              on_label: "󰎤 ", on_style: (fg: ${blue}),
                              off_label: "󰎤 ", off_style: (fg: ${dark2}),
                              oneshot_label: " ", oneshot_style: (fg: ${blue}),
                          )))),
                          (kind: Text("]"), style: (fg: ${blue})),
                      ]
                  ),
              ],
          ),

          // https://mierak.github.io/rmpc/next/configuration/song-table/
          //          Title       Artist       Album       Duration
          // ------------------------------------------------------------
          // Sticker: https://github.com/jcorporation/mpd-stickers
          show_song_table_header: true, // NOTE: enable it
          song_table_album_separator: None,
          song_table_format: [
              (
                  prop: (kind: Sticker("playCount"),  // NOTE: see `on_song_change` in config.ron and the bin/playcount script
                      default: (kind: Text("0")),
                  ),
                  width: "5%",
              ),
              (
                  prop: (kind: Property(Title), style: (fg: ${dark3}),
                      default: (kind: Text("Unknown"))
                  ),
                  width: "30%",
              ),
              (
                  prop: (kind: Property(Artist), style: (fg: ${pale_yellow}),
                      default: (kind: Text("Unknown"), style: (fg: ${white}))
                  ),
                  width: "20%",
                  alignment: Left,
              ),
              (
                  prop: (kind: Property(Album), style: (fg: ${cyan}),
                      default: (kind: Text("Unknown Album"), style: (fg: ${white}))
                  ),
                  width: "30%",
              ),
              (
                  prop: (kind: Property(Duration), style: (fg: ${white}, modifiers: "Italic"),
                      default: (kind: Text("-"))
                  ),
                  width: "15%",
                  alignment: Right,
              ),
          ],

          preview_label_style: (fg: ${yellow}),
          preview_metadata_group_style: (fg: ${yellow}, modifiers: "Bold"),
          browser_column_widths: [20, 38, 42],
          browser_song_format: [
              (
                  kind: Group([
                      (kind: Property(Track)),
                      (kind: Text(" ")),
                  ])
              ),
              (
                  kind: Group([
                      (kind: Property(Artist)),
                      (kind: Text(" - ")),
                      (kind: Property(Title)),
                  ]),
                  default: (kind: Property(Filename))
              ),
          ],

          // -> Pane(Cava)
          // https://mierak.github.io/rmpc/next/configuration/cava/
          cava: (
              // symbols that will be used to draw the bar in the visualiser, in ascending order of
              // fill fraction
              bar_symbols: ['▁', '▂', '▃', '▄', '▅', '▆', '▇', '█'],
              // similar to bar_symbols but these are used for the top-down rendering, meaning for orientation
              // "Horizontal" and "Top"
              inverted_bar_symbols: ['▔', '🮂', '🮃', '▀', '🮄', '🮅', '🮆', '█'],

              // bg_color: ${black}, // background color, defaults to rmpc's bg color if not provided
              bar_width: 1,   // width of a single bar in columns
              bar_spacing: 1, // free space between bars in columns

              // Possible values are "Top", "Bottom" and "Horizontal". Top makes the bars go from top to
              // bottom, "Bottom" is from bottom up, and "Horizontal" is split in the middle with bars going
              // both down and up from there.
              // Using non-default symbols with "Top" and "Horizontal" may produce undesired output.
              orientation: Bottom,
              // orientation: Horizontal,

              // Colors can be configured in three different ways: a single color, different colors
              // per row and a gradient. You can use the same colors as everywhere else. Only specify
              // one of these:

              // Every bar symbol will be red
              // bar_color: Single("red"),

              // The first two rows(two lowest amplitudes) will be red, after that two green rows
              // and the rest will be blue. You can have as many as you want here. The last value
              // will be used if the height exceeds the length of this array.
              // bar_color: Rows([
              //   "red",
              //   // "red",
              //   "green",
              //   // "green",
              //   "blue",
              // ])

              // A simple color gradient. This is a map where keys are percent values of the height
              // where the color starts. After that it is linearly interpolated towards the next value.
              // In this example, the color will start at green for the lowest amplitudes, go towards
              // blue at half amplitudes and finishing as red for the highest values. Keys must be between
              // 0 and 100 and if the first or last key are not 0 and 100 respectively, the lowest and highest
              // value will be used as 0 and 100. Only hex and RGB colors are supported here and your terminal
              // must support them as well!
               bar_color: Gradient({
                 // 0: "rgb(  0, 255,   0)",
                 // 50: "rgb(  0,   0, 255)",
                 // 100: "rgb(255,   0,   0)",
                 0:   ${pink},
                 16:  ${green},
                 32:  ${pale_yellow},
                 48:  ${light_blue},
                 64:  ${pinkish_purple},
                 80:  ${cyan},
                 100: ${light0},
               })
          ),
      )
    '';
}
