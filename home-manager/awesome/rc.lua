-- awesome_mode: api-level=4:screen=on
-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Notification library
local naughty = require("naughty")
-- Declarative object management
local ruled = require("ruled")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Theme handling library
local beautiful = require("beautiful")
local theme = require("theme")

local volume_widget = require("awesome-wm-widgets.pactl-widget.volume")

local cyclefocus = require('cyclefocus')

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
naughty.connect_signal("request::display_error", function(message, startup)
    naughty.notification {
        urgency = "critical",
        title = "Oops, an error happened" .. (startup and " during startup!" or "!"),
        message = message
    }
end)
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(theme)

-- This is used later as the default terminal and editor to run.
terminal = "wezterm"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"
-- }}}

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Tag layout
-- Table of layouts to cover with awful.layout.inc, order matters.
tag.connect_signal("request::default_layouts", function()
    awful.layout.append_default_layouts({
        awful.layout.suit.floating,
    })
end)
-- }}}

-- {{{ Wallpaper
screen.connect_signal("request::wallpaper", function(s)
    awful.wallpaper {
        screen = s,
        widget = {
            {
                image = beautiful.wallpaper,
                upscale = true,
                downscale = true,
                widget = wibox.widget.imagebox,
            },
            valign = "center",
            halign = "center",
            tiled = false,
            widget = wibox.container.tile,
        }
    }
end)
-- }}}

-- {{{ Wibar

-- Create a textclock widget
mytextclock = wibox.widget.textclock()

-- Screens
mainScreen = screen[1]
sideScreen = screen[2]

screen.connect_signal("request::desktop_decoration", function(s)
    -- Each screen has its own tag table.
    if s == mainScreen then
        awful.tag.add("", { layout = awful.layout.layouts[1], screen = s, selected = true })
    elseif s == sideScreen then
        awful.tag.add("", { layout = awful.layout.layouts[1], screen = s, selected = true })
    end

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen = s,
        filter = awful.widget.tasklist.filter.currenttags,
        buttons = {
            awful.button({ }, 1, function(c)
                c:activate { context = "tasklist", action = "toggle_minimization" }
            end),
        },
    }

    -- Create the wibox
    if s == mainScreen then
        s.mywibox = awful.wibar {
            position = "top",
            screen = s,
            widget = {
                layout = wibox.layout.align.horizontal,
                { -- Left widgets
                    layout = wibox.layout.fixed.horizontal,
                },
                s.mytasklist, -- Middle widget
                { -- Right widgets
                    layout = wibox.layout.fixed.horizontal,
                    volume_widget {
                        widget_type = 'arc'
                    },
                    awful.widget.keyboardlayout(),
                    wibox.widget.systray(),
                    mytextclock,
                },
            }
        }
    else
        s.mywibox = awful.wibar {
            position = "top",
            screen = s,
            widget = {
                layout = wibox.layout.align.horizontal,
                { -- Left widgets
                    layout = wibox.layout.fixed.horizontal,
                },
                s.mytasklist, -- Middle widget
                { -- Right widgets
                    layout = wibox.layout.fixed.horizontal,
                    mytextclock,
                },
            }
        }
    end
end)

-- }}}

-- {{{ Key bindings

-- General Awesome keys
awful.keyboard.append_global_keybindings({
    awful.key({ modkey, }, "s", hotkeys_popup.show_help,
            { description = "show help", group = "awesome" }),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
            { description = "reload awesome", group = "awesome" }),
    awful.key({ modkey, "Shift" }, "q", awesome.quit,
            { description = "quit awesome", group = "awesome" }),
    awful.key({ modkey }, "Return", function()
        awful.spawn(terminal)
    end,
            { description = "open a terminal", group = "launcher" }),
})

-- Custom
awful.keyboard.append_global_keybindings({
    awful.key({ modkey }, "w", function()
        awful.util.spawn("rofi -show window -show-icons -theme-str 'element-icon { size: 3ch; margin: 0.5ch; }' -theme-str 'element-text { vertical-align: 0.5; }'")
    end,
            { description = "rofi window", group = "rofi" }),
    awful.key({ modkey }, "r", function()
        awful.util.spawn("rofi -show drun -show-icons -theme-str 'element-icon { size: 3ch; margin: 0.5ch; }' -theme-str 'element-text { vertical-align: 0.5; }'")
    end,
            { description = "rofi drun", group = "rofi" }),
    awful.key({ modkey }, "p", function()
        awful.util.spawn("rofi -show power")
    end,
            { description = "rofi power menu", group = "rofi" }),
    awful.key({ modkey }, "c", function()
        awful.util.spawn("rofi -show clipboard")
    end,
            { description = "rofi clipboard manager", group = "rofi" }),
    cyclefocus.key({ modkey }, "Tab", {
        move_mouse_pointer = false,
        cycle_filters = { cyclefocus.filters.same_screen },
    }, {}, { description = "Cycle clients in screen", group = "client" }),
    cyclefocus.key({ modkey }, "`", {
        move_mouse_pointer = false,
        cycle_filters = { cyclefocus.filters.same_class },
    }, {}, { description = "Cycle same class clients", group = "client" }),
    awful.key({ modkey }, "j", function()
        awful.screen.focus_relative(1)
    end,
            { description = "focus the next screen", group = "screen" }),
})

function is_double_click()
    if double_click_timer then
        double_click_timer:stop()
        double_click_timer = nil
        return true
    end

    double_click_timer = gears.timer.start_new(0.20, function()
        double_click_timer = nil
        return false
    end)
end
client.connect_signal("request::default_mousebindings", function()
    awful.mouse.append_client_mousebindings({
        awful.button({ }, 1, function(c)
            c:activate { context = "mouse_click" }
        end),
        awful.button({ modkey }, 1, function(c)
            if is_double_click() then
                c.maximized = not c.maximized
                c:raise()
            else
                c:activate { context = "mouse_click", action = "mouse_move" }
            end
        end),
        awful.button({ modkey }, 3, function(c)
            c:activate { context = "mouse_click", action = "mouse_resize" }
        end),
    })
end)

client.connect_signal("request::default_keybindings", function()
    awful.keyboard.append_client_keybindings({
        awful.key({ modkey, }, "f",
                function(c)
                    c.maximized = true
                    c.fullscreen = not c.fullscreen
                    c:raise()
                end,
                { description = "toggle fullscreen", group = "client" }),
        awful.key({ modkey }, "x", function(c)
            c:kill()
        end,
                { description = "close", group = "client" }),
        awful.key({ modkey, }, "o", function(c)
            c:move_to_screen()
        end,
                { description = "move to screen", group = "client" }),
        awful.key({ modkey, }, "t", function(c)
            c.ontop = not c.ontop
        end,
                { description = "toggle keep on top", group = "client" }),
        awful.key({ modkey, }, "n",
                function(c)
                    c.minimized = true
                end,
                { description = "minimize", group = "client" }),
        awful.key({ modkey, }, "m",
                function(c)
                    c.maximized = not c.maximized
                    c:raise()
                end,
                { description = "(un)maximize", group = "client" }),
    })
end)

-- }}}

-- {{{ Rules
-- Rules to apply to new clients.
ruled.client.connect_signal("request::rules", function()
    -- All clients will match this rule.
    ruled.client.append_rule {
        id = "global",
        rule = { },
        properties = {
            focus = awful.client.focus.filter,
            raise = true,
            screen = mainScreen,
            placement = awful.placement.no_overlap + awful.placement.no_offscreen,
        }
    }

    if sideScreen ~= nil then
        ruled.client.append_rule {
            rule_any = { class = { "discord", "Slack" } },
            properties = {
                screen = sideScreen,
                maximized = true,
            }
        }
    end
end)
-- }}}

-- {{{ Notifications

ruled.notification.connect_signal('request::rules', function()
    -- All notifications will match this rule.
    ruled.notification.append_rule {
        rule = { },
        properties = {
            screen = mainScreen,
            implicit_timeout = 5,
        }
    }
end)

naughty.connect_signal("request::display", function(n)
    naughty.layout.box { notification = n }
end)

-- }}}
