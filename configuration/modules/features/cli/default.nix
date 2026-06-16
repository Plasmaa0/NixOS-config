{...}: {
  flake.homeModules.cli-utils-common = {pkgs, ...}: {
    home.packages = with pkgs; [
      eza
      bat
      tabiew
      starship
      ripgrep
      ripgrep-all
      fzf
      skim
      fastfetch
      pokeget-rs
      yad
      fd
      entr
      cloc
      moreutils
      speedtest-cli
      hyperfine
      unzip
      comma
      ncdu
      jq
      file
      gnumake
      just
      glow
      mdcat
      hexd
    ];
  };
}
