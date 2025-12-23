{pkgs, ...}: {
  imports = [
    ./editor/helix
    ./editor/markdown-oxide

    ./shell/fish
    ./shell/starship

    ./terminal/alacritty
    ./terminal/wezterm
    ./terminal/kitty

    ./utils/fastfetch
    ./utils/git.nix
    ./utils/yazi
    ./utils/btop.nix
    ./utils/direnv.nix
  ];
  home.packages = with pkgs; [
    eza
    bat
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
}
