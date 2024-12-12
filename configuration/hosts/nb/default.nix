{
  inputs,
  outputs,
  config,
  ...
}: {
  imports = [
    ./hardware
    ../common
    ../common/modules/steam.nix
    ../common/modules/vial.nix
  ];

  networking.hostName = "nixos"; # Define your hostname.

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs outputs;
    };
    users.plasmaa0.imports = [
      ../../homes/plasmaa0
      inputs.stylix.homeManagerModules.stylix
      inputs.nixvim.homeManagerModules.nixvim
    ];
  };
}

