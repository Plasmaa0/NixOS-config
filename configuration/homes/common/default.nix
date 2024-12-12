{ config, outputs, ... }: {
  programs.home-manager.enable = true;
  imports = [
    ./secrets/secrets.nix
    ./shell_templates
  
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
    ./qutebrowser.nix
    ./flameshot.nix
    ./copyq.nix
    ./poweralertd.nix
 ];
  # ++ (builtins.attrValues outputs.homeManagerModules);

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.
}
