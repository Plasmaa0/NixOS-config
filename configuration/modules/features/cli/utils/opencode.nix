{...}: {
  flake.homeModules.cli-utils-opencode = {pkgs, ...}: let
    codegraph = {
      stdenvNoCC,
      lib,
      fetchurl,
      makeWrapper,
      nodejs,
    }:
      stdenvNoCC.mkDerivation rec {
        pname = "codegraph";
        version = "v1.2.0";

        src = fetchurl {
          url = "https://github.com/colbymchenry/codegraph/releases/download/${version}/codegraph-linux-x64.tar.gz";
          hash = "sha256-ptsNHRP+i+lsqucL0ybvVJejtNPnhjb/glAEaUXDOy0=";
        };

        nativeBuildInputs = [makeWrapper];

        dontUnpack = true;
        dontConfigure = true;
        dontBuild = true;

        installPhase = ''
          runHook preInstall
          mkdir -p $out/share/codegraph
          tar -xzf $src -C $out/share/codegraph --strip-components=1
          mkdir -p $out/bin
          makeWrapper $out/share/codegraph/bin/codegraph $out/bin/codegraph \
            --prefix PATH : ${lib.makeBinPath [nodejs]}
          runHook postInstall
        '';

        meta = with lib; {
          description = "Local code knowledge graph CLI and MCP server";
          homepage = "https://github.com/colbymchenry/codegraph";
          license = licenses.mit;
          mainProgram = "codegraph";
          platforms = platforms.linux;
        };
      };
  in {
    home.packages = with pkgs; [opencode (callPackage codegraph {})];
    home.persistence."/persist" = {
      directories = [
        ".config/opencode"
        ".cache/opencode"
        ".local/share/opencode"
        ".local/state/opencode"
      ];
    };
  };
}
