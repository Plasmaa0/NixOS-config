{
  pkgs,
  lib,
  config,
  ...
}: {
  home.packages = [pkgs.trash-cli];
  home.persistence."/persist/home/${config.home.username}".directories = [".local/share/Trash"];
  programs.yazi = {
    enable = true;
    plugins = let
      plugin-list = builtins.attrNames (builtins.readDir ./plugins);
      remove-yazi-extension = filename: lib.elemAt (builtins.split ".yazi" filename) 0;
      sanitized-plugin-list = map remove-yazi-extension plugin-list;
      plugins-result = lib.genAttrs sanitized-plugin-list (name: ./plugins/${name}.yazi);
    in
      plugins-result;
    keymap = {
      manager.prepend_keymap = let
        echo = "${pkgs.coreutils}/bin/echo";
        realpath = "${pkgs.coreutils}/bin/realpath";
        dirname = "${pkgs.coreutils}/bin/dirname";
        cp = "${pkgs.coreutils}/bin/cp";
        xargs = "${pkgs.findutils}/bin/xargs";
        xclip = "${pkgs.xclip}/bin/xclip";
        dragon = "${pkgs.xdragon}/bin/dragon";
      in [
        {
          on = "u";
          run = "plugin restore";
          desc = "Restore last deleted files/folders";
        }
        {
          desc = "drag&drop FROM yazi. Popup from current selection.";
          on = ["<C-o>"];
          run = ''shell '${dragon} -A -x -T "$@"' '';
        }
        {
          desc = "drag&drop TO yazi current directory";
          on = ["<C-i>"];
          run = let
            files = ''"$(${dragon} -t -p -k -T -x)"'';
            destination = ''"$(${realpath} "$0" | ${xargs} ${dirname})"''; #yazi cursor is always hovering directory or file so dirname(realpath($0)) will be current directory
            getfiles = ''${cp} ${files} ${destination}'';
          in [
            ''shell '${getfiles} 2> /dev/null' ''
          ];
        }
        {
          desc = "yank current selection in system clipboard";
          on = ["y"];
          run = let
            to_uri = ''{ for i in "$@"; do ${echo} -en "file://$(${realpath} "''${i}")\n"; done }'';
            copy = ''${xclip} -i -sel c -rmlastnl -t text/uri-list'';
            cpfiles = ''${to_uri} | ${copy}'';
          in [
            ''shell '${cpfiles}' ''
            "yank"
          ];
        }
      ];
    };
  };
}
