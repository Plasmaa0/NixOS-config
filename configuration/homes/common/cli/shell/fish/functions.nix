{...}: {
  programs.fish.functions = {
    fish_title = ''echo " $PWD | $_" | sed "s|$HOME|~|g"'';
    history = "builtin history --show-time='%F %T '";
    backup = {
      argumentNames = ["filename"];
      body = "cp $filename $filename.bak";
      description = "Create a backup of a file";
    };
    take = {
      argumentNames = ["dir"];
      body =
        # fish
        ''
          mkdir -p $dir
          cd $dir
        '';
      description = "Create dir and cd to it";
    };
    unwrap = {
      argumentNames = ["dir"];
      body =
        # fish
        ''
          mv $dir/.* .
          mv $dir/* .
          rmdir $dir
        '';
      description = "Take all <dir> contents and move to cwd, delete dir";
    };
    wwc = {
      argumentNames = ["f"];
      body =
        # fish
        ''
          cat $f | tail -n +2 >$f.backup
          unlink $f
          cp $f.backup $f
          chmod 777 $f
          chown $(whoami) $f
        '';
      description = "wwc: Work with config (creates normal file instead of nix symlink) ONLY FOR DEBUGGING AND TESTING PURPOSES";
    };
  };
}
