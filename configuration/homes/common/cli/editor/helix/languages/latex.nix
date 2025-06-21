{pkgs, ...}: {
  programs.helix = {
    extraPackages = with pkgs; [
      texlab
      zathura
      ltex-ls-plus
    ];
    languages = {
      language = [
        {
          name = "latex";
          language-servers = ["texlab" "ltex-ls-plus"];
          formatter = {
            command = "prettier";
            args = ["--parser" "latex-parser"];
          };
          auto-format = true;
          indent = {
            tab-width = 4;
            unit = "    ";
          };
        }
      ];
      language-server = {
        ltex-ls-plus = {
          command = "ltex-ls-plus";
          config = {
            ltex.language = "ru-RU";
          };
        };
        texlab.config.texlab = {
          chktex = {
            onOpenAndSave = true;
            onEdit = true;
          };
          forwardSearch = {
            executable = "zathura";
            args = ["--synctex-forward" "%l:%c:%f" "%p"];
          };
          build = {
            auxDirectory = "build";
            logDirectory = "build";
            pdfDirectory = "build";
            forwardSearchAfter = true;
            onSave = true;
            executable = "latexmk";
            args = [
              "-pdf"
              "-interaction=nonstopmode"
              "-synctex=1"
              "-shell-escape"
              "-output-directory=build"
              "%f"
            ];
          };
        };
      };
    };
  };
}
