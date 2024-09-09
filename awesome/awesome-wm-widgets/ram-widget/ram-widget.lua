local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local watch = require("awful.widget.watch")
local wibox = require("wibox")

local ramgraph_widget = {}

local function worker(user_args)
    local args = user_args or {}
    local timeout = args.timeout or 1
    -- INFO: color icons ram widget
    local color_used = "#ffffffbb"
    local color_free = "#ffffff33"
    local color_buf = "#ffffff77"
    local widget_show_buf = args.widget_show_buf or false
    local widget_height = args.widget_height or 25
    local widget_width = args.widget_width or 25

    --- Text widget to display RAM used as a number
    local ram_text_widget = wibox.widget {
        font = 'JetBrains Mono Nerd Font SemiBold 12', -- beautiful.font,
        align = "left",
        valign = "center",
        forced_width = 24,
        widget = wibox.widget.textbox,
    }

    --- Main ram widget shown on wibar
    local ramgraph_widget = wibox.layout.fixed.horizontal()

    local piechart = wibox.widget {
        border_width = 0,
        colors = {
            color_used,
            color_free,
            color_buf,
        },
        display_labels = false,
        forced_height = widget_height,
        forced_width = widget_width,
        widget = wibox.widget.piechart,
    }

    ramgraph_widget:add(piechart)
    ramgraph_widget:add(ram_text_widget)

    --- Widget which is shown when the user clicks on the RAM widget
    local popup = awful.popup{
        ontop = true,
        visible = false,
        widget = {
            widget = wibox.widget.piechart,
            forced_height = 200,
            forced_width = 400,
            colors = {
                color_used,
                color_free,
                color_buf,  -- buf_cache
            },
        },
        shape = gears.shape.rounded_rect,
        border_color = beautiful.border_color_active,
        border_width = 0,
        offset = { y = 5 },
    }

    local total, used, free, shared, buff_cache, available, total_swap, used_swap, free_swap

    local function getPercentage(value)
        return math.floor(value / (total + total_swap) * 100 + 0.5) .. '%'
    end

    local function getPercentageWithoutPercent(value)
        return math.floor(value / (total + total_swap) * 100 + 0.5)
    end


    watch('bash -c "LANGUAGE=en_US.UTF-8 free | grep -z Mem.*Swap.*"', timeout,
        function(widget, stdout)
            total, used, free, shared, buff_cache, available, total_swap, used_swap, free_swap =
                stdout:match('(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*Swap:%s*(%d+)%s*(%d+)%s*(%d+)')

            if widget_show_buf then
                piechart.data = { used, free, buff_cache }
            else
                piechart.data = { used, total - used }
            end

            -- ram_text_widget:set_text(getPercentageWithoutPercent(used + used_swap))
            -- INFO: text color ram widget
            ram_text_widget:set_markup(getPercentageWithoutPercent(used + used_swap))

            if popup.visible then
                popup:get_widget().data_list = {
                    {'used ' .. getPercentage(used + used_swap), used + used_swap},
                    {'free ' .. getPercentage(free + free_swap), free + free_swap},
                    {'buff_cache ' .. getPercentage(buff_cache), buff_cache}
                }
            end
        end,
        ramgraph_widget
    )

    ramgraph_widget:buttons(
        awful.util.table.join(
            awful.button({}, 1, function()
                popup:get_widget().data_list = {
                    {'used ' .. getPercentage(used + used_swap), used + used_swap},
                    {'free ' .. getPercentage(free + free_swap), free + free_swap},
                    {'buff_cache ' .. getPercentage(buff_cache), buff_cache}
                }

                if popup.visible then
                    popup.visible = not popup.visible
                else
                    popup:move_next_to(mouse.current_widget_geometry)
                end
            end)
        )
    )

    return ramgraph_widget
end

return setmetatable(ramgraph_widget, { __call = function(_, ...)
    return worker(...)
end })
