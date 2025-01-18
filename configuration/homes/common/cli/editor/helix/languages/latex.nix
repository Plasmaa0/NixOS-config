{pkgs, ...}: {
  programs.helix = {
    extraPackages = with pkgs; [
      texlab
      zathura
    ];
    languages = {
      language = [
        {
          name = "latex";
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
        texlab.config.texlab = {
          auxDirectory = "build";
          chktex = {
            onOpenAndSave = true;
            onEdit = true;
          };
          forwardSearch = {
            executable = "zathura";
            args = ["--synctex-forward" "%l:%c:%f" "%p"];
          };
          build = {
            forwardSearchAfter = true;
            onSave = true;
            executable = "latexmk";
            args = ["-pdf" "-interaction=nonstopmode" "-synctex=1" "-shell-escape" "-output-directory=build" "%f"];
          };
        };
      };
    };
  };
}
