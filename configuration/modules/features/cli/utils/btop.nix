{...}: {
  flake.homeModules.cli-utils-btop = {pkgs, ...}: {
    programs.btop = {
      enable = true;
      package = pkgs.btop.override {cudaSupport = true;};
    };
  };
}
