{pkgs, ...}: {
  fonts.fontDir.enable = true;
  fonts.fontconfig.enable = true;
  fonts.packages = with pkgs;
    [
      iosevka
      noto-fonts
      noto-fonts-color-emoji
      font-awesome
      openmoji-color
    ]
    ++ (with pkgs.nerd-fonts; [
      iosevka
      iosevka-term
      iosevka-term-slab
      victor-mono
      fira-code
      droid-sans-mono
      jetbrains-mono
      fantasque-sans-mono
    ]);
  # see also nix_modules/stylix.nix
  fonts = {
    enableGhostscriptFonts = true;
    fontconfig = {
      defaultFonts = {
        emoji = ["Noto Color Emoji" "OpenMoji Color"];
        serif = ["IosevkaTermSlab Nerd Font"];
        sansSerif = ["Iosevka Nerd Font"];
        monospace = ["IosevkaTerm Nerd Font"];
      };
    };
  };
}
