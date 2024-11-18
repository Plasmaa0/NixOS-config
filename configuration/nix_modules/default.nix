{ config, ... }: {
  imports = [
    ./stylix.nix
    ./alacritty.nix
    ./helix.nix
    ./i3.nix
    ./picom.nix
    ./wezterm.nix
    ./fish.nix
    ./starship.nix
    ./rofi.nix
    # ./polybar.nix
    ./dunst.nix
    ./git.nix
    ./eww.nix
    ./autorandr.nix
    ./betterlockscreen.nix
    ./fastfetch.nix
    ./nixvim.nix
    ./nnn.nix
 ];
}
