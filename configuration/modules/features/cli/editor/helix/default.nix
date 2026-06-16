{...}: {
  flake.homeModules.cli-editor-helix = {
    inputs,
    lib,
    pkgs,
    ...
  }: {
    imports = [
      ./_theme.nix
      ./settings/_default.nix
      ./languages/_default.nix
    ];
    home.persistence."/persist".directories = [".cache/helix" ".local/share/helix"];
    programs.helix = {
      enable = true;
      package = inputs.helix.packages.${pkgs.stdenv.hostPlatform.system}.default;
      defaultEditor = true;
    };
    home.activation.helix_reload = lib.hm.dag.entryAfter ["linkGeneration"] ''
      run ${pkgs.procps}/bin/pkill -USR1 hx || true
    '';
    xdg.configFile = let
      reloadScript = ''
        ${pkgs.procps}/bin/pkill -USR1 hx || true
      '';
    in {
      "helix/config.toml".onChange = reloadScript;
      "helix/languages.toml".onChange = reloadScript;
    };
  };
}
