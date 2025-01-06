{
  description = "Home Manager configuration of plasmaa0";

  inputs = {
    # nixos-hardware.url = "github:NixOS/nixos-hardware";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    impermanence.url = "github:nix-community/impermanence";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim.url = "github:nix-community/nixvim";
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
    mkSystem = {
      host,
      homes,
    }:
      nixpkgs.lib.nixosSystem {
        modules = [
          ./hosts/${host}
          {
            networking.hostName = host;
            users.users =
              (nixpkgs.lib.genAttrs homes (user: {
                isNormalUser = true;
                description = user;
                extraGroups = ["networkmanager" "wheel"];
                hashedPasswordFile = toString ./homes/common/secrets/${user}_hashed_password;
              }))
              // {root.hashedPasswordFile = toString ./homes/common/secrets/root_hashed_password;};
            # https://wiki.nixos.org/wiki/Home_Manager#Workaround_with_home_on_tmpfs_and_standalone_installation
            system.activationScripts.profile-init.text = nixpkgs.lib.concatStringsSep "\n" (map
              (user: "ln -sfn /home/${user}/.local/state/nix/profiles/profile /home/${user}/.nix-profile")
              homes);
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
                  inputs.nix-index-database.hmModules.nix-index
                ];
              });
            };
          }
        ];
        specialArgs = {inherit inputs outputs pkgs home-manager;};
      };
  in {
    nixosConfigurations = {
      nb = mkSystem {
        host = "nb";
        homes = ["plasmaa0"];
      };
    };
  };
}
