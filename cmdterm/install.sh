local startupURL = "https://raw.githubusercontent.com/Duhsten/Draconic-Reactor-Driver/main/cmdterm/startup.lua"
local startup
local startupFile



 
startup = http.get(startupURL)
startupFile = startup.readAll()

local file2 = fs.open("startup", "w")
file2.write(startupFile)
file2.close()