{
  description = "Home Manager configuration of plasmaa0";

  inputs = {
    # nixos-hardware.url = "github:NixOS/nixos-hardware";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "nixpkgs/nixos-24.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "github:danth/stylix";
    nixvim.url = "github:nix-community/nixvim";
  };

  outputs = { nixpkgs, nixpkgs-stable, home-manager, stylix, nixvim, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        config.allowUnfree = true;
        config.nvidia.acceptLicense = true;
        system = "x86_64-linux";
      };
      pkgs_stable = import nixpkgs-stable {
        config.allowUnfree = true;
        config.nvidia.acceptLicense = true;
        system = "x86_64-linux";
      };
    in {
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          inherit pkgs;
          modules = [ 
            ./common/configuration.nix
            home-manager.nixosModules.home-manager {
              home-manager.users.plasmaa0 = {
                imports = [ 
                  stylix.homeManagerModules.stylix
                  nixvim.homeManagerModules.nixvim
                  ./home.nix
                ];
              }; 
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                inherit pkgs_stable;
                inherit nixvim;
                inherit stylix;
              };
            }
          ];
          specialArgs = {
            inherit pkgs_stable;
            inherit nixvim;
            inherit stylix;
          };
        };
      };
    };
}
