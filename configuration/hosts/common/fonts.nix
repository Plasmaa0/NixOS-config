{pkgs, ...}: {
  fonts.fontDir.enable = true;
  fonts.fontconfig.enable = true;
  fonts.packages = with pkgs; [
    # https://github.com/ryanoasis/nerd-fonts/releases/v3.2.1
    (nerdfonts.override {fonts = ["Arimo" "FiraCode" "DroidSansMono" "JetBrainsMono" "Iosevka" "IosevkaTerm" "IosevkaTermSlab" "VictorMono"];})
    iosevka
    noto-fonts
    noto-fonts-color-emoji
    font-awesome
    openmoji-color
  ];
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
