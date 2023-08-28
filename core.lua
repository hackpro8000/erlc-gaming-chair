local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlr = Players.LocalPlayer

local Signal = loadstring(game:HttpGet('https://raw.githubusercontent.com/Sleitnick/RbxUtil/main/modules/signal/init.lua'))()
local Trove = loadstring(game:HttpGet('https://raw.githubusercontent.com/Sleitnick/RbxUtil/main/modules/trove/init.lua'))()

local core = {
    _trove = Trove.new()
}
core.properties = {
    carCollisionsEnabled = true,
    carBoosterEnabled = false,

    inputs = {
        carBooster = false,
    }
}
core.updateTasks = {}
core.onPropertyChanged = Signal.new()



function childAdded(inst, fn)
    for _, v in pairs(inst:GetChildren()) do
        fn(v)
    end
    return inst.ChildAdded:Connect(fn)
end

function getOwnVehicle()
    for _, vehicle in pairs(workspace.Vehicles:GetChildren()) do
        
        local controlValues = vehicle:FindFirstChild("Control_Values")
        local ownerId = controlValues and controlValues:FindFirstChild("OwnerId")

        if ownerId then
            if ownerId.Value == LocalPlr.UserId then
                return vehicle
            end
        end

    end
end

function handleVehicleCollisions(vehicle)
    local ownVehicle = getOwnVehicle()
    local isOwnVehicle = vehicle == ownVehicle

    for _, basepart in pairs(vehicle:GetDescendants()) do
        if basepart:IsA "BasePart" then
            basepart.CanCollide = not isOwnVehicle and core.properties.carCollisionsEnabled
        end
    end
end

function onVehicleAdded(vehicle)
    local ownVehicle = getOwnVehicle()

    handleVehicleCollisions(vehicle)
end

function onVehicleCollisionChange()
    handleVehicleCollisions()
end

function whenPropertyChanged(name, value, oldValue)
    if name == "carCollisionsEnabled" then
        onVehicleCollisionChange()
    end
end

core._trove:Add(childAdded(workspace.Vehicles, onVehicleAdded))
core._trove:Add(core.onPropertyChanged:Connect(whenPropertyChanged))



-- core stuff below
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

core.changeProperty = core.safeFunction(function(property, value)
    local oldValue = core.properties[property]
    core.properties[property] = value
    core.onPropertyChanged:Fire(property, value, oldValue)
end)

core.start = core.safeFunction(function()
    getgenv().gamingchairCore = core

    core._trove:Add(function()
        getgenv().gamingchairCore = nil
    end)

    core._trove:Add(RunService.Heartbeat:Connect(function(dt) core.deltaTime = dt
        core.update()
    end))
end, true)

core.update = core.safeFunction(function()
    for taskName, taskFn in pairs(core.updateTasks) do
        taskFn()
    end
end)

function core.clean()
    core._trove:Clean()
end

return core