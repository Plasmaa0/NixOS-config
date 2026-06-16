{inputs, ...}: {
  imports = [
    inputs.home-manager.flakeModules.home-manager
  ];

  perSystem = {system, ...}: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
        allowUnfreePredicate = _: true;
      };
    };
  };

  systems = [
    "x86_64-linux"
    "aarch64-linux"
  ];
}
