{...}: {
  programs.helix.settings.keys = {
    normal = {
      C-e = "page_cursor_half_up";
      C-r = ":config-reload";
      C-s = ":w";
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
    };
  };
}
