{...}: {
  programs.starship = {
    enable = true;
    settings = {
      format = ''$username$hostname$directory$git_branch$git_status$python$sudo$cmd_duration $fill$time$status$character'';
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
        truncate_to_repo = true;
        truncation_length = 0;
        truncation_symbol = "repo: ";
      };
      sudo = {
        disabled = false;
      };
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
        discharging_symbol = "󰁹 "; # displayed when charge is between 90% and 100%
        full_symbol = "󱟢 ";
        unknown_symbol = "󰂑 "; # when tlp pends charging (ac is connected but battery not charging)
        empty_symbol = "󰂎 ";
        display = [
          {
            style = "bold red";
            threshold = 10;
            discharging_symbol = "󰁺 ";
          }
          {
            style = "bold red";
            threshold = 20;
            discharging_symbol = "󰁻 ";
          }
          {
            style = "bold orange";
            threshold = 30;
            discharging_symbol = "󰁼 ";
          }
          {
            style = "bold yellow";
            threshold = 40;
            discharging_symbol = "󰁽 ";
          }
          {
            style = "bold yellow";
            threshold = 50;
            discharging_symbol = "󰁾 ";
          }
          {
            style = "bold yellow";
            threshold = 60;
            discharging_symbol = "󰁿 ";
          }
          {
            style = "bold green";
            threshold = 70;
            discharging_symbol = "󰂀 ";
          }
          {
            style = "bold green";
            threshold = 80;
            discharging_symbol = "󰂁 ";
          }
          {
            style = "bold green";
            threshold = 90;
            discharging_symbol = "󰂂 ";
          }
        ];
      };
      time = {
        disabled = false;
        format = " [$time]($style) \n";
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
      nix_shell.symbol = " ";
      nodejs.symbol = " ";
      package.symbol = " ";
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
}
