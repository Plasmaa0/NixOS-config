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
      arimo
      iosevka
      iosevka-term
      iosevka-term-slab
      victor-mono
      fira-code
      droid-sans-mono
      jetbrains-mono
    ]);
  # see also nix_modules/stylix.nix
  fonts.fontconfig = {
    defaultFonts = {
      emoji = ["OpenMoji Color"];
      monospace = ["Iosevka"];
      serif = ["IosevkaTermSlab"];
      sansSerif = ["Arimo"];
    };
  };
}
