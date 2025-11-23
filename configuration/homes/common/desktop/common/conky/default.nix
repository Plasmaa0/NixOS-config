{
  pkgs,
  config,
  hidpiScalingFactor,
  ...
}: {
  # https://github.com/stanipintjuk/immutable-rice/blob/master/conky/conky-conf.nix
  # https://github.com/alejandromurciano/conkynixtheme/blob/master/conkynixtheme.nix
  # https://github.com/alejnd/conky_L3F2T_theme/blob/master/conkyrc
  xsession.windowManager.i3.config.startup = [
    {
      notification = false;
      always = true;
      command = "${pkgs.killall}/bin/killall conky; ${pkgs.conky}/bin/conky";
    }
  ];
  xdg.configFile."conky/conky.conf".text = let
    ch = config.lib.stylix.colors.withHashtag;
    c = config.lib.stylix.colors;
    battery-health-app = pkgs.writeShellApplication {
      name = "battery-health";
      runtimeInputs = with pkgs; [gnugrep coreutils upower];
      text = ''
        upower -d | grep capacity: | tr -s " " | cut -c 12-
      '';
    };
    battery-health = "${battery-health-app}/bin/battery-health";
  in
    # conf
    ''
      conky.config = {
          alignment = 'top_right',
          background = false,
          border_width = 1,
          cpu_avg_samples = 5,
          default_color = 'white',
          default_outline_color = 'white',
          default_shade_color = 'white',
          double_buffer = true,
          draw_borders = false,
          draw_graph_borders = true,
          draw_outline = false,
          draw_shades = false,
          extra_newline = false,
          font = '${config.stylix.fonts.monospace.name}:size=10',
          gap_x = ${toString (builtins.ceil (30 * hidpiScalingFactor))},
          gap_y = ${toString (builtins.ceil (30 * hidpiScalingFactor))},
          minimum_height = 5,
          minimum_width = 5,
          net_avg_samples = 5,
          no_buffers = true,
          out_to_console = false,
          out_to_ncurses = false,
          out_to_stderr = false,
          out_to_wayland = false,
          out_to_x = true,
          own_window = true,
          own_window_class = 'Conky',
          own_window_type = 'override',
          own_window_hints = 'undecorated,sticky,below,skip_taskbar,skip_pager',
          own_window_argb_visual = true,
          own_window_argb_value = 255,
          own_window_colour = '${ch.base00}',
          own_window_transparent = false,
          show_graph_range = false,
          show_graph_scale = false,
          stippled_borders = 0,
          update_interval = 1.0,
          uppercase = false,
          use_spacer = 'none',
          use_xft = true,
      }

      -- Variables: https://conky.cc/variables
      conky.text = [[
      ''${image ${pkgs.nixos-icons}/share/icons/hicolor/256x256/apps/nix-snowflake.png -p 2, 1 -s 64x64}
      ''${voffset -35}

      ''${offset 64} ''${color ${ch.base07}} NixOS: ''${color ${ch.base05}} ''${execi 3000 echo $(source /etc/os-release; echo $VERSION)}
      ''${offset 64} ''${color ${ch.base07}} Kernel:''${color ${ch.base05}} ''${kernel}
      ''${voffset -5}
      ''${hr 1}

      #
      # Battery
      #
      ''${voffset -30}
      ''${font mono bold:size=16}''${color ${ch.base07}}BAT ''${color ${ch.base0E}}''${voffset 4}''${battery_bar 16,0 BAT1}
      ''${voffset -40}
      ''${offset 10}$font''${color ${ch.base06}} Status: ''${color ${ch.base04}}''${battery_status BAT1}''${alignr}''${offset -10}$font''${color ${ch.base06}}Percent: ''${color ${ch.base04}}''${battery_percent BAT1}%
      ''${offset 10}$font''${color ${ch.base06}} Left: ''${color ${ch.base04}}''${battery_time BAT1}''${alignr}''${offset -10}$font''${color ${ch.base06}}Power: ''${color ${ch.base04}}''${battery_power_draw BAT1}W
      ''${offset 10}$font''${color ${ch.base06}} Health: ''${color ${ch.base04}}''${execi 300 ${battery-health}}''${color ${ch.base0D}}
      ''${hr 1}


      #
      # CPU
      #
      ''${voffset -40}
      ''${font mono bold:size=16}''${color ${ch.base07}}CPU ''${color ${ch.base0E}}''${cpugraph ${c.base0E} ${c.base06}}
      ''${voffset -30}
      ''${offset 10}''${color ${ch.base06}}$font Freq: ''${color ${ch.base04}}''${freq 1}Mhz ''${alignr}''${offset -10}''${color ${ch.base06}}Temp:''${color ${ch.base04}}''${hwmon 2 temp 1}°C''${color white}
      ''${offset 10}''${color ${ch.base06}}$font Load: ''${color ${ch.base04}}$loadavg ''${color ${ch.base06}} ''${alignr}''${offset -10}Procs:''${color ${ch.base04}}$processes''${color white}
      ''${color ${ch.base0D}}
      ''${voffset -35}
      ''${offset 0}$font   - ''${color ${ch.base09}}''${top name 1} ''${alignr} ''${color ${ch.base09}}''${top cpu 1}  ''${color ${ch.base0D}}
      ''${offset 0}$font   - ''${color ${ch.base0B}}''${top name 2} ''${alignr}''${color ${ch.base0A}}''${top cpu 2}  ''${color ${ch.base0D}}
      ''${offset 0}$font   - ''${color ${ch.base0B}}''${top name 3} ''${alignr}''${color ${ch.base0A}}''${top cpu 3}  ''${color ${ch.base0D}}
      # ''${offset 0}$font   - ''${color ${ch.base0B}}''${top name 4} ''${alignr}''${color ${ch.base0A}}''${top cpu 4}  ''${color ${ch.base0D}}
      ''${hr 1}

      #
      # MEMORY
      #
      ''${voffset -30}
      ''${font :size=16}''${color ${ch.base07}}MEMORY ''${color ${ch.base0E}}''${memgraph ${c.base0E} ${c.base06}} ''${color ${ch.base0D}}
      ''${offset 10}''${color ${ch.base06}}$font Mem:  ''${color ${ch.base04}}$mem/$memmax ''${color #6E8B3D}''${alignr}''${offset -10}''${membar 10,60}
      ''${offset 10}''${color ${ch.base06}}$font Swap: ''${color ${ch.base04}}$swap/$swapmax ''${color #6E8B3D}''${alignr}''${offset -10}''${swapbar 10,60}
      ''${color ${ch.base0D}}
      ''${voffset -35}
      ''${offset 0}$font   - ''${color ${ch.base09}}''${top_mem name 1} ''${alignr} ''${color ${ch.base09}}''${top_mem mem_res 1}  ''${color ${ch.base0D}}
      ''${offset 0}$font   - ''${color ${ch.base0B}}''${top_mem name 2} ''${alignr} ''${color ${ch.base0A}}''${top_mem mem_res 2}  ''${color ${ch.base0D}}
      ''${offset 0}$font   - ''${color ${ch.base0B}}''${top_mem name 3} ''${alignr} ''${color ${ch.base0A}}''${top_mem mem_res 3}  ''${color ${ch.base0D}}
      # ''${offset 0}$font   - ''${color ${ch.base0B}}''${top_mem name 4} ''${alignr} ''${color ${ch.base0A}}''${top_mem mem_res 4}  ''${color ${ch.base0D}}
      # ''${offset 0}$font   - ''${color ${ch.base0B}}''${top_mem name 5} ''${alignr} ''${color ${ch.base0A}}''${top_mem mem_res 5}  ''${color ${ch.base06}}
      $if_mpd_playing''${hr 1}$else''${voffset -50}$endif

      #
      # MPD
      #
      $if_mpd_playing
        ''${voffset -55}
        ''${execi 5 ${pkgs.mpc}/bin/mpc albumart "$(${pkgs.mpc}/bin/mpc current -f "%file%")" > /tmp/cover}
        ''${image /tmp/cover -p 0, 500 -s 64x64 -f 5}
        ''${voffset -30}''${offset 55}''${color ${c.base04}}$alignr''${color ${c.base06}}''${scroll wait 20 ''${mpd_title 30}}
        ''${offset 55}''${color ${c.base04}}$alignr''${color ${c.base06}}''${scroll wait 20 ''${mpd_albumartist}}
        ''${offset 55}''${color ${c.base04}}󱍙$alignr''${color ${c.base06}}''${scroll wait 20 ''${mpd_album}}
        $alignr''${color ${c.base04}}''${mpd_elapsed} ''${color ${c.base0E}}''${mpd_bar 16, 100} ''${color ${c.base04}}''${mpd_length}
        ''${offset -80}''${mpd_status}
        ''${voffset -60}
      $endif
      ]]
    '';
}
