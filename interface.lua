local UILib = loadstring(game:HttpGet('https://raw.githubusercontent.com/Loco-CTO/UI-Library/main/VisionLibV2/source.lua'))()

local core = getgenv().gamingchairCore
local interface = {}

function waitforCore()
    repeat task.wait() until getgenv().gamingChairCore
    core = getgenv().gamingChairCore
end

function initWindow()
    interface.Window = UILib:Create {
        Name = "ERLC Gaming Chair",
        Footer = "What the fuck is a footer?!",
        ToggleKey = Enum.KeyCode.RightShift,
    }

    core._trove:Add(interface.Window)
end

function addWindowContent()
    do -- ito ay para sa trolling tab
        local trollingTab = interface.Window:Tab {
            Name = "Trolling",
            Color = Color3.new(0.85, 0.5, 0),
        }
        interface.Window.trollingTab = trollingTab

        local vehicleSection = trollingTab:Section {
            Name = "Vehicles"
        }
        trollingTab.vehicleSection = vehicleSection
        
        vehicleCollisionsToggle = vehicleSection:Toggle {
            Name = "Vehicle Collisions",
            Default = true,
            callback = function(on)
                core.properties.carCollisionsEnabled = on
            end
        }
    end
    
end

function interface.start()
    waitforCore()
    initWindow()
    addWindowContent()
end

return interface