-- Driver 
function getComponent(type)
    if (peripheral.wrap(type) == null) then
        return null
    else
        return peripheral.wrap(type)
    end
end

function renderText(mon, x, y, text, text_color, bg_color)
    mon.monitor.setBackgroundColor(bg_color)
    mon.monitor.setTextColor(text_color)
    mon.monitor.setCursorPos(x, y)
    mon.monitor.write(text)
end

function renderTextRight(mon, offset, y, text, text_color, bg_color)
    mon.monitor.setBackgroundColor(bg_color)
    mon.monitor.setTextColor(text_color)
    mon.monitor.setCursorPos(mon.X-string.len(tostring(text))-offset,y)
    mon.monitor.write(text)
end

function renderTextLeftRight(mon, x, y, offset, text1, text2, text1_color, text2_color, bg_color)
	draw_text(mon, x, y, text1, text1_color, bg_color)
	draw_text_right(mon, offset, y, text2, text2_color, bg_color)
end

function clear(mon)
    term.clear()
    term.setCursorPos(1, 1)
    mon.monitor.setBackgroundColor(colors.black)
    mon.monitor.clear()
    mon.monitor.setCursorPos(1, 1)
end

function splitString(s, delimiter)
    result = {};
    for match in (s .. delimiter):gmatch("(.-)" .. delimiter) do
        table.insert(result, match);
    end
    return result;
end
