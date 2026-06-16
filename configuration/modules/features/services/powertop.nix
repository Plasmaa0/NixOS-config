{...}: {
  flake.homeModules.service-powertop = {pkgs, ...}: {
    home.packages = with pkgs; [
      powertop
    ];
  };
}
