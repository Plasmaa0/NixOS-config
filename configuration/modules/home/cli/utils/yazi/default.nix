{...}: let
  module = {
    inputs,
    pkgs,
    ...
  }: {
    programs.yazi = {
      enable = true;
      package = inputs.yazi.packages.${pkgs.stdenv.hostPlatform.system}.default;
      enableZshIntegration = false;
      enableBashIntegration = false;
      enableFishIntegration = true;
      settings = {
        opener = {
          image = "qutebrowser";
          video = ["mpv" "vlc"];
          audio = ["mpv"];
          text = ["hx"];
        };
      };
      extraPackages = with pkgs; [
        chafa
        seven-qt
        ffmpegthumbnailer
        jq
        poppler
        fd
        ripgrep
        wl-clipboard
        xclip
      ];
      plugins = {
        compress = ./plugins/compress.yazi;
        "max-preview" = ./plugins/max-preview.yazi;
        restore = ./plugins/restore.yazi;
        "smart-enter" = ./plugins/smart-enter.yazi;
        "smart-filter" = ./plugins/smart-filter.yazi;
      };
    };
  };
in {
  flake.homeModules.cli = module;
}
