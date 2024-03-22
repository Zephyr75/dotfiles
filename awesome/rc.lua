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
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
-- Declarative object management
local ruled = require("ruled")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- Custom widgets

-- local volume_widget = require('awesome-wm-widgets.volume-widget.volume')
local battery_widget = require("awesome-wm-widgets.battery-widget.battery")
local cpu_widget = require("awesome-wm-widgets.cpu-widget.cpu-widget")
local ram_widget = require("awesome-wm-widgets.ram-widget.ram-widget")
local volume_widget = require("awesome-wm-widgets.volume-widget.volume")
local logout_popup = require("awesome-wm-widgets.logout-popup-widget.logout-popup")
-- local docker_widget = require("awesome-wm-widgets.docker-widget.docker")

local calendar_widget = require("awesome-wm-widgets.calendar-widget.calendar")

-- -- Create a new container with 10 pixels of padding on the left and right
-- local padded_docker = wibox.container.margin(docker_widget(), 10, 10)

-- -- Create a background container for the battery_widget
-- local docker_container = wibox.container.background(padded_docker)

-- -- Set the background color and shape
-- docker_container.bg = "#222222"
-- docker_container.shape = function(cr, width, height)
--   local radius = 10
--   gears.shape.rounded_rect(cr, width, height, radius)
-- end


-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
naughty.connect_signal("request::display_error", function(message, startup)
  naughty.notification {
    urgency = "critical",
    title   = "Oops, an error happened" .. (startup and " during startup!" or "!"),
    message = message
  }
end)
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
--beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")
beautiful.init("/home/zeph/.config/awesome/default/theme.lua")

-- set notifications border width to 0
naughty.config.defaults.border_width = 0
-- add padding to notifications
naughty.config.defaults.margin = 15

naughty.config.defaults.icon_size = 60

naughty.config.defaults.font = "JetBrains Mono Nerd Font SemiBold 10"

naughty.config.defaults.fg = "#eeeeee"

-- vertically center notifications
-- naughty.config.defaults.position = "middle"





-- This is used later as the default terminal and editor to run.
terminal = "alacritty"
editor = "nvim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
  { "hotkeys",     function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
  { "manual",      terminal .. " -e man awesome" },
  { "edit config", editor_cmd .. " " .. awesome.conffile },
  { "restart",     awesome.restart },
  { "quit",        function() awesome.quit() end },
}

mymainmenu = awful.menu({
  items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
    { "open terminal", terminal }
  }
})

mylauncher = awful.widget.launcher({
  image = beautiful.awesome_icon,
  menu = mymainmenu
})

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Tag layout
-- Table of layouts to cover with awful.layout.inc, order matters.
tag.connect_signal("request::default_layouts", function()
  awful.layout.append_default_layouts({
    awful.layout.suit.tile,
    --awful.layout.suit.tile.left,
    --awful.layout.suit.tile.bottom,
    --awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    --awful.layout.suit.fair.horizontal,
    --awful.layout.suit.spiral,
    --awful.layout.suit.spiral.dwindle,
    --awful.layout.suit.max,
    --awful.layout.suit.max.fullscreen,
    --awful.layout.suit.magnifier,
    --awful.layout.suit.corner.nw,
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
        image     = beautiful.wallpaper,
        upscale   = true,
        downscale = true,
        widget    = wibox.widget.imagebox,
      },
      valign = "center",
      halign = "center",
      tiled  = false,
      widget = wibox.container.tile,
    }
  }
end)
-- }}}

-- {{{ Wibar

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- Create a textclock widget
-- add week day
mytextclock = wibox.widget.textclock("%a %d %b %H:%M")

local textclock_clr = wibox.widget.background()
textclock_clr:set_widget(mytextclock)
-- INFO: color text clock
-- textclock_clr:set_fg("#e0af68")

local cw = calendar_widget({
  -- theme = 'outrun',
  placement = 'top_right',
  radius = 0,
  -- with customized next/previous (see table above)
  previous_month_button = 1,
  next_month_button = 3,
})
textclock_clr:connect_signal("button::press",
  function(_, _, _, button)
    if button == 1 then cw.toggle() end
  end)


-- Create a new container with 10 pixels of padding on the left and right
local padded_clock = wibox.container.margin(textclock_clr, 15, 15)

-- Create a background container for the text clock
local clock_container = wibox.container.background(padded_clock)

-- Set the background color and shape
clock_container.bg = "#1a1b26"
clock_container.shape = function(cr, width, height)
  local radius = 10
  gears.shape.rounded_rect(cr, width, height, radius)
end

-- Style the textclock
mytextclock.font = "JetBrains Mono Nerd Font SemiBold 12"

-- Create a new container with 10 pixels of padding on the left and right
local padded_ram = wibox.container.margin(ram_widget(), 5, 5)

-- Create a background container for the ram_widget
local ram_container = wibox.container.background(padded_ram)

-- Set the background color and shape
ram_container.bg = "#1a1b26"
ram_container.shape = function(cr, width, height)
  local radius = 10
  gears.shape.rounded_rect(cr, width, height, radius)
end

-- Create a new container with 10 pixels of padding on the left and right
local padded_cpu = wibox.container.margin(cpu_widget(), 15, 15)

-- Create a background container for the cpu_widget
local cpu_container = wibox.container.background(padded_cpu)

-- Set the background color and shape
cpu_container.bg = "#1a1b26"
cpu_container.shape = function(cr, width, height)
  local radius = 10
  gears.shape.rounded_rect(cr, width, height, radius)
end

-- Create a new container with 10 pixels of padding on the left and right
local padded_battery = wibox.container.margin(battery_widget(), 10, 10)

-- Create a background container for the battery_widget
local battery_container = wibox.container.background(padded_battery)

-- Set the background color and shape
battery_container.bg = "#1a1b26"
battery_container.shape = function(cr, width, height)
  local radius = 10
  gears.shape.rounded_rect(cr, width, height, radius)
end

-- Create a new container with 10 pixels of padding on the left and right
local padded_volume = wibox.container.margin(volume_widget(), 10, 10)

-- Create a background container for the volume_widget
local volume_container = wibox.container.background(padded_volume)

-- Set the background color and shape
volume_container.bg = "#1a1b26"
volume_container.shape = function(cr, width, height)
  local radius = 10
  gears.shape.rounded_rect(cr, width, height, radius)
end

local padded_systray = wibox.container.margin(wibox.widget.systray(), 15, 15, 5, 5)

-- Create a background container for the systray
local systray_container = wibox.container.background(padded_systray)

-- Set the background color and shape
systray_container.bg = "#1a1b26"
systray_container.shape = function(cr, width, height)
  local radius = 10
  gears.shape.rounded_rect(cr, width, height, radius)
end




screen.connect_signal("request::desktop_decoration", function(s)
  -- Each screen has its own tag table.
  awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

  -- Create a promptbox for each screen
  s.mypromptbox = awful.widget.prompt()

  -- Create an imagebox widget which will contain an icon indicating which layout we're using.
  -- We need one layoutbox per screen.
  s.mylayoutbox = awful.widget.layoutbox {
    screen  = s,
    buttons = {
      awful.button({}, 1, function() awful.layout.inc(1) end),
      awful.button({}, 3, function() awful.layout.inc(-1) end),
      awful.button({}, 4, function() awful.layout.inc(-1) end),
      awful.button({}, 5, function() awful.layout.inc(1) end),
    }
  }


  local padded_layout_box = wibox.container.margin(s.mylayoutbox, 10, 10, 5, 5)

  -- Create a background container for the systray
  local layout_box_container = wibox.container.background(padded_layout_box)

  -- Set the background color and shape
  layout_box_container.bg = "#1a1b26"
  layout_box_container.shape = function(cr, width, height)
    local radius = 10
    gears.shape.rounded_rect(cr, width, height, radius)
  end




  -- Create a taglist widget
  s.mytaglist = awful.widget.taglist {
    screen = s,
    filter = awful.widget.taglist.filter.all,
    buttons = {
      awful.button({}, 1, function(t) t:view_only() end),
      awful.button({ modkey }, 1, function(t)
        if client.focus then
          client.focus:move_to_tag(t)
        end
      end),
      awful.button({}, 3, awful.tag.viewtoggle),
      awful.button({ modkey }, 3, function(t)
        if client.focus then
          client.focus:toggle_tag(t)
        end
      end),
      awful.button({}, 4, function(t) awful.tag.viewprev(t.screen) end),
      awful.button({}, 5, function(t) awful.tag.viewnext(t.screen) end),
    }, style = {
    bg_focus = "#1a1b26",
    bg_occupied = "#1a1b26a0",
    bg_empty = "#1a1b2620",
    shape = gears.shape.circle,
    font = "JetBrains Mono Nerd Font SemiBold 12",
  },
    widget_template = {
      {
        {
          {
            id     = 'text_role',
            widget = wibox.widget.textbox,
            align  = "center",
          },
          margins = 4,           -- modify this value to adjust margin size
          widget  = wibox.container.margin,
        },
        id           = 'background_role',
        widget       = wibox.container.background,
        forced_width = 40,         -- modify this value to adjust button size
      },
      widget = wibox.container.margin
    },
  }

  -- Create a tasklist widget
  s.mytasklist = awful.widget.tasklist {
    screen  = s,
    filter  = awful.widget.tasklist.filter.currenttags,
    buttons = {
      awful.button({}, 1, function(c)
        c:activate { context = "tasklist", action = "toggle_minimization" }
      end),
      awful.button({}, 3, function() awful.menu.client_list { theme = { width = 250 } } end),
      awful.button({}, 4, function() awful.client.focus.byidx(-1) end),
      awful.button({}, 5, function() awful.client.focus.byidx(1) end),
    },
    layout  = {
      layout = wibox.layout.fixed.horizontal,
    },
  }

  -- Create the wibox
  s.mywibox = awful.wibar {
    position = "top",
    screen   = s,
    fg       = "#ffffff",
    bg       = "#00000000",
    widget   = wibox.container.margin(
      {
        layout = wibox.layout.align.horizontal,
        {     -- Left widgets
          layout = wibox.layout.fixed.horizontal,
          -- mylauncher,
          s.mytaglist,
          s.mypromptbox,
        },
        --s.mytasklist, -- Middle widget
        wibox.widget.textbox(),
        {     -- Right widgets
          layout = wibox.layout.fixed.horizontal,
          -- mykeyboardlayout,
          -- only display systray on primary screen
          s == screen.primary and systray_container or nil,
          --wibox.widget.systray(),
          --wibox.container.margin(cpu_container, 10, 0, 0, 0),
          wibox.container.margin(volume_container, 10, 0, 0, 0),
          wibox.container.margin(battery_container, 10, 0, 0, 0),
          wibox.container.margin(ram_container, 10, 0, 0, 0),
          wibox.container.margin(clock_container, 10, 0, 0, 0),
          -- wibox.container.margin(docker_widget(), 10, 0, 0, 0),
          -- insert 5 pixels of padding to the left
          -- wibox.container.margin(s.mylayoutbox, 10, 0, 0, 0),
          wibox.container.margin(layout_box_container, 10, 0, 0, 0),
        },
      }, 5, 10, 10, 0),
  }
end)

-- }}}

-- {{{ Mouse bindings
awful.mouse.append_global_mousebindings({
  awful.button({}, 3, function() mymainmenu:toggle() end),
  -- awful.button({ }, 4, awful.tag.viewprev),
  -- awful.button({ }, 5, awful.tag.viewnext),
})
-- }}}

-- {{{ Key bindings

-- General Awesome keys
awful.keyboard.append_global_keybindings({
  awful.key({ modkey, }, "s", hotkeys_popup.show_help,
    { description = "show help", group = "awesome" }),
  awful.key({ modkey, }, "w", function() mymainmenu:show() end,
    { description = "show main menu", group = "awesome" }),
  awful.key({ modkey, "Control" }, "r", awesome.restart,
    { description = "reload awesome", group = "awesome" }),
  awful.key({ modkey, "Shift" }, "q", awesome.quit,
    { description = "quit awesome", group = "awesome" }),
  -- awful.key({ modkey }, "x",
  --   function()
  --     awful.prompt.run {
  --       prompt       = "Run Lua code: ",
  --       textbox      = awful.screen.focused().mypromptbox.widget,
  --       exe_callback = awful.util.eval,
  --       history_path = awful.util.get_cache_dir() .. "/history_eval"
  --     }
  --   end,
  --   { description = "lua execute prompt", group = "awesome" }),
  awful.key({ modkey, }, "Return", function() awful.spawn(terminal) end,
    { description = "open a terminal", group = "launcher" }),
  awful.key({ modkey }, "r", function() awful.util.spawn("rofi -show drun") end,
    { description = "run program", group = "launcher" }),
  awful.key({ modkey }, "c", function() awful.util.spawn('alacritty -e sh -c "qalc"') end,
    { description = "open calculator", group = "launcher" }),
  awful.key({ modkey }, "b", function() awful.util.spawn("blueman-manager") end,
    { description = "bluetooth manager", group = "launcher" }),
  awful.key({ modkey }, "e", function() awful.util.spawn('alacritty -e sh -c "cd $(/home/zeph/.config/dotfiles_private/scripts/smartcd.sh $(find . | fzf)); zsh"') end,
    { description = "open code editor", group = "launcher" }),
  awful.key({ modkey }, "z", function() awful.util.spawn('alacritty -e sh -c "btop"') end,
    { description = "run btop", group = "launcher" }),
  awful.key({ modkey }, "i", function() awful.util.spawn('alacritty -e sh -c "/home/zeph/.config/dotfiles_private/scripts/todo/todo"') end,
    { description = "open todo", group = "launcher" }),
  awful.key({ modkey }, "x", function() awful.util.spawn("rofi -show file-browser-extended -file-browser-depth 7")end,
    { description = "directory finder", group = "launcher" }),
  awful.key({ modkey }, "g", function() awful.util.spawn("github-desktop") end,
    { description = "run github desktop", group = "launcher" }),
  awful.key({ modkey }, "d", function() awful.util.spawn("discord") end,
    { description = "run discord", group = "launcher" }),
  awful.key({ modkey }, "a", function() awful.util.spawn("google-chrome-stable --new-window --app=https://excalidraw.com") end,
    { description = "run excalidraw", group = "launcher" }),
  awful.key({ modkey }, "y", function() awful.util.spawn('alacritty -e sh -c "tgpt -i"') end,
    { description = "run yarvis", group = "launcher" }),
  awful.key({ modkey }, "p", function() menubar.show() end,
    { description = "show the menubar", group = "launcher" }),
  awful.key({ modkey }, "Escape", function() logout_popup.launch() end,
    { description = "Show logout screen", group = "custom" }),
  awful.key({ }, "Print", function () awful.spawn("flameshot gui") end,
    {description = "Take screenshot with Flameshot", group = "screenshot"}),
})


-- Define the rules table
awful.rules = {
    {
        rule = { class = "Google-chrome" },
        properties = { floating = false }
    },
}

-- Tags related keybindings
awful.keyboard.append_global_keybindings({
  awful.key({ modkey, }, "Left", awful.tag.viewprev,
    { description = "view previous", group = "tag" }),
  awful.key({ modkey, }, "Right", awful.tag.viewnext,
    { description = "view next", group = "tag" }),
  -- awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
  --           {description = "go back", group = "tag"}),
})

-- Focus related keybindings
awful.keyboard.append_global_keybindings({
  awful.key({ modkey, }, "j",
    function()
      awful.client.focus.byidx(-1)
    end,
    { description = "focus next by index", group = "client" }
  ),
  awful.key({ modkey, }, "k",
    function()
      awful.client.focus.byidx(1)
    end,
    { description = "focus previous by index", group = "client" }
  ),
  awful.key({ modkey, }, "Tab",
    function()
      awful.client.focus.history.previous()
      if client.focus then
        client.focus:raise()
      end
    end,
    { description = "go back", group = "client" }),
  awful.key({ modkey, "Control" }, "j", function() awful.screen.focus_relative(1) end,
    { description = "focus the next screen", group = "screen" }),
  awful.key({ modkey, "Control" }, "k", function() awful.screen.focus_relative(-1) end,
    { description = "focus the previous screen", group = "screen" }),
  awful.key({ modkey, "Control" }, "n",
    function()
      local c = awful.client.restore()
      -- Focus restored client
      if c then
        c:activate { raise = true, context = "key.unminimize" }
      end
    end,
    { description = "restore minimized", group = "client" }),
  awful.key({ modkey }, "v",
    function()
      awful.layout.set(awful.layout.suit.tile)
      for _, c in ipairs(client.get()) do
        if c.maximized then
          c.maximized = not c.maximized
          c:raise()
        end
      end
    end,
    { description = "show all open windows of workspace", group = "client" }),
})

-- Layout related keybindings
awful.keyboard.append_global_keybindings({
  awful.key({ modkey, "Shift" }, "j", function() awful.client.swap.byidx(-1) end,
    { description = "swap with next client by index", group = "client" }),
  awful.key({ modkey, "Shift" }, "k", function() awful.client.swap.byidx(1) end,
    { description = "swap with previous client by index", group = "client" }),
  awful.key({ modkey, }, "u", awful.client.urgent.jumpto,
    { description = "jump to urgent client", group = "client" }),
  awful.key({ modkey, }, "l", function() awful.tag.incmwfact(0.05) end,
    { description = "increase master width factor", group = "layout" }),
  awful.key({ modkey, }, "h", function() awful.tag.incmwfact(-0.05) end,
    { description = "decrease master width factor", group = "layout" }),
  awful.key({ modkey, "Shift" }, "h", function() awful.tag.incnmaster(1, nil, true) end,
    { description = "increase the number of master clients", group = "layout" }),
  awful.key({ modkey, "Shift" }, "l", function() awful.tag.incnmaster(-1, nil, true) end,
    { description = "decrease the number of master clients", group = "layout" }),
  awful.key({ modkey, "Control" }, "h", function() awful.tag.incncol(1, nil, true) end,
    { description = "increase the number of columns", group = "layout" }),
  awful.key({ modkey, "Control" }, "l", function() awful.tag.incncol(-1, nil, true) end,
    { description = "decrease the number of columns", group = "layout" }),
  awful.key({ modkey, }, "space", function() awful.layout.inc(1) end,
    { description = "select next", group = "layout" }),
  awful.key({ modkey, "Shift" }, "space", function() awful.layout.inc(-1) end,
    { description = "select previous", group = "layout" }),
})


awful.keyboard.append_global_keybindings({
  awful.key {
    modifiers   = { modkey },
    keygroup    = "numrow",
    description = "only view tag",
    group       = "tag",
    on_press    = function(index)
      local screen = awful.screen.focused()
      local tag = screen.tags[index]
      if tag then
        tag:view_only()
      end
    end,
  },
  awful.key {
    modifiers   = { modkey, "Control" },
    keygroup    = "numrow",
    description = "toggle tag",
    group       = "tag",
    on_press    = function(index)
      local screen = awful.screen.focused()
      local tag = screen.tags[index]
      if tag then
        awful.tag.viewtoggle(tag)
      end
    end,
  },
  awful.key {
    modifiers   = { modkey, "Shift" },
    keygroup    = "numrow",
    description = "move focused client to tag",
    group       = "tag",
    on_press    = function(index)
      if client.focus then
        local tag = client.focus.screen.tags[index]
        if tag then
          client.focus:move_to_tag(tag)
        end
      end
    end,
  },
  awful.key {
    modifiers   = { modkey, "Control", "Shift" },
    keygroup    = "numrow",
    description = "toggle focused client on tag",
    group       = "tag",
    on_press    = function(index)
      if client.focus then
        local tag = client.focus.screen.tags[index]
        if tag then
          client.focus:toggle_tag(tag)
        end
      end
    end,
  },
  awful.key {
    modifiers   = { modkey },
    keygroup    = "numpad",
    description = "select layout directly",
    group       = "layout",
    on_press    = function(index)
      local t = awful.screen.focused().selected_tag
      if t then
        t.layout = t.layouts[index] or t.layout
      end
    end,
  }
})



-- Define a function to update the notification widget
local function update_notification_widget(widget, message)
  widget:set_markup_silently("<b>Volume Control: </b>" .. message)
end

-- Create the notification widget
local notification_widget = wibox.widget.textbox()
update_notification_widget(notification_widget, "Ready")

local last_notification_id = nil

-- local vol_notif_id
-- Restore key bindings
awful.keyboard.append_global_keybindings({
  awful.key({}, "XF86AudioRaiseVolume", function()
    awful.spawn("pamixer -i 5")
    awful.spawn.easy_async("pamixer --get-volume", function(stdout)
      local volume = tonumber(stdout)
      if volume >= 100 then
        volume = 99
      end
      local notification = naughty.notify({
        title = "Vol " .. volume,
        -- text = "   " .. volume,
        timeout = 1,
        position = "top_middle",
        bg = "#1a1b26",
        fg = "#FFFFFF",
        border_width = 0,
        width = 80,
        height = 40,
        replaces_id = last_notification_id,
        font = "JetBrainsMono Nerd Font SemiBold 10",
      })
      last_notification_id = notification.id
    end)
  end),
  awful.key({}, "XF86AudioLowerVolume", function()
    awful.spawn("pamixer -d 5")
    awful.spawn.easy_async("pamixer --get-volume", function(stdout)
      local volume = tonumber(stdout)
      if volume >= 100 then
        volume = 99
      end
      local notification = naughty.notify({
        title = "Vol " .. volume,
        -- text = "   " .. volume,
        timeout = 1,
        position = "top_middle",
        bg = "#1a1b26",
        fg = "#FFFFFF",
        align = "center",
        border_width = 0,
        width = 80,
        height = 40,
        replaces_id = last_notification_id,
        font = "JetBrainsMono Nerd Font SemiBold 10",
      })
      last_notification_id = notification.id
    end)
  end),
  awful.key({}, "XF86AudioMute", function()
    awful.spawn("pamixer -t")
  end),
  awful.key({}, "XF86MonBrightnessUp", function()
    awful.spawn("brightnessctl set +10%")
  end),
  awful.key({}, "XF86MonBrightnessDown", function()
    awful.spawn("brightnessctl set 10%-")
  end),
  awful.key({}, "XF86Display", function()
    awful.spawn.with_shell("arandr")
  end),
  -- awful.key({}, "XF86Bluetooth", function()
  --   awful.spawn.with_shell("rfkill unblock bluetooth; blueman-manager")
  -- end),
  awful.key({}, "XF86Tools", function()
    awful.util.spawn('alacritty -e sh -c "/home/zeph/.local/bin/lvim .config/awesome/rc.lua; zsh"')
  end),
})

client.connect_signal("request::default_mousebindings", function()
  awful.mouse.append_client_mousebindings({
    awful.button({}, 1, function(c)
      c:activate { context = "mouse_click" }
    end),
    awful.button({ modkey }, 1, function(c)
      c:activate { context = "mouse_click", action = "mouse_move" }
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
        c.fullscreen = not c.fullscreen
        c:raise()
      end,
      { description = "toggle fullscreen", group = "client" }),
    -- awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
    awful.key({ modkey }, "q", function(c) c:kill() end,
      { description = "close", group = "client" }),
    awful.key({ modkey, "Control" }, "space", awful.client.floating.toggle,
      { description = "toggle floating", group = "client" }),
    awful.key({ modkey, "Control" }, "Return", function(c) c:swap(awful.client.getmaster()) end,
      { description = "move to master", group = "client" }),
    awful.key({ modkey, }, "o", function(c) c:move_to_screen() end,
      { description = "move to screen", group = "client" }),
    awful.key({ modkey, }, "t", function(c) c.ontop = not c.ontop end,
      { description = "toggle keep on top", group = "client" }),
    awful.key({ modkey, }, "n",
      function(c)
        -- The client currently has the input focus, so it cannot be
        -- minimized, since minimized clients can't have the focus.
        c.minimized = true
      end,
      { description = "minimize", group = "client" }),
    awful.key({ modkey, }, "m",
      function(c)
        -- set padding before maximize
        if not c.maximized then
          awful.screen.focused().padding = { top = "8", bottom = "8", left = "8", right = "8" }
        end
        c.maximized = not c.maximized
        c:raise()
        awful.screen.focused().padding = { top = "0", bottom = "0", left = "0", right = "0" }
      end,
      { description = "(un)maximize", group = "client" }),
    awful.key({ modkey, "Control" }, "m",
      function(c)
        c.maximized_vertical = not c.maximized_vertical
        c:raise()
      end,
      { description = "(un)maximize vertically", group = "client" }),
    awful.key({ modkey, "Shift" }, "m",
      function(c)
        c.maximized_horizontal = not c.maximized_horizontal
        c:raise()
      end,
      { description = "(un)maximize horizontally", group = "client" }),
  })
end)

-- }}}

-- {{{ Rules
-- Rules to apply to new clients.
ruled.client.connect_signal("request::rules", function()
  -- All clients will match this rule.
  ruled.client.append_rule {
    id         = "global",
    rule       = {},
    properties = {
      focus     = awful.client.focus.filter,
      raise     = true,
      screen    = awful.screen.preferred,
      placement = awful.placement.no_overlap + awful.placement.no_offscreen
    }
  }

  -- Floating clients.
  ruled.client.append_rule {
    id         = "floating",
    rule_any   = {
      instance = { "copyq", "pinentry" },
      class    = {
        "Arandr", "Blueman-manager", "Gpick", "Kruler", "Sxiv",
        "Tor Browser", "Wpa_gui", "veromix", "xtightvncviewer"
      },
      -- Note that the name property shown in xprop might be set slightly after creation of the client
      -- and the name shown there might not match defined rules here.
      name     = {
        "Event Tester",         -- xev.
      },
      role     = {
        "AlarmWindow",           -- Thunderbird's calendar.
        "ConfigManager",         -- Thunderbird's about:config.
        "pop-up",                -- e.g. Google Chrome's (detached) Developer Tools.
      }
    },
    properties = { floating = true }
  }

  -- Add titlebars to normal clients and dialogs
  ruled.client.append_rule {
    id         = "titlebars",
    rule_any   = { type = { "normal", "dialog" } },
    properties = { titlebars_enabled = false }
  }

  -- Set Firefox to always map on the tag named "2" on screen 1.
  -- ruled.client.append_rule {
  --     rule       = { class = "Firefox"     },
  --     properties = { screen = 1, tag = "2" }
  -- }
end)
-- }}}

-- {{{ Titlebars
-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
  -- buttons for the titlebar
  local buttons = {
    awful.button({}, 1, function()
      c:activate { context = "titlebar", action = "mouse_move" }
    end),
    awful.button({}, 3, function()
      c:activate { context = "titlebar", action = "mouse_resize" }
    end),
  }

  awful.titlebar(c).widget = {
    {     -- Left
      awful.titlebar.widget.iconwidget(c),
      buttons = buttons,
      layout  = wibox.layout.fixed.horizontal
    },
    {         -- Middle
      {       -- Title
        halign = "center",
        widget = awful.titlebar.widget.titlewidget(c)
      },
      buttons = buttons,
      layout  = wibox.layout.flex.horizontal
    },
    {     -- Right
      awful.titlebar.widget.floatingbutton(c),
      awful.titlebar.widget.maximizedbutton(c),
      awful.titlebar.widget.stickybutton(c),
      awful.titlebar.widget.ontopbutton(c),
      awful.titlebar.widget.closebutton(c),
      layout = wibox.layout.fixed.horizontal()
    },
    layout = wibox.layout.align.horizontal
  }
end)
-- }}}

-- {{{ Notifications

ruled.notification.connect_signal('request::rules', function()
  -- All notifications will match this rule.
  ruled.notification.append_rule {
    rule       = {},
    properties = {
      screen           = awful.screen.preferred,
      implicit_timeout = 5,
    }
  }
end)

naughty.connect_signal("request::display", function(n)
  naughty.layout.box { notification = n }
end)

-- }}}

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
  c:activate { context = "mouse_enter", raise = false }
end)





-- -- Set up a rounded rectangle shape
-- local function rounded_shape(size)
--     return function(cr, width, height)
--         gears.shape.rounded_rect(cr, width, height, size)
--     end
-- end

-- -- Set up shadow properties
-- beautiful.shadow_radius = 10
-- beautiful.shadow_offset = {x = 0, y = 0}
-- beautiful.shadow_opacity = 0.8
-- beautiful.shadow_shape = rounded_shape(10)

-- -- Apply the shadow properties to the client's window
-- client.connect_signal("manage", function(c)
--     c.shape = rounded_shape(10)
--     c.shadow = true
-- end)


-- -- Set up a rounded rectangle shape
-- local function rounded_shape(size)
--     return function(cr, width, height)
--         gears.shape.rounded_rect(cr, width, height, size)
--     end
-- end

-- -- Apply the rounded shape to the client's window
-- client.connect_signal("manage", function(c)
--     c.shape = rounded_shape(10)
-- end)


--Autostart applications
--awful.spawn.with_shell("nitrogen --restore")
awful.spawn.with_shell("$HOME/.config/awesome/scripts/wallpaper.sh")
-- awful.spawn.with_shell("feh --bg-fill '/home/zeph/.config/awesome/wallpapers/firewatch.png'")
awful.spawn.with_shell("picom --experimental-backend")
awful.spawn.with_shell("nm-applet")
awful.spawn.with_shell("setxkbmap intl")
awful.spawn.with_shell("fzf")
awful.spawn.with_shell("find . -type d")
awful.spawn.with_shell("libinput-gestures-setup start")
awful.spawn.with_shell('export BAT_THEME="Catppuccin-macchiato"')
