{pkgs, ...}: {
  programs.helix = {
    extraPackages = with pkgs; [
      ccls
      cmake-language-server
      clang-tools
      typos
    ];
    languages = {
      language = [
        {
          name = "cpp";
          scope = "source.cpp";
          language-servers = [
            "clangd"
            "ccls"
            "typos"
          ];
          roots = ["compile-commands.json" ".ccls"];
          indent = {
            tab-width = 2;
            unit = "  ";
          };
          formatter = {
            command = "clang-format";
            args = ["--style=file"];
          };
        }
      ];
      language-server = {
        ccls = {
          command = "ccls";
          args = [
            ("--init="
              +
              # json
              ''
                {
                "index": {"threads": 8}
                }
              '')
          ];
        };
      };
    };
  };
}
