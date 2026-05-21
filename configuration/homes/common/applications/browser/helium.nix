{
  inputs,
  pkgs,
  ...
}: {
  programs.browserpass.enable = true;
  home.packages = [inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default];
  home.persistence."/persist".directories = [".cache/net.imput.helium" ".config/net.imput.helium"];
  mime.list = [
    {
      mimeTypes = [
        "text/html"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
        "x-scheme-handler/about"
        "x-scheme-handler/unknown"
        "application/xhtml+xml"
      ];
      handler = "helium.desktop";
    }
  ];
}
