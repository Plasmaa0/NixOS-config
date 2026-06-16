{lib, ...}: {
  programs.fish.shellAliases =
    {
      ls = "eza -al --color=always --group-directories-first --icons";
      lsg = "eza -al --color=always --group-directories-first --icons --git";
      la = "eza -a --color=always --group-directories-first --icons";
      lag = "eza -a --color=always --group-directories-first --icons --git";
      ll = "eza -l --color=always --group-directories-first --icons";
      llg = "eza -l --color=always --group-directories-first --icons --git";
      lt = "eza -aT --color=always --group-directories-first --icons";
      ltg = "eza -aT --color=always --group-directories-first --icons --git";
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
