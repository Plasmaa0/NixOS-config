{pkgs, ...}: {
  programs.helix = {
    extraPackages = with pkgs; [
      tinymist
      typstyle
    ];
    languages = {
      language = [
        {
          name = "typst";
          language-servers = ["tinymist"];
          auto-format = true;
        }
      ];
      language-server = {
        tinymist = {
          command = "tinymist";
          config = {
            exportPdf = "onType"; # onSave
            formatterMode = "typstyle";
            outputPath = "$root/target/$dir/$name";
            projectResolution = "lockDatabase";
            compileStatus = "enable";
          };
        };
      };
    };
  };
}
