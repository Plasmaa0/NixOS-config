{...}: {
  flake.homeModules.cli-shell-fish = {
    inputs,
    pkgs,
    lib,
    ...
  }: {
    imports = [
      inputs.nix-index-database.homeModules.nix-index
      ./_binds.nix
      ./_abbrs.nix
      ./_aliases.nix
      ./_functions.nix
      ./_plugins.nix
    ];
    programs = {
      nix-index.enable = true;
      command-not-found.enable = lib.mkForce false;
    };

    home.persistence."/persist".directories = [".local/share/fish" ".local/share/zoxide"];
    home.packages = with pkgs; [zoxide];
    programs.fish = {
      enable = true;
      shellInit = ''
        set fish_greeting
        set VIRTUAL_ENV_DISABLE_PROMPT 1
        export MANROFFOPT="-c"
        set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"
        set -U __done_min_cmd_duration 10000
        set -U __done_notification_urgency_level low
      '';
      interactiveShellInit = ''
        zoxide init --cmd j fish | source
        direnv hook fish | source
        just --completions fish | source

        source ("starship" init fish --print-full-init | psub)
        function starship_transient_rprompt_func
            starship module time
        end
        enable_transience

        pokeget random --hide-name | fastfetch --file-raw -
      '';
    };
  };
}
