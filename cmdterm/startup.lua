local modem = peripheral.wrap("back")
modem.open(2)

function commandLine()
    print("cmd")
    local input = read()
    modem.transmit(1,2, input)
    print("")
    term.setTextColor( colors.cyan )
    event, side, frequency, replyFrequency, message, distance = os.pullEvent("modem_message")
    
    print(message)
    term.setTextColor( colors.white )
    print("")
end

while true do
    commandLine()
end