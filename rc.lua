-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local vicious = require("vicious")

user = "alex"
HOME = "/home/" .. user .. "/"
on = true

awful.util.spawn("pkill battery.sh")
awful.util.spawn("terminator -e \"sudo pacman -Syu\"")
awful.util.spawn("checkgmail")
awful.util.spawn("bash " .. HOME .. "battery.sh")
awful.util.spawn("compton")
awful.util.spawn("killall nm-applet")
awful.util.spawn("nm-applet")
awful.util.spawn("xscreensaver -no-splash")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset=naughty.widget.presets.cristical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
beautiful.init(HOME .. ".config/awesome/themes/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "terminator"
editor = "gvim"
editor_cmd = "bash -c " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
    awful.layout.suit.tile,
    awful.layout.suit.floating,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier
}
-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, layouts[1])
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
chromium = "google-chrome-stable"

programs = {
	{"Google chrome", "google-chrome-stable", HOME .. ".config/awesome/icons/chromium.png"},
	{"Sublime text", "subl3", HOME .. ".config/awesome/icons/subl.png"},
	{"Codeblocks", "codeblocks", HOME .. ".config/awesome/icons/codeblocks.png"},
	{"Gvim", "gvim", HOME .. ".config/awesome/icons/gvim.png"},
	{"Vim", "terminator -e vim", HOME .. ".config/awesome/icons/vim.png"},
	{"Terminal", "terminator", HOME .. ".config/awesome/icons/terminal.jpg"},
	{"Task manager", "htop", HOME .. ".config/awesome/icons/taskManeger.jpg"},
	{"File manager", "nautilus", HOME .. ".config/awesome/icons/folder.png"}
}


emails = {
    { "Gmail", chromium .. " gmail.com", HOME .. ".config/awesome/icons/gmail.png"},
    { "ABV", chromium .. " abv.bg", HOME .. ".config/awesome/icons/abv.png"}
}

socialNet = {
    { "Facebook", chromium .. " facebook.com", HOME .. ".config/awesome/icons/facebook.png"},
    { "Google+", chromium .. " googleplus.com", HOME .. ".config/awesome/icons/google+.png"},
    { "Twitter", chromium .. " twitter.com", HOME .. ".config/awesome/icons/twitter.png"}
}

volumeCommand = "gnome-control-center sound"

settingsCommand = "gnome-control-center"
settings = {
            {"All settings", settingsCommand, HOME .. ".config/awesome/icons/setting.png"},
            {"Backgroung", settingsCommand .. " background", HOME .. ".config/awesome/icons/background.png"},
            {"Bluetooth", settingsCommand .. " bluetooth", HOME .. ".config/awesome/icons/bluetooth.png"},
            {"Color", settingsCommand .. " color", HOME .. ".config/awesome/icons/color.png"},
            {"Date & Time", settingsCommand .. " datetime", HOME .. ".config/awesome/icons/datetime.png"},
            {"Display", settingsCommand .. " display", HOME .. ".config/awesome/icons/display.png"},
            {"Details", settingsCommand .. " info", HOME .. ".config/awesome/icons/info.png"},
            {"Keyboard", settingsCommand .. " keyboard", HOME .. ".config/awesome/icons/keyboard.png"},
            {"Mouse & Touchpad", settingsCommand .. " mouse", HOME .. ".config/awesome/icons/mouse.png"},
            {"Network", settingsCommand .. " network", HOME .. ".config/awesome/icons/network.png"},
            {"Notifications", settingsCommand .. " notifications", HOME .. ".config/awesome/icons/notifications.png"},
            {"Online Accounts", settingsCommand .. " online-accounts", HOME .. ".config/awesome/icons/online accounts.png"},
            {"Power", settingsCommand .. " power", HOME .. ".config/awesome/icons/power.png"},
            {"Printers", settingsCommand .. " printers", HOME .. ".config/awesome/icons/printers.png"},
            {"Privacy", settingsCommand .. " privacy", HOME .. ".config/awesome/icons/privacy.png"},
            {"Region & Language", settingsCommand .. " region", HOME .. ".config/awesome/icons/region.png"},
            {"Search", settingsCommand .. " search", HOME .. ".config/awesome/icons/search.png"},
            {"Sharing", settingsCommand .. " sharing", HOME .. ".config/awesome/icons/sharing.png"},
            {"Sound", settingsCommand .. " sound", HOME .. ".config/awesome/icons/volume.png", HOME .. ".config/awesome/icons/background.png"},
            {"Universal Access", settingsCommand .. " universal-access", HOME .. ".config/awesome/icons/universal access.png"},
            {"User accounts", settingsCommand .. " user-accounts", HOME .. ".config/awesome/icons/user accounts.png"},
            {"Wacom Tablet", settingsCommand .. " wacom", HOME .. ".config/awesome/icons/wacom.png"}
           }

shutdown = "shutdown now"
restart = "reboot"
logout = awesome.quit

power = {
   { "Shut down", shutdown, HOME .. ".config/awesome/icons/power.png"},
   { " Restart", "sync " .. restart, HOME .. ".config/awesome/icons/restart.png"},
   { " Log out", logout, HOME .. ".config/awesome/icons/quit.jpg" }
}
games = {
    {"Minecraft", "java -jar " .. HOME .. ".minecraftMy/mcLauncher.jar", HOME .. ".config/awesome/icons/minecraft.png"},
    {"Assaultcube", "assaultcube", HOME .. ".config/awesome/icons/assaultcube.png"},
    {"Liquidwar", "liquidwar", HOME .. ".config/awesome/icons/liquidwar.png"}
}
mymainmenu = awful.menu({ items = { { "Programs", programs, HOME .. ".config/awesome/icons/apps.png" }, 
                                    { "Power", power, HOME .. ".config/awesome/icons/power.png" },
                                    { "Settings", settings, HOME .. ".config/awesome/icons/setting.png"},
                                    { "Games", games, HOME .. ".config/awesome/icons/games.png"},
                                    { "E-mail", emails, HOME .. ".config/awesome/icons/email.png"},
                                    { "Social Net", socialNet, HOME .. ".config/awesome/icons/facebook.png"},
                                    { "Arch Linux News", "terminator -e \"bash " .. HOME .. "news.sh && echo \"Press CTRL+c for exit\" && cat\""}
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibox

-- Create a wibox for each screen and add it
mywibox = {}
mytop = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.focused, mytaglist.buttons)
    -- _________________________________________________________|
    --|
    --sudo cp ~/.config/awesome/structs/tasklist.lua /use/share/awesome/lub/awful/widget/tasklist.lua

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "bottom", screen = s })
    mytop[s] = awful.wibox({ position = "top", screen = s})

    -- Cpu Status
    mycpu = wibox.widget.textbox() 
    vicious.register(mycpu, vicious.widgets.cpu, " <span color=\"red\">CPU</span>: All: <span color=\"red\">$1%</span> First: <span color=\"red\">$2%</span> Second: <span color=\"red\">$3%</span> ")

    -- Battery Status
    mybattery = {}
    mybattery.widget = wibox.widget.textbox() 
    mybattery.icon = wibox.widget.imagebox()
    mybattery.icon:set_image (HOME .. ".config/awesome/icons/battery.png")
    vicious.register(mybattery.widget, vicious.widgets.bat, "Battery: <span color=\"red\">$2%$1</span>", 10, "BAT0")
    
    -- Mouse bindings
    mybattery.widget:buttons(
     awful.util.table.join(awful.button({ }, 1, function () awful.util.spawn("gnome-control-center power") end))
    )
    mybattery.icon:buttons(
     awful.util.table.join(awful.button({ }, 1, function () awful.util.spawn("gnome-control-center power") end))
    )
    -- Keyboard map indicator and changer
    kbdcfg = {}
    kbdcfg.layout = { { "us", "" }, { "bg", "" }, {"bg", "phonetic" } }
    kbdcfg.current = 1
    kbdcfg.widget = wibox.widget.textbox()
    kbdcfg.widget:set_text(" " .. kbdcfg.layout[kbdcfg.current][1] .. " " .. kbdcfg.layout[kbdcfg.current][2] .. " ")
    kbdcfg.switch = function ()
      kbdcfg.current = kbdcfg.current % #(kbdcfg.layout) + 1
      local t = kbdcfg.layout[kbdcfg.current]
      kbdcfg.widget:set_text(" " .. t[1] .. " " .. t [2] .. " ")
      os.execute( "setxkbmap " .. t[1] .. " " .. t[2] )
    end

    -- Mouse bindings
    kbdcfg.widget:buttons(
     awful.util.table.join(awful.button({ }, 1, function () kbdcfg.switch() end))
    )

    -- Volume widget (textbox + imagebox)
    volwidget = {}

    volwidget.widget = wibox.widget.imagebox()
    volwidget.widget:set_image(HOME .. ".config/awesome/icons/volume.png")

    volwidget.widget1 = wibox.widget.textbox()
    vicious.register(volwidget.widget1, vicious.widgets.volume, " Volume: <span color=\"red\">$1% $2</span> ", 2, "Master")
    
    -- Mouse bindings
    volwidget.widget:buttons(
     awful.util.table.join(awful.button({ }, 1, function () awful.util.spawn("gnome-control-center sound") end))
    )
    volwidget.widget1:buttons(
     awful.util.table.join(awful.button({ }, 1, function () awful.util.spawn("gnome-control-center sound") end))
    )

    -- Date & Time settings (textclock)
    datetime = {}
    datetime.widget = awful.widget.textclock(" %d %B %Y %A, %H:%M:%S ", 1)

    -- Mouse bindings
    datetime.widget:buttons(
     awful.util.table.join(awful.button({ }, 1, function () awful.util.spawn("gnome-control-center datetime") end))
    )

    local naughty = require("naughty")
    local beautiful = require("beautiful")

    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mylauncher)
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    right_layout:add(kbdcfg.widget)
    right_layout:add(datetime.widget)
    right_layout:add(mylayoutbox[s])

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)

    local left = wibox.layout.fixed.horizontal()
    
    left:add (mycpu)
    
    local right = wibox.layout.fixed.horizontal()
    right:add (volwidget.widget1)
    right:add (volwidget.widget)
    if s == 1 then right:add(wibox.widget.systray()) end

    local middle1 = wibox.layout.fixed.horizontal()
    
    middle1:add (mybattery.widget);
    middle1:add (mybattery.icon);

    local layout1 = wibox.layout.align.horizontal()
    layout1:set_left(left)
    layout1:set_middle(middle1)
    layout1:set_right(right)


    mytop[s]:set_widget(layout1)
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "l",      function () awful.util.spawn ("xscreensaver-command -lock")end ),
    awful.key({ modkey,           }, "g",      function () awful.util.spawn (chromium .. " gmail.com")end ),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Return", function ()     kbdcfg.switch() end),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "s", function () mymainmenu:show() end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.swap.byidx(  1)
        end),

    -- Standard program
    awful.key({ modkey,  "Shift"  }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Prompt
    awful.key({ modkey, "Shift"   }, "p",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey,         
      }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "" .. i,
                  function ()
                        local screen = mouse.screen
                        local tag = awful.tag.gettags(screen)[i]
                        if tag then
                           awful.tag.viewonly(tag)
                        end
                  end),
        awful.key({ modkey, "Control" }, "" .. i,
                  function ()
                      local screen = mouse.screen
                      local tag = awful.tag.gettags(screen)[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end),
        awful.key({ modkey, "Shift" }, "" .. i,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.movetotag(tag)
                          end
                     end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "" .. i,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.toggletag(tag)
                          end
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {

}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- buttons for the titlebar
        local buttons = awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                )

        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))
        left_layout:buttons(buttons)

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local middle_layout = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title:set_align("center")
        middle_layout:add(title)
        middle_layout:buttons(buttons)

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(middle_layout)

        awful.titlebar(c):set_widget(layout)
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
