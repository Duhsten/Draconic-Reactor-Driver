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
    mon.monitor.setCursorPos(x,y)
    mon.monitor.write(text)
  end
  function clear(mon)
    term.clear()
    term.setCursorPos(1,1)
    mon.monitor.setBackgroundColor(colors.black)
    mon.monitor.clear()
    mon.monitor.setCursorPos(1,1)
  end