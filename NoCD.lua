_G.NoCooldownEnabled = true

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local keys = {"Ability1", "Ability2", "Ability3", "Ability4", "Ability5", "Dash", "Block"}

task.spawn(function()
    print("[Matcha] No Cooldown activated!")
    while _G.NoCooldownEnabled do
        pcall(function()
            local list = getgc(keys)
            for _, e in ipairs(list) do
                if e.type == "number" then
                    local num = tonumber(e.value)
                    if num and num > 0 then
                        setgc(e.key, 0, num)
                    end
                end
            end
        end)

        pcall(function()
            local playerGui = lp:FindFirstChild("PlayerGui")
            if playerGui then
                local skillsGui = playerGui:FindFirstChild("Skills")
                if skillsGui then
                    for _, obj in ipairs(skillsGui:GetDescendants()) do
                        if obj.Name == "CD" and obj.ClassName == "Frame" then
                            obj.Size = UDim2.new(0, 0, 1, 0)
                        end
                    end
                end
            end
        end)

        task.wait(0.03)
    end
    print("[Matcha] No Cooldown stopped.")
end)

if notify then
    notify("No Cooldown", "CDs disabled!", 3)
end
