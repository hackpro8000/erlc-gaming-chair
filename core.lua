local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlr = Players.LocalPlayer

local Signal = loadstring(game:HttpGet('https://raw.githubusercontent.com/Sleitnick/RbxUtil/main/modules/signal/init.lua'))()
local Trove = loadstring(game:HttpGet('https://raw.githubusercontent.com/Sleitnick/RbxUtil/main/modules/trove/init.lua'))()

local core = {
    _trove = Trove.new()
}
core.properties = {
    carCollisionsEnabled = true,
    carBoosterEnabled = false,
    carBoosterForce = 1000,
    carBoosterKeybind = Enum.KeyCode.LeftControl,
    carAntiflipEnabled = false,
    carForcedTurningEnabled = false,
    carForcedTurningSpeed = 10,

    spidermanEnabled = false,
}
core.updateTasks = {}
core.onPropertyChanged = Signal.new()


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

-- vehicle collisions
function handleVehicleCollisions(vehicle)
    local ownVehicle = getOwnVehicle()
    local isOwnVehicle = vehicle == ownVehicle

    if not isOwnVehicle then
        for _, basepart in pairs(vehicle:GetDescendants()) do
            if basepart:IsA "BasePart" then
                basepart.CanCollide = core.properties.carCollisionsEnabled
            end
        end
    end
end

function onVehicleAdded(vehicle)
    local ownVehicle = getOwnVehicle()

    handleVehicleCollisions(vehicle)
end

function onVehicleCollisionChange()
    for _, vehicle in pairs(workspace.Vehicles:GetChildren()) do
        handleVehicleCollisions(vehicle)
    end
end

function whenPropertyChanged(name, value, oldValue)
    if name == "carCollisionsEnabled" then
        onVehicleCollisionChange()
    end
end

core._trove:Add(childAdded(workspace.Vehicles, onVehicleAdded))
core._trove:Add(core.onPropertyChanged:Connect(whenPropertyChanged))

function getXAxis()
    local leftDown = UserInputService:IsKeyDown(Enum.KeyCode.A)
    local rightDown = UserInputService:IsKeyDown(Enum.KeyCode.D)

    return (leftDown and -1) or (rightDown and 1) or 0
end

local climbableTruss = Instance.new("TrussPart")
climbableTruss.Name = "JHWEKHYKJHYWJHYJWWTWRWRWERWRWERWER"
climbableTruss.Anchored = true
climbableTruss.Transparency = 1
climbableTruss.Size = Vector3.new(2, 8, 2)
climbableTruss.Parent = workspace

-- nitro boost
core.updateTasks.nitroBoost = function()
    if UserInputService:GetFocusedTextBox() then
        return
    end

    local ownVehicle = getOwnVehicle()
    local ownVehicleBase = ownVehicle and ownVehicle.PrimaryPart

    if UserInputService:IsKeyDown(core.properties.carBoosterKeybind) then
        if ownVehicleBase then
            ownVehicleBase:ApplyImpulse(ownVehicleBase.CFrame.LookVector * core.properties.carBoosterForce)
        end
    end
end

core.updateTasks.antiFlip = function()
    local ownVehicle = getOwnVehicle()

    if core.properties.carAntiflipEnabled and ownVehicle then
        local carCF = ownVehicle:GetPivot()
    
        local carEulerAngles = Vector3.new(carCF:ToEulerAnglesYXZ()) * math.deg(1)

        local clampedEuler = Vector3.new(math.clamp(carEulerAngles.X, -60, 60), carEulerAngles.Y, math.clamp(carEulerAngles.Z, -60, 60)) * math.rad(1)

        ownVehicle:PivotTo(CFrame.new(carCF.Position) * CFrame.fromEulerAnglesYXZ(clampedEuler.X, clampedEuler.Y, clampedEuler.Z))
    end
end

core.updateTasks.forcedTurning = function()
    local deltaTime = core.deltaTime

    local ownVehicle = getOwnVehicle()

    if core.properties.carForcedTurningEnabled and ownVehicle then
        local carCF = ownVehicle:GetPivot()
    
        local carEulerAngles = Vector3.new(carCF:ToEulerAnglesYXZ()) * math.deg(1)

        ownVehicle:PivotTo(carCF * CFrame.Angles(0, core.properties.carForcedTurningSpeed * deltaTime * getXAxis(), 0))
    end
end

core.updateTasks.spiderman = core.safeFunction(function()
    if core.properties.spidermanEnabled then
        local character = LocalPlr.Character
        local characterCF = character and character:GetPivot()

        local params = RaycastParams.new()
        params.FilterDescendantsInstances = {character, climbableTruss}

        if character then
            local ray = workspace:Raycast(characterCF.Position, characterCF.LookVector * 1.65, params)
            
            if ray then
                climbableTruss.Position = ray.Position
            end
        end
    end
end)


-- core stuff below
function removeOldCore()
    local old_core = getgenv().gamingchairCore

    if old_core then
        old_core.clean()
    end
end

core.changeProperty = core.safeFunction(function(property, value)
    local oldValue = core.properties[property]
    core.properties[property] = value
    core.onPropertyChanged:Fire(property, value, oldValue)
    print(property, value)
end)

core.start = core.safeFunction(function()
    removeOldCore()
    getgenv().gamingchairCore = core

    core._trove:Add(function()
        getgenv().gamingchairCore = core
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