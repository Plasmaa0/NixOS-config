{lib, ...}: {
  programs.fish.shellAliases =
    {
      ls = "eza -al --color=auto --group-directories-first --icons=auto";
      lsg = "eza -al --color=auto --group-directories-first --icons=auto --git";
      la = "eza -a --color=auto --group-directories-first --icons=auto";
      lag = "eza -a --color=auto --group-directories-first --icons=auto --git";
      ll = "eza -l --color=auto --group-directories-first --icons=auto";
      llg = "eza -l --color=auto --group-directories-first --icons=auto --git";
      lt = "eza -aT --color=auto --group-directories-first --icons=auto";
      ltg = "eza -aT --color=auto --group-directories-first --icons=auto --git";
      "l." = "eza -a | egrep '^\\.'";
      ip = "ip -color";
      hexdump = "hexd";
      ol = "ollama";
      color = "yad --color";
      cal = "yad --calendar";
      cls = "clear";
      "учше" = "exit";
      weather = "curl v1.wttr.in/Moscow && read -P 'Press RETURN to continue' && curl v2.wttr.in/Moscow";
      cdr = "cd \$(git rev-parse --show-toplevel)";
      grep = "grep --color=auto";
      cat = "bat --style header --style snip --style changes --style header";
      sk = ''sk --ansi -i -c "rg --color=always --line-number {}"'';
      fzf = ''fzf --preview "bat --style header --style snip --style changes --style header {} --color=always" --preview-label="Preview"'';
    }
    //
    /*
    transforms into
    {
      ".." = "cd ../";
      "..." = "cd ../../";
      # ...
      ".........." = "cd ../../../../../../../../../";
    };
    */
    (lib.attrsets.mergeAttrsList (builtins.map (i: {
      "${lib.concatMapStrings (_: ".") (lib.range 1 i)}" =
        "cd " + lib.concatMapStrings (_: "../") (lib.range 1 (i - 1));
    }) (lib.range 2 10)));
}
