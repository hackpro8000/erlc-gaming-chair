local UILib = loadstring(game:HttpGet('https://raw.githubusercontent.com/Loco-CTO/UI-Library/main/VisionLibV2/source.lua'))()

local core = getgenv().gamingchairCore
local interface = {}

function interface.start()
    interface.Window = UILib:Create {
        Name = "ERLC Gaming Chair",
        Footer = "What the fuck is a footer?!",
        ToggleKey = Enum.KeyCode.RightShift,
    }

    core._trove:Add(interface.Window)
end

return interface