local wezterm = require 'wezterm'

local mykeys = {
  {
    key = '\\',
    mods = 'LEADER',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key = '-',
    mods = 'LEADER',
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  {
    key = 'q',
    mods = 'LEADER',
    action = wezterm.action.CloseCurrentPane { domain = 'CurrentPaneDomain', confirm = true },
  },
  {
    key = 'Q',
    mods = 'LEADER',
    action = wezterm.action.CloseCurrentTab { confirm = true },
  },
  {
    key = 's',
    mods = 'LEADER',
    action = wezterm.action.PaneSelect,
  },
  {
    key = 'n',
    mods = 'LEADER',
    action = wezterm.action.SpawnTab 'CurrentPaneDomain',
  },
  {
    key = 't',
    mods = 'LEADER',
    action = wezterm.action.ShowTabNavigator,
  },
  {
    key = 'Enter',
    mods = 'LEADER',
    action = wezterm.action.ShowLauncher,
  },
}
for i = 1, 8 do
  -- CTRL+ALT + number to move to that position
  table.insert(mykeys, {
    key = tostring(i),
    mods = 'LEADER',
    action = wezterm.action.ActivateTab(i - 1),
  })
end

return {
  enable_wayland = false,
  leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 },
  keys = mykeys,
  font = wezterm.font_with_fallback {
    'Iosevka',
    'JetBrains Mono', 
    'Terminus', 
    'Noto Color Emoji',
    harfbuzz_features = { 'calt=1', 'clig=1', 'liga=1' }
  },
  -- https://www.reddit.com/r/wezterm/comments/1eze6zt/colored_blocks_instead_of_text/
  -- https://github.com/wez/wezterm/issues/5990
  front_end = "WebGpu", -- when you see colored blocks instead of text
  -- front_end = "OpenGL",
  color_scheme = 'stylix',
  -- window_background_opacity = 0.75,
  -- color_scheme = 'midnight-in-mojave',
  -- color_scheme = 'Gruvbox dark, soft (base16)',
  default_prog = { 'fish' },
  window_decorations = "RESIZE",
  -- warn_about_missing_glyphs = true,
  max_fps = 144,
  animation_fps = 24,
  initial_cols = 100,
  initial_rows = 30,
  hide_tab_bar_if_only_one_tab = true
}
