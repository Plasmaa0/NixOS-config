{lib, ...}: {
  programs.helix.settings.keys = {
    normal = let
      # map cycyrillic keys to english using helix macro feature
      # example:
      # "щ" = "@o" maps cyrillic щ to english o
      cyrillic = ["й" "ц" "у" "к" "е" "н" "г" "ш" "щ" "з" "х" "ъ" "ф" "ы" "в" "а" "п" "р" "о" "л" "д" "ж" "э" "я" "ч" "с" "м" "и" "т" "ь" "б" "ю"];
      english = ["q" "w" "e" "r" "t" "y" "u" "i" "o" "p" "[" "]" "a" "s" "d" "f" "g" "h" "j" "k" "l" ";" "'" "z" "x" "c" "v" "b" "n" "m" "," "."];
      makeBind = cyr: eng: {"${cyr}" = "@${eng}";};
      cyrillicToEnglishKeysList = lib.zipListsWith makeBind cyrillic english;
      cyrillicToEnglishKeymap = lib.foldr (a: b: a // b) {} cyrillicToEnglishKeysList;
    in
      {
        C-e = "page_cursor_half_up";
        C-r = ":reload";
        C-s = ":w";
        backspace = ":w";
        "C-k" = "goto_next_buffer";
        "C-j" = "goto_previous_buffer";
        # "C->" = "rotate_selection_contents_forward";
        # "C-<" = "rotate_selection_contents_backward";
        A-j = ["search_selection" "extend_search_next"];
        C-q = ":bc";
        C-A-l = ":format";
        Y = ":clipboard-yank";
        C-o = ":open ~/.config/helix/config.toml";
        esc = ["collapse_selection" "keep_primary_selection"];
        S-up = ["extend_to_line_bounds" "delete_selection" "move_line_up" "paste_before"];
        S-down = ["extend_to_line_bounds" "delete_selection" "paste_after"];
        C-left = ["jump_backward"];
        C-right = ["jump_forward"];
        ret = "goto_word";
        "C-=" = "increment";
        C-minus = "decrement";
        C-space = "signature_help";
        V = ["goto_first_nonwhitespace" "extend_to_line_end"];
        D = ["ensure_selections_forward" "extend_to_line_end"];
        g = {b = ":sh echo %sh{git show --no-patch --format='%%h \\(%%an: %%ar\\): %%s' $(git blame -p %{buffer_name} -L%{cursor_line},+1 | head -1 | cut -d' ' -f1)}";};
      }
      // cyrillicToEnglishKeymap;
    insert = {
      C-space = "signature_help";
    };
  };
}
