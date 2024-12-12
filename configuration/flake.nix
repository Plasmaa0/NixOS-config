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

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      inherit (self) outputs;
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        config.allowUnfree = true;
        config.nvidia.acceptLicense = true;
        system = "x86_64-linux";
      };
      mkSystem = modules:
      nixpkgs.lib.nixosSystem {
          inherit modules;
          specialArgs = { inherit inputs outputs pkgs home-manager; };
      };
    in {
      nixosConfigurations = {
        nixos = mkSystem [./hosts/nb];
      };
    };
}
