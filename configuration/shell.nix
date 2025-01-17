{pkgs ? (import ./nixpkgs.nix) {}}: {
  default = pkgs.mkShell {
    name = "nix-config";
    NIX_CONFIG = "experimental-features = nix-command flakes";
    nativeBuildInputs = with pkgs; [
      nix
      home-manager
      git
      gnumake
      cloc
      alejandra
      statix
      deadnix
      nix-inspect
    ];
  };
}
