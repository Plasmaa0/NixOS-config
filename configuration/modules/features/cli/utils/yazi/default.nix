{...}: {
  flake.homeModules.cli-utils-yazi = {
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
      shellWrapperName = "y";
      settings = {
        opener = {
          image = "qutebrowser";
          video = ["mpv" "vlc"];
          audio = ["mpv"];
          text = ["hx"];
        };
      };
      plugins = {
        compress = ./plugins/compress.yazi;
        "max-preview" = ./plugins/max-preview.yazi;
        restore = ./plugins/restore.yazi;
        "smart-enter" = ./plugins/smart-enter.yazi;
        "smart-filter" = ./plugins/smart-filter.yazi;
      };
    };

    home.packages = with pkgs; [
      chafa
      ffmpegthumbnailer
      jq
      poppler
      fd
      ripgrep
      wl-clipboard
      xclip
    ];
  };
}
