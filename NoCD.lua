local scriptId = tick()
_G.NoCD_ScriptId = scriptId
_G.NoCooldownEnabled = true

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local keys = {"Ability1", "Ability2", "Ability3", "Ability4", "Ability5", "Dash", "Block"}

local numCache = {}

local function updateNumCache()
    pcall(function()
        if not getgc then return end
        local raw = getgc(keys)
        local newCache = {}
        for _, e in ipairs(raw) do
            if e and (e.type == "number" or type(e.value) == "number") then
                table.insert(newCache, e)
            end
        end
        numCache = newCache
    end)
end

updateNumCache()

task.spawn(function()
    local lastChar = lp and lp.Character
    while _G.NoCD_ScriptId == scriptId and _G.NoCooldownEnabled do
        task.wait(3)
        if _G.NoCD_ScriptId ~= scriptId then break end
        
        local curChar = lp and lp.Character
        if curChar ~= lastChar then
            lastChar = curChar
            task.wait(0.5)
        end
        updateNumCache()
    end
end)

task.spawn(function()
    print("[Matcha] VM-Safe No Cooldown activated!")
    local cachedSkillsGui = nil

    while _G.NoCD_ScriptId == scriptId and _G.NoCooldownEnabled do
        for _, entry in ipairs(numCache) do
            if entry and entry.key and entry.value then
                local curVal = entry.value
                if type(curVal) == "number" and curVal > 0 then
                    pcall(setgc, entry.key, 0, curVal)
                end
            end
        end

        pcall(function()
            if lp and (not cachedSkillsGui or not cachedSkillsGui.Parent) then
                local playerGui = lp:FindFirstChild("PlayerGui")
                cachedSkillsGui = playerGui and playerGui:FindFirstChild("Skills")
            end
            
            if cachedSkillsGui then
                for _, obj in ipairs(cachedSkillsGui:GetDescendants()) do
                    if obj.Name == "CD" and obj.ClassName == "Frame" then
                        obj.Size = UDim2.new(0, 0, 1, 0)
                    end
                end
            end
        end)

        task.wait(0.05)
    end
    print("[Matcha] Previous No Cooldown instance stopped safely.")
end)

if notify then
    notify("No Cooldown", "VM-Safe CD Script Loaded!", 3)
end
