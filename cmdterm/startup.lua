local modem = peripheral.wrap("back")
modem.open(2)

function commandLine()
    print("cmd")
    local input = read()
    modem.transmit(1,2, input)
    event, side, frequency, replyFrequency, message, distance = os.pullEvent("modem_message")
    print(message)
end

while true do
    commandLine()
end