{...}: {
  programs.starship = {
    enable = true;
    settings = {
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
        charging_symbol = "";
        disabled = true;
        discharging_symbol = "";
        full_symbol = "";
        display = [
          {
            disabled = true;
            style = "bold red";
            threshold = 15;
          }
          {
            disabled = true;
            style = "bold yellow";
            threshold = 50;
          }
          {
            disabled = true;
            style = "bold green";
            threshold = 80;
          }
        ];
      };
      time = {
        disabled = true;
        format = ''
          🕙 $time($style)
        '';
        style = "bright-white";
        time_format = "%T";
      };
      character = {
        error_symbol = " [×](bold red)";
        success_symbol = " [╰─λ](bold red)";
      };
      status = {
        disabled = false;
        format = "[\[$symbol $status_common_meaning $status_signal_name $status_maybe_int\]]($style)";
        map_symbol = true;
        pipestatus = true;
        symbol = "🔴";
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
