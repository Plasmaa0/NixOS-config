# empty env flake template
{
  description = "%ENV_NAME%";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-%NIX_VERSION%";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
        config = {
          permittedInsecurePackages = [
          ];
          allowUnfree = true;
          allowUnfreePredicate = pkg: true;
        };
      };
    in {
      devShells.default = pkgs.mkShell {
        name = "%ENV_NAME%";
        NIX_CONFIG = "experimental-features = nix-command flakes";
        shellHook = ''
        '';
        nativeBuildInputs = with pkgs; [
        ];
        buildInputs = with pkgs; [
        ];
      };
    });
}
