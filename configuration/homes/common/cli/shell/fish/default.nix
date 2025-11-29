{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    inputs.nix-index-database.homeModules.nix-index
    ./abbrs.nix
    ./aliases.nix
    ./functions.nix
    ./plugins.nix
  ];
  programs = {
    nix-index.enable = true;
    command-not-found.enable = lib.mkForce false;
  };

  home.persistence."/persist/home/${config.home.username}".directories = [".local/share/fish" ".jump"];
  home.packages = with pkgs; [
    jump
  ];
  programs.fish = {
    enable = true;
    shellInit =
      # fish
      ''
        set fish_greeting
        set VIRTUAL_ENV_DISABLE_PROMPT 1
        export MANROFFOPT="-c"
        set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"
        set -U __done_min_cmd_duration 10000
        set -U __done_notification_urgency_level low
      '';
    interactiveShellInit =
      # fish
      ''
        jump shell fish | source
        direnv hook fish | source
        just --completions fish | source
        if status --is-interactive
            source ("starship" init fish --print-full-init | psub)
            function starship_transient_rprompt_func
                starship module time
            end
            enable_transience
        end
        if status --is-interactive && type -q fastfetch
            pokeget random --hide-name | fastfetch --file-raw -
        end

      '';
  };
}
