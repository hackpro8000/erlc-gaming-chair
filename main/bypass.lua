return function()
    return pcall(function()

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
    
        for _, conn in pairs(getconnections(LogService.MessageOut)) do
            conn:Disable()
        end
    
        for _, conn in pairs(getconnections(ScriptContext.Error)) do
            conn:Disable()
        end
    
        for _, conn in pairs(getconnections(LocalPlayer.PlayerGui.ChildAdded)) do
            conn:Disable()
        end
    
        LogService.MessageOut:Connect(function(e)
            rconsoleprint(e .. "\n")
        end)
    
        for i, v in pairs(workspace:GetDescendants()) do
    
            for _, conn in pairs(getconnections(v.AncestryChanged)) do
                conn:Disable()
            end
    
        end
    
    end)
end