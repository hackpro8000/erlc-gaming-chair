local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Signal = loadstring(game:HttpGet('https://raw.githubusercontent.com/Sleitnick/RbxUtil/main/modules/signal/init.lua'))()
local Trove = loadstring(game:HttpGet('https://raw.githubusercontent.com/Sleitnick/RbxUtil/main/modules/trove/init.lua'))()

local core = setmetatable({}, Trove.new())
core.properties = {
    carCollisionsEnabled = true,
    carBoosterEnabled = false,

    inputs = {
        carBooster = false,
    }
}

function getOldCore()
    local old_core = getgenv().gamingchairCore

    if old_core then
        old_core.clean()
    end
end

function core.safeFunction(fn, shouldWait)
    return function(...)
        if getgenv().gamingChairSafe then
            return fn(...)
        else
            if shouldWait then
                repeat
                    task.wait()
                until getgenv().gamingChairSafe

                return fn(...)
            end
        end
    end
end

core.start = core.safeFunction(function()
    getgenv().gamingchairCore = core

    core:Add(function()
        getgenv().gamingchairCore = core
    end)

    core:Add(RunService.Heartbeat:Connect(function(dt) core.deltaTime = dt
        core.update()
    end))
end, true)

core.update = core.safeFunction(function()
    
end)

function core.clean()
    core:Clean()
end

return core