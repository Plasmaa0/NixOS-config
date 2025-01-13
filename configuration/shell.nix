{pkgs ? (import ./nixpkgs.nix) {}}: {
  default = pkgs.mkShell {
    name = "nix-config";
    # shellHook = ''
    #   ${pkgs.fish}/bin/fish
    #   exit
    # '';
    # Enable experimental features without having to specify the argument
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
