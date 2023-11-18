local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.term = "wezterm"
config.color_scheme = "Tokyo Night"
config.font = wezterm.font("Fira Code")
config.window_decorations = "NONE"
config.hide_tab_bar_if_only_one_tab = true
config.use_dead_keys = false
config.keys = {

    {
        key = "g",
        mods = "CTRL|SHIFT",
        action = wezterm.action_callback(function(win, pane)
            local selection = win:get_selection_text_for_pane(pane)
            wezterm.background_child_process({
                "bash",
                "-c",
                "DDG_ARGS='[\"-n\", 5]' ROFI_SEARCH='ddgr' rofi -blocks-wrap rofi-search -show blocks -lines 4 -eh 4 -kb-custom-1 'Control+y' -kb-accept-custom -filter '" .. selection .. "'",
            })
        end),
    },
}

return config