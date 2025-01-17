{pkgs, ...}: {
  programs.yazi = {
    enable = true;
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
          # drag&drop FROM yazi popup for current selection
          on = ["<C-o>"];
          run = ''shell '${dragon} -A -x -T "$@"' '';
        }
        {
          # drag&drop TO yazi current directory
          on = ["<C-i>"];
          run = let
            files = ''"$(${dragon} -t -p -k -T)"'';
            destination = ''"$(${realpath} "$0" | ${xargs} ${dirname})"''; #yazi cursor is always hovering directory or file so dirname(realpath($0)) will be current directory
            getfiles = ''${cp} ${files} ${destination}'';
          in [
            ''shell '${getfiles} 2> /dev/null' ''
          ];
        }
        {
          # yank current selection in system clipboard
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
