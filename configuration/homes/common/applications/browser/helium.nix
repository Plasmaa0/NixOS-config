{
  inputs,
  pkgs,
  ...
}: let
  helium = inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default;
in {
  programs.browserpass.enable = true;
  home.packages = [helium];
  home.persistence."/persist".directories = [".cache/net.imput.helium" ".config/net.imput.helium"];
  home.sessionVariables.BROWSER = "${helium}/bin/helium";
  home.sessionVariables.DEFAULT_BROWSER = "${helium}/bin/helium";
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
