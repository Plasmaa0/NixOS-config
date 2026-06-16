{inputs, ...}: {
  imports = [
    inputs.devshell.flakeModule
  ];

  perSystem = {pkgs, ...}: {
    devshells.default = {
      name = "home-manager";
      motd = ''
        {196}⚡ {bold}home-manager{reset} devshell
      '';

      env = [
        {
          name = "NIX_CONFIG";
          value = "experimental-features = nix-command flakes";
        }
      ];

      packages = with pkgs; [
        nix
        home-manager
        git
        gnumake
        just
        fd
        cloc
        alejandra
        statix
        deadnix
        nix-inspect
        opencode
      ];
    };
  };
}
