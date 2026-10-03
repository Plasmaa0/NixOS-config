{...}: {
  flake.homeModules.cli-utils-ai-agents = {pkgs, ...}: let
    codegraph = {
      stdenvNoCC,
      lib,
      fetchurl,
      makeWrapper,
      nodejs,
    }:
      stdenvNoCC.mkDerivation rec {
        pname = "codegraph";
        version = "v1.6.0";

        src = fetchurl {
          url = "https://github.com/colbymchenry/codegraph/releases/download/${version}/codegraph-linux-x64.tar.gz";
          hash = "sha256-3jOR957UJiLZN+bNW3ZCp+qLt9FHNgfoC4ebpz7yFrA=";
        };

        nativeBuildInputs = [makeWrapper];

        dontUnpack = true;
        dontConfigure = true;
        dontBuild = true;

        installPhase = ''
          runHook preInstall

          mkdir -p "$out/share/codegraph"
          tar -xzf "$src" \
            -C "$out/share/codegraph" \
            --strip-components=1

          mkdir -p "$out/bin"

          makeWrapper \
            "$out/share/codegraph/bin/codegraph" \
            "$out/bin/codegraph" \
            --prefix PATH : ${lib.makeBinPath [nodejs]}

          runHook postInstall
        '';

        meta = {
          description = "Local code knowledge graph CLI and MCP server";
          homepage = "https://github.com/colbymchenry/codegraph";
          license = lib.licenses.mit;
          mainProgram = "codegraph";
          platforms = lib.platforms.linux;
        };
      };

    codegraphPkg = pkgs.callPackage codegraph {};
  in {
    # AI coding agents: codegraph (opencode MCP), opencode, oh-my-pi.
    home.packages = [
      codegraphPkg
      pkgs.omp
    ];

    programs.opencode = {
      enable = true;

      settings = {
        "$schema" = "https://opencode.ai/config.json";

        lsp = true;

        mcp.codegraph = {
          enabled = true;
          type = "local";
          command = ["${codegraphPkg}/bin/codegraph" "serve" "--mcp"];
        };
        tools.websearch = true;

        plugin = [
          "opencode-websearch"
          "@tarquinen/opencode-dcp@latest"
          "opencode-mem@latest"
          "openslimedit@latest"
        ];

        permission = {
          webfetch = "allow";
          websearch = "allow";
        };

        provider = {
          "deepseek-anthropic" = {
            npm = "@ai-sdk/anthropic";
            options = {
              baseURL = "https://api.deepseek.com/anthropic";
            };
            models = {
              "deepseek-flash" = {
                name = "DeepSeek V4.1 Flash";
              };
            };
          };
        };
      };
    };

    home.persistence."/persist" = {
      directories = [
        ".config/opencode"
        ".cache/opencode"
        ".local/share/opencode"
        ".local/state/opencode"
        ".opencode-mem"
        # oh-my-pi (omp): `~/.omp` is the global root (agent config/models/
        # history/sessions, logs, marketplaces, stats, caches) and
        # `~/.config/omp` holds agent command files. Its `.omp-sessions` /
        # `.omp-plugin` dirs are created in the *project* cwd, not in $HOME.
        ".omp"
        ".config/omp"
      ];
    };
  };
}
