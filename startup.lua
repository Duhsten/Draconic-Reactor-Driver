-- modifiable variables
local reactorName = "draconic_reactor_0"
local gateIn = "flow_gate_0"
local gateOut = "flow_gate_1"
local monitorName = "monitor_0"
local modem = peripheral.wrap("back")
modem.open(1);
local targetStrength = 50
local maxTemperature = 8000
local safeTemperature = 3000
local lowestFieldPercent = 15

local activateOnCharged = 1

-- please leave things untouched from here on
os.loadAPI("lib/driver")

local version = "0.0.1"
-- toggleable via the monitor, use our algorithm to achieve our target field strength or let the user tweak it
local manualInputGate = 1000;
local manualOutputGate = 1000;

-- monitor 
local mon, monitor, monX, monY

-- peripherals
local reactor
local inputGate
local outputGate

-- reactor information
local ri
local autoState = 1

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
        driver.renderText(mon, 2, 3, statusText(ri.status), colors.white, statusColor(ri.status))
        -- print out all the infos from .getReactorInfo() to term

        if ri == nil then
            error("Reactor not properly setup")
        end
        if (autoState == 1) then
            if (ri.temperature >= 8000 or nil) then
                reactorFailure("temp")
            end

        else
            outputGate.setSignalLowFlow(manualOutputGate)
            inputGate.setSignalLowFlow(manualInputGate)
        end
        print("Output Gate: ", outputGate.getSignalLowFlow())
        print("Input Gate: ", inputGate.getSignalLowFlow())

        -- monitor output
        sleep(0.1)
    end
end

function reactorFailure(status)
    if status == "temp" then
        reactor.stopReactor()
    end
end
function runCmd(cmd)
    local cmds = driver.splitString(cmd, " ")
    if cmds[1] == "charge" then
        reactor.chargeReactor()
        modem.transmit(2, 1, "Charging Reactor")
    elseif cmds[1] == "activate" or cmds[1] == "start" then
        reactor.activateReactor()
        modem.transmit(2, 1, "Activating Reactor")
    elseif cmds[1] == "deactivate" or cmds[1] == "stop" then
        reactor.stopReactor()
        modem.transmit(2, 1, "Stopping Reactor")
    elseif cmds[1] == "control" or cmds[1] == "set" then
        if cmds[2] == "auto" or cmds[2] == "automatic" then
            autoState = 1
            modem.transmit(2, 1, "Switching to Automatic Control")
        elseif cmds[2] == "man" or cmds[2] == "manual" then
            autoState = 0
            modem.transmit(2, 1, "Switching to Manual Control")
        else
            modem.transmit(2, 1, "You need to clarify either Automatic or Manual")
        end
    elseif cmds[1] == "input" or cmds[1] == "in" then
        if cmds[2] ~= nil then
            manualInputGate = tonumber(cmds[2])
            modem.transmit(2, 1, "Updated Input Gate to " .. cmds[2] .. "/s")
        else
            modem.transmit(2, 1, "You need to clarify an amount")
        end
    elseif cmds[1] == "output" or cmds[1] == "out" then
        if cmds[2] ~= nil then
            manualOutputGate = tonumber(cmds[2])
            modem.transmit(2, 1, "Updated Output Gate to " .. cmds[2] .. "/s")
        else
            modem.transmit(2, 1, "You need to clarify an amount")
        end
    else
        modem.transmit(2, 1, "Unknown Command")
    end
end
function recieveCmd()
    while true do
        event, side, frequency, replyFrequency, message, distance = os.pullEvent("modem_message")
        runCmd(message)
        sleep(0.1)
    end

end

function statusColor(status)
    if status == "warming_up" then
        return colors.orange
    elseif status == "cold" then
        return colors.lightBlue
    elseif status == "cold" then
        return colors.lime
    elseif status == "beyond_hope" then
        return colors.red
    end
end

function statusText(status)
    if status == "warming_up" then
        return "Charging"
    elseif status == "cold" then
        return "Idle"
    elseif status == "cold" then
        return "Active"
    elseif status == "beyond_hope" then
        return "Critical Failure"
    end
end

parallel.waitForAny(recieveCmd, update)
