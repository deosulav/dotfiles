local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.color_scheme = 'Dark+'
config.enable_scroll_bar = true
config.command_palette_bg_color = "#1E222A"
config.window_background_gradient = {
  orientation = 'Vertical',
  colors = {
    '#1e1e1e',
  },
  interpolation = 'Linear',
  blend = 'Rgb',
}
-- config.color_scheme = 'AtomOneLight'
config.initial_cols = 300
config.initial_rows = 80

-- Leader assignment
config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 10000 }

-- Shortcuts for actiosn
local act = wezterm.action
config.keys = {
  { key = '|', mods = 'LEADER|SHIFT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = '"', mods = 'LEADER|SHIFT', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
  { key = 'x', mods = 'LEADER',       action = act.CloseCurrentPane { confirm = true } },
  { key = '1', mods = 'ALT',          action = act.ActivatePaneByIndex(1) },
  { key = '2', mods = 'ALT',          action = act.ActivatePaneByIndex(2) },
  { key = '3', mods = 'ALT',          action = act.ActivatePaneByIndex(3) },
  { key = '4', mods = 'ALT',          action = act.ActivatePaneByIndex(4) },
  { key = '5', mods = 'ALT',          action = act.ActivatePaneByIndex(5) },
  { key = '6', mods = 'ALT',          action = act.ActivatePaneByIndex(6) },
  { key = '7', mods = 'ALT',          action = act.ActivatePaneByIndex(7) },
  { key = '8', mods = 'ALT',          action = act.ActivatePaneByIndex(8) },
  { key = '9', mods = 'ALT',          action = act.ActivatePaneByIndex(9) },
  { key = 'h', mods = 'LEADER',       action = act.ActivatePaneDirection 'Left' },
  { key = 'j', mods = 'LEADER',       action = act.ActivatePaneDirection 'Down' },
  { key = 'k', mods = 'LEADER',       action = act.ActivatePaneDirection 'Up' },
  { key = 'l', mods = 'LEADER',       action = act.ActivatePaneDirection 'Right' },
  { key = 'H', mods = 'LEADER',       action = act.AdjustPaneSize { 'Left', 5 } },
  { key = 'J', mods = 'LEADER',       action = act.AdjustPaneSize { 'Down', 5 } },
  { key = 'K', mods = 'LEADER',       action = act.AdjustPaneSize { 'Up', 5 } },
  { key = 'L', mods = 'LEADER',       action = act.AdjustPaneSize { 'Right', 5 } },
  { key = '{', mods = 'CTRL|SHIFT',   action = act.ActivateTabRelative(-1) },
  { key = '}', mods = 'CTRL|SHIFT',   action = act.ActivateTabRelative(1) },
  {
    key = 'K',
    mods = 'CTRL|SHIFT',
    action = act.Multiple {
      act.ClearScrollback 'ScrollbackAndViewport',
      act.SendKey { key = 'L', mods = 'CTRL' },
    },
  },
  {
    key = 'Y', mods = 'LEADER' , action = act.SendString([[printf "\033]52;c;%s\007" "$(base64)"]])
  }
}

config.colors = {
  compose_cursor = 'orange',
}

wezterm.on('update-right-status', function(window, pane)
  local leader = ''
  if window:leader_is_active() then
    leader = 'LEADER'
  end
  window:set_right_status(leader)
end)

wezterm.on('gui-startup', function(cmd)
  local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

-- battery and datetime in right
wezterm.on('update-right-status', function(window, pane)
  -- "Wed Mar 3 08:14"
  local date = wezterm.strftime '%a %b %-d %I:%M %P '

  local bat = ''
  for _, b in ipairs(wezterm.battery_info()) do
    bat = '🔋 ' .. string.format('%.0f%% %s', b.state_of_charge * 100, b.state)
  end

  window:set_right_status(wezterm.format {
    { Text = bat .. '   ' .. date },
  })
end)

return config
