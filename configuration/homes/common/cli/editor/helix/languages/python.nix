{pkgs, ...}: {
  programs.helix = {
    extraPackages = with pkgs; [
      python312Packages.python-lsp-server
      black
      mypy
      ruff
      taplo
    ];
    languages = {
      language = [
        {
          name = "python";
          auto-format = true;
          language-servers = ["ruff" "pylsp"];
          indent = {
            tab-width = 4;
            unit = "    ";
          };
        }
      ];
      language-server = {
        pylsp.config.pylsp.plugins.pylsp_mypy = {
          enabled = true;
          live_mode = true;
        };
        ruff = {
          command = "ruff";
          args = ["server"];
          environment.RUFF_TRACE = "messages";
          config.settings = {
            logLevel = "debug";
            lineLength = 88;
            indent-width = 4;
            lint = {
              select = ["ALL"];
              ignore = ["INP001" "ERA001" "D1" "ANN" "COM" "T20"];
            };
          };
        };
      };
    };
  };
}
