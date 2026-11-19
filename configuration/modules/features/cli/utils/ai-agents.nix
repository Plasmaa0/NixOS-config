{...}: {
  flake.homeModules.cli-utils-ai-agents = {
    pkgs,
    config,
    lib,
    inputs,
    ...
  }: let
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

    ompTheme = let
      c = config.lib.stylix.colors.withHashtag;
      theme = {
        name = "stylix";
        vars = {
          bg = c.base00;
          bgAlt = c.base01;
          bgAlt2 = c.base02;
          fgMuted = c.base04;
          fg = c.base05;
          red = c.base08;
          orange = c.base09;
          yellow = c.base0A;
          green = c.base0B;
          cyan = c.base0C;
          blue = c.base0D;
          gold = c.base0E;
          brown = c.base0F;
        };
        colors = {
          accent = "blue";
          border = "fg";
          borderAccent = "blue";
          borderMuted = "fgMuted";
          success = "green";
          error = "red";
          warning = "yellow";
          muted = "fgMuted";
          dim = "fgMuted";
          text = "";
          thinkingText = "fgMuted";

          selectedBg = "bgAlt2";
          userMessageBg = "bgAlt";
          userMessageText = "";
          customMessageBg = "bgAlt";
          customMessageText = "";
          customMessageLabel = "gold";
          toolPendingBg = "bgAlt";
          toolSuccessBg = "bgAlt";
          toolErrorBg = "bgAlt";
          toolTitle = "";
          toolOutput = "fgMuted";

          mdHeading = "blue";
          mdLink = "cyan";
          mdLinkUrl = "fgMuted";
          mdCode = "gold";
          mdCodeBlock = "gold";
          mdCodeBlockBorder = "fgMuted";
          mdQuote = "fgMuted";
          mdQuoteBorder = "fgMuted";
          mdHr = "fgMuted";
          mdListBullet = "blue";

          toolDiffAdded = "green";
          toolDiffRemoved = "red";
          toolDiffContext = "fgMuted";

          syntaxComment = "fgMuted";
          syntaxKeyword = "gold";
          syntaxFunction = "blue";
          syntaxVariable = "fg";
          syntaxString = "green";
          syntaxNumber = "orange";
          syntaxType = "yellow";
          syntaxOperator = "cyan";
          syntaxPunctuation = "fg";

          thinkingOff = "brown";
          thinkingMinimal = "fgMuted";
          thinkingLow = "cyan";
          thinkingMedium = "blue";
          thinkingHigh = "gold";
          thinkingXhigh = "red";
          thinkingMax = "orange";

          bashMode = "cyan";
          pythonMode = "yellow";

          statusLineBg = "bgAlt";
          statusLineSep = "fgMuted";
          statusLineModel = "gold";
          statusLinePath = "blue";
          statusLineGitClean = "green";
          statusLineGitDirty = "yellow";
          statusLineContext = "cyan";
          statusLineSpend = "orange";
          statusLineStaged = "green";
          statusLineDirty = "yellow";
          statusLineUntracked = "red";
          statusLineOutput = "fg";
          statusLineCost = "orange";
          statusLineSubagents = "blue";
        };
      };
    in
      (pkgs.formats.json {}).generate "stylix.json" theme;

    ompFishCompletions = pkgs.runCommand "omp-fish-completions" {} ''
      mkdir -p "$out"
      HOME="$TMPDIR" ${config.programs.omp.package}/bin/omp completions fish > "$out/omp.fish"
    '';

    ompConfigSeed = (pkgs.formats.yaml {}).generate "omp-config-seed.yml" {
      theme = {
        dark = "stylix";
        light = "stylix";
      };
      tools.approvalMode = "write";
    };
  in {
    imports = [inputs.omp.homeManagerModules.default];

    home.packages = [codegraphPkg];
    home.file.".omp/agent/themes/stylix.json".source = ompTheme;

    xdg.configFile."fish/completions/omp.fish".source = "${ompFishCompletions}/omp.fish";
    home.activation.ompConfigSeed = lib.hm.dag.entryAfter ["linkGeneration"] ''
      ompConfig="$HOME/.omp/agent/config.yml"
      if [ -e "$ompConfig" ]; then
        if ! grep -qE '^theme:' "$ompConfig"; then
          run ${config.programs.omp.package}/bin/omp config set theme.dark stylix
          run ${config.programs.omp.package}/bin/omp config set theme.light stylix
        fi
        if ! grep -qE '^[[:space:]]+approvalMode:' "$ompConfig"; then
          run ${config.programs.omp.package}/bin/omp config set tools.approvalMode write
        fi
      else
        run mkdir -p "$HOME/.omp/agent"
        run install -m 600 ${ompConfigSeed} "$ompConfig"
      fi
    '';

    programs.omp.enable = true;

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
