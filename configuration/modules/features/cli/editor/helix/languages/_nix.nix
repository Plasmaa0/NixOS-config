{pkgs, ...}: {
  programs.helix = {
    extraPackages = with pkgs; [
      nil
      alejandra
    ];
    languages = {
      language = [
        {
          name = "nix";
          auto-pairs = {
            "=" = ";";
          };
          auto-format = true;
          indent = {
            tab-width = 2;
            unit = "  ";
          };
          formatter = {
            command = "alejandra";
            args = ["-qq" "-"];
          };
        }
      ];
      language-server = {
        nil.config.nil = {
          formatting.command = ["alejandra -qq -"];
          nix = {
            maxMemoryMB = 4096;
            flake = {
              autoArchive = true;
              autoEvalInputs = true;
            };
          };
        };
      };
    };
  };
}
