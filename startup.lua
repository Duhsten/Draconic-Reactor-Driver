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
    sw.writeLine(autoInputGate)
    sw.writeLine(curInputGate)
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

        f.clear(mon)

        ri = reactor.getReactorInfo()

        -- print out all the infos from .getReactorInfo() to term

        if ri == nil then
            error("reactor has an invalid setup")
        end
        print("Output Gate: ", fluxgate.getSignalLowFlow())
        print("Input Gate: ", inputfluxgate.getSignalLowFlow())

        -- monitor output

    end
end

parallel.waitForAny(buttons, update)
