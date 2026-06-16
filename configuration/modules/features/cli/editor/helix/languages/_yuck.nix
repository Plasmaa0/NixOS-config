{pkgs, ...}: {
  programs.helix = {
    extraPackages = [
      (pkgs.callPackage (import ./YuckLS-lsp/_default.nix) {})
    ];
    languages = {
      language = [
        {
          name = "yuck";
          scope = "source.yuck";
          injection-regex = "yuck";
          file-types = ["yuck"];
          language-servers = ["yuckls"];
        }
      ];
      language-server = {
        yuckls = {command = "YuckLS";}; #if installed from aur
      };
    };
  };
}
