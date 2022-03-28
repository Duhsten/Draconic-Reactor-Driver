local modem = peripheral.wrap("back")

function commandLine()
    local input = read("cmd: ")
    modem.transmit(1,2, input)
end

while true do
    commandLine()
end