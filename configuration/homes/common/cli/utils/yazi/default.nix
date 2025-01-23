{
  pkgs,
  lib,
  config,
  ...
}: {
  # list of useful plugins i found https://github.com/yazi-rs/plugins
  # TODO: look into https://github.com/yazi-rs/plugins/tree/main/mount.yazi
  home.packages = [pkgs.trash-cli];
  home.persistence."/persist/home/${config.home.username}".directories = [".local/share/Trash" ".cache/yazi"];
  programs.yazi = {
    enable = true;
    settings = {
      manager = {
        layout = [1 4 3];
        sort_by = "natural";
        sort_sensitive = false;
        sort_reverse = false;
        sort_dir_first = true;
        linemode = "size";
        show_hidden = true;
        show_symlink = true;
      };

      preview = {
        wrap = "yes";
        tab_size = 1;
        image_filter = "triangle";
        image_quality = 70;
        image_delay = 100; #ms
        cache_dir = "~/.cache/yazi";
        ueberzug_scale = 1;
        ueberzug_offset = [0 0 0 0];
      };

      tasks = {
        micro_workers = 10;
        macro_workers = 20;
        bizarre_retry = 5;
        image_alloc = 0; # 512MB
        image_bound = [0 0];
      };

      plugin = {
        fetchers = let
          common = {
            id = "git";
            run = "git";
            prio = "normal";
          };
        in
          map (elem: elem // common) [
            {
              name = "*";
            }

            {
              name = "*/";
            }
          ];
      };
    };

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
          on = ["<Enter>"];
          run = "plugin smart-enter";
          desc = "Enter the child directory, or open the file";
        }
        {
          on = "F";
          run = "plugin smart-filter";
          desc = "Smart filter";
        }
        {
          on = ["c" "a"];
          run = "plugin compress";
          desc = "Archive selected files";
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
    initLua = ''
      require("git"):setup()
    '';
  };
}
