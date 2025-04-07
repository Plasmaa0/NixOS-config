{pkgs, ...}: {
  programs.helix = {
    extraPackages = with pkgs; [
      ccls
      cmake-language-server
      clang-tools
    ];
    languages = {
      language = [
        {
          name = "cpp";
          scope = "source.cpp";
          language-servers = ["ccls" "clangd"];
          roots = ["compile-commands.json" ".ccls"];
          indent = {
            tab-width = 2;
            unit = "  ";
          };
        }
      ];
      language-server = {
        ccls = {
          command = "ccls";
          args = [];
        };
      };
    };
  };
}
