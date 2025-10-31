{
  description = "Home Manager configuration of plasmaa0";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://yazi.cachix.org"
      # "https://hyprland.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k="
      # "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };

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
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    helix.url = "github:helix-editor/helix";
    yazi.url = "github:sxyazi/yazi";
    hyprland.url = "github:hyprwm/Hyprland";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:LunaCOLON3/zen-browser-nix";
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
    mkSystem = import ./mkSystem.nix {inherit nixpkgs inputs outputs home-manager;};
    forAllSystems = nixpkgs.lib.genAttrs [
      "aarch64-linux"
      "x86_64-linux"
    ];
  in {
    nixosConfigurations = {
      nb = mkSystem {
        system = "x86_64-linux";
        host = "nb";
        homes = ["plasmaa0"];
      };
      zep = mkSystem {
        system = "x86_64-linux";
        host = "zep";
        homes = ["plasmaa0"];
      };
    };
    devShells = forAllSystems (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in
      import ./shell.nix {inherit pkgs;});
  };
}
