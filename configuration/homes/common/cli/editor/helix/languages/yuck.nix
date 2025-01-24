{pkgs, ...}: {
  programs.helix = {
    extraPackages = [
      (pkgs.callPackage (import ./YuckLS-lsp) {})
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
