{
  inputs,
  pkgs,
  ...
}: {
  home.packages = [inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default];
  home.persistence."/persist".directories = [".cache/net.imput.helium" ".config/net.imput.helium"];
}
