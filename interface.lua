local UILib = loadstring(game:HttpGet('https://raw.githubusercontent.com/Loco-CTO/UI-Library/main/VisionLibV2/source.lua'))()

local core = getgenv().gamingchairCore
local interface = {}

function waitforCore()
    repeat task.wait() until getgenv().gamingchairCore
    core = getgenv().gamingchairCore
    print("core found! loading interface...")
end

function initWindow()
    interface.Window = UILib:Create {
        Name = "ERLC Gaming Chair",
        Footer = "What the fuck is a footer?!",
        ToggleKey = Enum.KeyCode.RightShift,
    }

    core._trove:Add(function()
        interface.Window:Destroy()
    end)
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
        
        local vehicleCollisionsToggle = vehicleSection:Toggle {
            Name = "Vehicle Collisions",
            Default = true,
            Callback = function(on)
                core.changeProperty("carCollisionsEnabled", on)
            end
        }
        vehicleSection.vehicleCollisionsToggle = vehicleCollisionsToggle
    
        local vehicleNitroBoostToggle = vehicleSection:Toggle {
            Name = "Vehicle Nitro Booster",
            Default = true,
            Callback = function(on)
                core.changeProperty("carBoosterEnabled", on)
            end
        }
        vehicleSection.vehicleNitroBoostToggle = vehicleNitroBoostToggle

        local vehicleNitroPowerSlider = vehicleSection:Slider {
            Name = "Vehicle Nitro Boost Power",
            Default = 1000,
            Min = 0,
            Max = 10000,
            Callback = function(value)
                core.changeProperty("carBoosterForce", value)
            end
        }

        local vehicleNitroBoostKeybind = vehicleSection:Keybind {
            Name = "Vehicle Nitro Booster Key",
            Default = Enum.KeyCode.LeftControl,
            UpdateKeyCallback = function(keyCode)
                core.changeProperty("carBoosterKeybind", keyCode)
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