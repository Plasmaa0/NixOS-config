{
  description = "Home Manager configuration of plasmaa0";

  inputs = {
    # nixos-hardware.url = "github:NixOS/nixos-hardware";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "github:danth/stylix";
    nixvim.url = "github:nix-community/nixvim";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      config.allowUnfree = true;
      config.nvidia.acceptLicense = true;
      system = "x86_64-linux";
    };
    mkSystem = (
      {
        host,
        homes,
      }:
        nixpkgs.lib.nixosSystem {
          modules = [
            ./hosts/${host}
            {
              networking.hostName = host;
              users.users = nixpkgs.lib.genAttrs homes (user: {
                isNormalUser = true;
                description = user;
                extraGroups = ["networkmanager" "wheel"];
              });
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = {
                  inherit inputs outputs;
                };
                users = nixpkgs.lib.genAttrs homes (user: {
                  imports = [
                    {
                      home.username = user;
                      home.homeDirectory = "/home/${user}";
                    }
                    ./homes/${user}
                    inputs.stylix.homeManagerModules.stylix
                    inputs.nixvim.homeManagerModules.nixvim
                  ];
                });
              };
            }
          ];
          specialArgs = {inherit inputs outputs pkgs home-manager;};
        }
    );
  in {
    nixosConfigurations = {
      nb = mkSystem {
        host = "nb";
        homes = ["plasmaa0"];
      };
    };
  };
}
