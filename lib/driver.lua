-- Driver 


function getComponent(type)
    local names = peripheral.getNames()
    local i, name
    for i, name in pairs(names) do
       if peripheral.getType(name) == type then
          return peripheral.wrap(name)
       end
    end
    return null
 end

function renderText(mon, x, y, text, text_color, bg_color)
    mon.monitor.setBackgroundColor(bg_color)
    mon.monitor.setTextColor(text_color)
    mon.monitor.setCursorPos(x,y)
    mon.monitor.write(text)
  end