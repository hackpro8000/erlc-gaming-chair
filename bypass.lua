return function()
    return pcall(function()
        local function kill(event)
            for _, conn in pairs(getconnections(event)) do
                conn:Disable()
            end
        end

        getgenv().gamingChairSafe = false

        local LogService = game:GetService("LogService")
        local ScriptContext = game:GetService("ScriptContext")
        local Players = game:GetService("Players")
        local HttpService = game:GetService("HttpService")
        local RunService = game:GetService("RunService")
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local UserInputService = game:GetService("UserInputService")
    
        local LocalPlayer = Players.LocalPlayer
        
        repeat task.wait() until #getconnections(LogService.MessageOut) > 0
        repeat task.wait() until #getconnections(ScriptContext.Error) > 0
        repeat task.wait() until #getconnections(LocalPlayer.PlayerGui.ChildAdded) > 0
    
        kill(LogService.MessageOut)
        kill(ScriptContext.Error)
        kill(LocalPlayer.PlayerGui.ChildAdded)
    
        LogService.MessageOut:Connect(function(e)
            rconsoleprint(e .. "\n")
        end)
    
        for i, v in pairs(workspace:GetDescendants()) do
            kill(v.AncestryChanged)
        end
    
        LocalPlayer.CharacterAdded:Connect(function(character)
            getgenv().gamingChairSafe = false

            if not character then
                return
            end
        
            local Humanoid = character:WaitForChild("Humanoid")
            local Root = character:WaitForChild("HumanoidRootPart")
        
            repeat task.wait() until #getconnections(Root:GetPropertyChangedSignal("Velocity")) > 0
            repeat task.wait() until #getconnections(Humanoid:GetPropertyChangedSignal("WalkSpeed")) > 0
            repeat task.wait() until #getconnections(Humanoid:GetPropertyChangedSignal("JumpPower")) > 0
        
            kill(Root:GetPropertyChangedSignal("Velocity"))
            kill(Humanoid:GetPropertyChangedSignal("WalkSpeed"))
            kill(Humanoid:GetPropertyChangedSignal("JumpPower"))
        
            character:GetPropertyChangedSignal("Parent"):Connect(function()
                local parent = character.Parent
        
                if parent == nil then
                    getgenv().gamingChairSafe = false
                end
            end)

            getgenv().gamingChairSafe = true
        end)

        getgenv().gamingChairSafe = true
    end)
end