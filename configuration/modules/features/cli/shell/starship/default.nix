{...}: {
  flake.homeModules.cli-shell-starship = {lib, ...}: {
    programs.starship = {
      enable = true;
      settings = {
        format = lib.concatStrings [
          # first row left
          "$username"
          "$hostname"
          "$localip"
          "$shlvl"
          "$singularity"
          "$kubernetes"
          "$directory"
          "$vcsh"
          "$fossil_branch"
          "$fossil_metrics"
          "$git_branch"
          "$git_commit"
          "$git_state"
          "$git_metrics"
          "$git_status"
          "$hg_branch"
          "$pijul_channel"
          "$docker_context"
          "$package"
          "$c"
          "$cmake"
          "$cobol"
          "$daml"
          "$dart"
          "$deno"
          "$dotnet"
          "$elixir"
          "$elm"
          "$erlang"
          "$fennel"
          "$gleam"
          "$golang"
          "$guix_shell"
          "$haskell"
          "$haxe"
          "$helm"
          "$java"
          "$julia"
          "$kotlin"
          "$gradle"
          "$lua"
          "$nim"
          "$nodejs"
          "$ocaml"
          "$opa"
          "$perl"
          "$php"
          "$pulumi"
          "$purescript"
          "$python"
          "$quarto"
          "$raku"
          "$rlang"
          "$red"
          "$ruby"
          "$rust"
          "$scala"
          "$solidity"
          "$swift"
          "$terraform"
          "$typst"
          "$vlang"
          "$vagrant"
          "$zig"
          "$buf"
          "$nix_shell"
          "$conda"
          "$meson"
          "$spack"
          "$memory_usage"
          "$aws"
          "$gcloud"
          "$openstack"
          "$azure"
          "$nats"
          "$direnv"
          "$env_var"
          "$crystal"
          "$sudo"
          "$cmd_duration"

          # first row middle
          "$fill"

          # first row right
          "$time"
          "$line_break"

          # second row left
          "$jobs"
          "$status"
          "$os"
          "$container"
          "$shell"
          "$character"
        ];
        # second row right
        right_format = "$battery";
        add_newline = true;
        fill = {
          symbol = "  ─  ";
          style = "bold purple";
        };
        username = {
          format = " [╭─$user]($style)@";
          show_always = true;
          style_root = "bold red";
          style_user = "bold red";
        };
        hostname = {
          disabled = false;
          format = "[$hostname]($style) in ";
          ssh_only = false;
          style = "bold dimmed red";
          trim_at = "-";
        };
        directory = {
          style = "purple";
          truncate_to_repo = true; # will not work if fish_style_pwd_dir_length is set
          repo_root_style = "bold bright-purple";
          before_repo_root_style = "bold dimmed purple"; # will only apply to truncation symbol if truncate_to_repo is enabled and truncation is set up

          # writing this while using starship 1.24.2, maybe this will get fixed
          # fish_style_pwd_dir_length has more prioriry
          # than truncation_length/symbol.
          # anyways this option fucks everything up:
          # - (before)repo_root_style will not work
          # - truncate_to_repo will not work
          # - truncation_length/symbol will not work
          # so not using it, but leaving this comment here not to forget why
          # fish_style_pwd_dir_length = 2;

          truncation_length = 3;
          truncation_symbol = " ";
        };
        direnv = {
          disabled = false;
          symbol = " ";
          format = "[$symbol:$allowed|$loaded]($style) ";
          allowed_msg = " ";
          not_allowed_msg = " ";
          denied_msg = "󰻌 ";
          loaded_msg = "󰈖 ";
          unloaded_msg = "󰮘 ";
        };
        sudo.disabled = false;
        git_metrics = {
          disabled = false;
          added_style = "bold blue";
          format = "[+$added]($added_style)/[-$deleted]($deleted_style) ";
        };
        git_status = {
          ahead = "⇡ $count";
          behind = "⇣ $count";
          deleted = "x";
          diverged = "⇕⇡ $ahead_count⇣ $behind_count";
          style = "white";
        };
        cmd_duration = {
          disabled = false;
          format = "took [$duration]($style)";
          min_time = 1;
        };
        battery = {
          charging_symbol = "󰂄 ";
          disabled = false;
          discharging_symbol = "󰁹 ";
          full_symbol = "󱟢 ";
          unknown_symbol = "󰂑 "; # when tlp pends charging (ac is connected but battery not charging)
          empty_symbol = "󰂎 ";
          display = [
            {
              style = "blink bold red";
              threshold = 10;
              discharging_symbol = "󰁺 ";
            }
            {
              style = "bold red";
              threshold = 20;
              discharging_symbol = "󰁻 ";
            }
            {
              style = "bold yellow";
              threshold = 30;
              discharging_symbol = "󰁼 ";
            }
            {
              style = "bold yellow";
              threshold = 40;
              discharging_symbol = "󰁽 ";
            }
            {
              style = "yellow";
              threshold = 50;
              discharging_symbol = "󰁾 ";
            }
            {
              style = "yellow";
              threshold = 60;
              discharging_symbol = "󰁿 ";
            }
            {
              style = "yellow";
              threshold = 70;
              discharging_symbol = "󰂀 ";
            }
            {
              style = "green";
              threshold = 80;
              discharging_symbol = "󰂁 ";
            }
            {
              style = "bold green";
              threshold = 90;
              discharging_symbol = "󰂂 ";
            }
            {
              style = "bold green";
              threshold = 100;
              discharging_symbol = "󰁹 ";
            }
          ];
        };
        time = {
          disabled = false;
          format = "[$time]($style)";
          style = "bold purple";
          time_format = "%T";
        };
        character = {
          error_symbol = " [×](bold red)";
          success_symbol = " [╰─λ](bold red)";
        };
        status = {
          disabled = false;
          format = "[$symbol$status_common_meaning$status_signal_name$status_maybe_int]($style)";
          map_symbol = true;
          pipestatus = true;
          symbol = "🔴 ";
        };
        aws.symbol = " ";
        conda.symbol = " ";
        dart.symbol = " ";
        docker_context.symbol = " ";
        elixir.symbol = " ";
        elm.symbol = " ";
        git_branch.symbol = " ";
        golang.symbol = " ";
        hg_branch.symbol = " ";
        java.symbol = " ";
        julia.symbol = " ";
        nim.symbol = " ";
        nix_shell.symbol = "󱄅 ";
        nodejs.symbol = " ";
        package.symbol = "📦 ";
        perl.symbol = " ";
        php.symbol = " ";
        python = {
          symbol = " ";
          format = "via [$symbol $pyenv_prefix ($version )(\($virtualenv\) )]($style)";
        };
        ruby.symbol = " ";
        rust.symbol = " ";
        swift.symbol = "ﯣ ";
      };
    };
  };
}
