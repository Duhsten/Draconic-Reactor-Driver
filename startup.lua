-- modifiable variables
local reactorName = "draconic_reactor_0"
local gateIn = "flow_gate_0"
local gateOut = "flow_gate_1"
local monitorName = "monitor_0"

local targetStrength = 50
local maxTemperature = 8000
local safeTemperature = 3000
local lowestFieldPercent = 15

local activateOnCharged = 1

-- please leave things untouched from here on
os.loadAPI("lib/driver")

local version = "0.0.1"
-- toggleable via the monitor, use our algorithm to achieve our target field strength or let the user tweak it
local autoInputGate = 1
local curInputGate = 222000

-- monitor 
local mon, monitor, monX, monY

-- peripherals
local reactor
local inputGate
local outputGate

-- reactor information
local ri

-- last performed action
local action = "None since reboot"
local emergencyCharge = false
local emergencyTemp = false

monitor = driver.getComponent(monitorName)
inputGate = driver.getComponent(gateIn)
outputGate = driver.getComponent(gateOut)
reactor = driver.getComponent(reactorName)

if monitor == null then
    error("Did not find Monitor")
end

if inputGate == null then
    error("Did not find Input Gate")
end

if outputGate == null then
    error("Did not find Output Gate")
end

if reactor == null then
    error("Did not find Reactor")
end

monX, monY = monitor.getSize()
mon = {}
mon.monitor, mon.X, mon.Y = monitor, monX, monY

-- write settings to config file
function save_config()
    sw = fs.open("config.txt", "w")
    sw.writeLine(version)
    sw.writeLine(inputGate)
    sw.writeLine(outputGate)
    sw.close()
end

-- read settings from file
function load_config()
    sr = fs.open("config.txt", "r")
    version = sr.readLine()
    autoInputGate = tonumber(sr.readLine())
    curInputGate = tonumber(sr.readLine())
    sr.close()
end

-- 1st time? save our settings, if not, load our settings
if fs.exists("config.txt") == false then
    save_config()
else
    load_config()
end

function update()
    while true do

        driver.clear(mon)

        ri = reactor.getReactorInfo()
        driver.renderText(mon, 2, 1, "Reactor Controller", colors.white, colors.black)
        -- print out all the infos from .getReactorInfo() to term

        if ri == nil then
            error("Reactor not properly setup")
        end
        print("Output Gate: ", outputGate.getSignalLowFlow())
        print("Input Gate: ", inputGate.getSignalLowFlow())

        -- monitor output

    end
end

function recieveCmd()
    while true do
        event, side, frequency, replyFrequency, message, distance = os.pullEvent("modem_message")
        print("Message received from the open modem on the "..side.." side of this computer.")
        print("Frequency: ".. frequency)
        print("Requested reply frequency: "..replyFrequency)
        print("Distance: "..distance)
        print("Message is as follows: "..message)
    end
end
parallel.waitForAny(update, commandLine)
