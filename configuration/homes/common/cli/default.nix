{pkgs, ...}: {
  imports = [
    ./editor/helix
    ./editor/neovim

    ./shell/fish
    ./shell/starship

    ./terminal/alacritty
    ./terminal/wezterm

    ./utils/fastfetch
    ./utils/git.nix
    ./utils/nnn.nix
  ];
  home.packages = with pkgs; [
    eza
    bat
    starship
    ripgrep
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
    glow
    mdcat
    alejandra
    statix
    deadnix
  ];
}
