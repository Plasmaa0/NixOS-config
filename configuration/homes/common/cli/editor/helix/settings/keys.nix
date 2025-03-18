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
      cyrillicToEnglishKeymap = lib.fold (a: b: a // b) {} cyrillicToEnglishKeysList;
    in
      {
        C-e = "page_cursor_half_up";
        C-r = ":reload";
        C-s = ":w";
        backspace = ":w";
        "C-." = "goto_next_buffer";
        "C-," = "goto_next_buffer";
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
      }
      // cyrillicToEnglishKeymap;
  };
}
