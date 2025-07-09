Services = {

        Players = game:GetService("Players"),

        LocalPlayer = game:GetService("Players").LocalPlayer,

        RunService = game:GetService("RunService"),

        ReplicatedStorage = game:GetService("ReplicatedStorage")

    }



     LocalPlayer = Services.Players.LocalPlayer



     Settings = {

        ["Grab"] = {

            Grab = true,

            GrabbedCharacter = nil

        }

    }



    local Cache = {

        ["Loops"] = {},

        ["Tools"] = {},

        ["GrabAnim"] = nil

    }



    local IsGrabbing = false



    local function stopGrabAnimation()

    if Cache["GrabAnim"] then

    Cache["GrabAnim"]:Stop()

    Cache["GrabAnim"] = nil

    end

    end

    local lp = game.Players.LocalPlayer



    local function handleGrabbed()

    local character = LocalPlayer.Character

    if not character then return end



    local grabbedValue = character:WaitForChild("BodyEffects"):WaitForChild("Grabbed")



    grabbedValue:GetPropertyChangedSignal("Value"):Connect(function()

        local grabbedPlayerName = tostring(grabbedValue.Value)

        local grabbedPlayer = Services.Players:FindFirstChild(grabbedPlayerName)



        if grabbedPlayer and grabbedPlayer.Character and grabbedPlayerName ~= "" then

        Settings["Grab"]["GrabbedCharacter"] = grabbedPlayer.Character

        IsGrabbing = true



        repeat task.wait() until Settings["Grab"]["GrabbedCharacter"]:FindFirstChild("GRABBING_CONSTRAINT")



        if not Settings["Grab"]["GrabbedCharacter"]:FindFirstChild("GRABBING_CONSTRAINT"):FindFirstChild("H") then

        return

        end



        local humanoid = character:FindFirstChildOfClass("Humanoid")

        local animator = humanoid and humanoid:FindFirstChildOfClass("Animator")

        if not animator then

        animator = Instance.new("Animator", humanoid)

        end



        local Player = game:GetService("Players").LocalPlayer

        local ReplicatedStorage = game:GetService("ReplicatedStorage")



        local Boombox = LocalPlayer.Backpack:FindFirstChild("[Boombox]")

        if Boombox then

        Boombox.Parent = LocalPlayer.Character

        ReplicatedStorage.MainEvent:FireServer("Boombox", 4799902666)

        Boombox.RequiresHandle = false

        Boombox.Parent = LocalPlayer.Backpack



        coroutine.wrap(function()

            task.wait(2.3)

            ReplicatedStorage.MainEvent:FireServer("BoomboxStop")

            end)()



        end



        local Backpack = Player:FindFirstChild("Backpack") or Player:WaitForChild("Backpack")



        local Phone = Backpack and Backpack:FindFirstChild("[Phone]")

        if Phone then

        Phone.RequiresHandle = false

        Phone.Parent = Player.Character

        Phone.Parent = Backpack

        end





        local grabAnimation = Instance.new("Animation")

        grabAnimation.AnimationId = "rbxassetid://3135389157"

        local GrabAnim = animator:LoadAnimation(grabAnimation)

        GrabAnim.Priority = Enum.AnimationPriority.Action4

        GrabAnim.Looped = false

        GrabAnim:Play()

        GrabAnim:AdjustSpeed(0)

        GrabAnim.TimePosition = 0.1



        Cache["GrabAnim"] = GrabAnim



        local grabbedTorso = Settings["Grab"]["GrabbedCharacter"]:FindFirstChild("UpperTorso")

        local BodyPosition = Instance.new("BodyPosition", grabbedTorso)

        local BodyGyro = Instance.new("BodyGyro", grabbedTorso)



        BodyPosition.D = 200

        BodyPosition.MaxForce = Vector3.new(10000, 10000, 10000)

        BodyGyro.D = 100

        BodyGyro.MaxTorque = Vector3.new(10000, 10000, 10000)



        local function updatePosition()

        local rightHand = character:FindFirstChild("RightHand")

        local humanoidRoot = character:FindFirstChild("HumanoidRootPart")

        if rightHand and humanoidRoot and grabbedTorso then

        BodyPosition.Position = rightHand.Position - Vector3.new(0, 1, 0)

        BodyGyro.CFrame = CFrame.new(grabbedTorso.Position, humanoidRoot.Position)

        else

            if Cache["GrabAnim"] then

        Cache["GrabAnim"]:Stop()

        end

        end

        end



        updatePosition()

        Settings["Grab"]["GrabbedCharacter"]["GRABBING_CONSTRAINT"]:FindFirstChild("H").Length = 9e9



        if Cache["Loops"]["Grab"] then Cache["Loops"]["Grab"]:Disconnect() end

        Cache["Loops"]["Grab"] = Services.RunService.Heartbeat:Connect(updatePosition)

        else

            if Cache["Loops"]["Grab"] then

        Cache["Loops"]["Grab"]:Disconnect()

        Cache["Loops"]["Grab"] = nil

        end



        if Cache["GrabAnim"] then

        Cache["GrabAnim"]:Stop()

        Cache["GrabAnim"] = nil

        end



        if Settings["Grab"]["GrabbedCharacter"] then

        local grabbedTorso = Settings["Grab"]["GrabbedCharacter"]:FindFirstChild("UpperTorso")

        if grabbedTorso then

        for _, obj in ipairs(grabbedTorso:GetChildren()) do

        if obj:IsA("BodyPosition") or obj:IsA("BodyGyro") then

        obj:Destroy()

        end

        end

        end

        end



        IsGrabbing = false

        Settings["Grab"]["GrabbedCharacter"] = nil

        end

        end)

    end



    LocalPlayer.CharacterAdded:Connect(function()

        task.wait(1)

        handleGrabbed()

        end)



    if LocalPlayer.Character then

    handleGrabbed()

    end



    local function createTools()

    local RipTool = Instance.new("Tool", game.Players.LocalPlayer.Backpack)

    RipTool.Name = "Rip in half"

    RipTool.RequiresHandle = false



    RipTool.Activated:Connect(function()

        if not IsGrabbing or not Settings["Grab"]["GrabbedCharacter"] then return end



        local targetCharacter = Settings["Grab"]["GrabbedCharacter"]

        local upperTorso = targetCharacter:FindFirstChild("UpperTorso") or targetCharacter:FindFirstChild("HumanoidRootPart")



        local Boombox = LocalPlayer.Backpack:FindFirstChild("[Boombox]")

        if Boombox then

        Boombox.Parent = LocalPlayer.Character

        ReplicatedStorage.MainEvent:FireServer("Boombox", 5933893953)

        Boombox.RequiresHandle = false

        Boombox.Parent = LocalPlayer.Backpack



        coroutine.wrap(function()

            task.wait(2.3)

            ReplicatedStorage.MainEvent:FireServer("BoomboxStop")

            end)()



        end



        local humanoid = lp.Character:FindFirstChildOfClass("Humanoid")

        if humanoid then

        local animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)



        local ripAnimation = Instance.new("Animation")

        ripAnimation.AnimationId = "rbxassetid://8254789608"

        local ripAnimTrack = humanoid:LoadAnimation(ripAnimation)

        ripAnimTrack.Priority = Enum.AnimationPriority.Action4

        ripAnimTrack.Looped = false

        ripAnimTrack:Play()



        task.wait(0.4)

        end



        for _, limbName in ipairs({

            "RightUpperArm", "LeftUpperArm", "RightUpperLeg", "LeftUpperLeg"

        }) do

        local limb = targetCharacter:FindFirstChild(limbName)

        if limb then

        limb.Position = Vector3.new(0, -1200, 0)

        end

        end



        IsGrabbing = false

        end)



    local SexTool = Instance.new("Tool", Services.LocalPlayer.Backpack)

    SexTool.Name = "Sex"

    SexTool.RequiresHandle = false



    SexTool.Activated:Connect(function()

        if not IsGrabbing or not Settings["Grab"]["GrabbedCharacter"] then return end



        local success, err = pcall(function()

            if Cache["GrabAnim"] then

            Cache["GrabAnim"]:Stop()

            Cache["GrabAnim"] = nil

            end



            local humanoid = Services.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

            if not humanoid then return end



            local animator = humanoid:FindFirstChildOfClass("Animator")

            if not animator then

            animator = Instance.new("Animator", humanoid)

            end



            local anim1 = Instance.new("Animation")

            anim1.AnimationId = "rbxassetid://4784557631"

            local animTrack1 = humanoid:LoadAnimation(anim1)

            animTrack1.Priority = Enum.AnimationPriority.Action4

            animTrack1:Play()



            local anim2 = Instance.new("Animation")

            anim2.AnimationId = "rbxassetid://3119980985"

            local animTrack2 = humanoid:LoadAnimation(anim2)

            animTrack2.Priority = Enum.AnimationPriority.Action4

            animTrack2:Play()

            animTrack2:AdjustSpeed(1.5)



            for _, part in pairs(Settings["Grab"]["GrabbedCharacter"]:GetDescendants()) do

            if part:IsA("BodyPosition") or part:IsA("BodyGyro") or part:IsA("BodyVelocity") then

            part:Destroy()

            end

            end



            Settings["Grab"]["Grab"] = false



            repeat task.wait()

            if not Settings["Grab"]["GrabbedCharacter"] then break end



            local grabbedChar = Settings["Grab"]["GrabbedCharacter"]

            local upperTorso = grabbedChar:FindFirstChild("UpperTorso")

            local rootPart = Services.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")



            if upperTorso and rootPart then

            local Sine = tick() * 60

            upperTorso.CFrame = rootPart.CFrame * CFrame.new(0, -0.3, -2 + 0.5 * math.sin(Sine / 2)) * CFrame.Angles(math.pi * -0.3, 0, 0)

            end

            until not Settings["Grab"]["GrabbedCharacter"]



            animTrack1:Stop()

            animTrack2:Stop()



            Settings["Grab"]["Grab"] = true

            end)



        if not success then

        warn("An error occurred when using Sex: [ " .. err .. " ]")

        end

        stopGrabAnimation()



        end)

    end



    local function onCharacterAdded(character)

    repeat task.wait() until Services.LocalPlayer.Backpack

    createTools()

    end



    Services.LocalPlayer.CharacterAdded:Connect(onCharacterAdded)



    if Services.LocalPlayer.Character then

    onCharacterAdded(Services.LocalPlayer.Character)

    end



    local function playAnimation(character, animationId)

    local humanoid = character and character:FindFirstChildOfClass("Humanoid")

    if humanoid then

    local animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)

    local animation = Instance.new("Animation")

    animation.AnimationId = "rbxassetid://" .. animationId

    local animationTrack = animator:LoadAnimation(animation)

    animationTrack.Priority = Enum.AnimationPriority.Action4

    animationTrack.Looped = false

    animationTrack:Play()

    return animationTrack

    end

    end



    local function createWormTool()

    local WormTool = Instance.new("Tool", Services.LocalPlayer.Backpack)

    WormTool.Name = "Orbit"

    WormTool.RequiresHandle = false



    local OrbitConnection = nil

    local IsOrbiting = false

    local AnimationTrack = nil



    local function stopOrbit()

    if OrbitConnection then

    OrbitConnection:Disconnect()

    OrbitConnection = nil

    end

    if AnimationTrack then

    AnimationTrack:Stop()

    AnimationTrack = nil

    end

    end



    local function startOrbit()

    if not IsGrabbing or not Settings["Grab"]["GrabbedCharacter"] then

    stopOrbit()

    return

    end

    stopGrabAnimation()



    local targetCharacter = Settings["Grab"]["GrabbedCharacter"]

    local grabbedTorso = targetCharacter:FindFirstChild("HumanoidRootPart")



    if not grabbedTorso then return end



    local character = Services.LocalPlayer.Character

    local humanoid = character and character:FindFirstChildOfClass("Humanoid")



    local currentTime = 0



    if OrbitConnection then

    OrbitConnection:Disconnect()

    end



-- Load and play the animation

    if humanoid then

    local animation = Instance.new("Animation")

    animation.AnimationId = "rbxassetid://11394033602"

    AnimationTrack = humanoid:LoadAnimation(animation)

    AnimationTrack.Looped = true

    AnimationTrack:Play()

    end



    OrbitConnection = Services.RunService.Heartbeat:Connect(function(delta)

        currentTime = currentTime + delta

        if not IsGrabbing or not Settings["Grab"]["GrabbedCharacter"] then

        stopOrbit()

        return

        end



        local humanoidRoot = character and character:FindFirstChild("HumanoidRootPart")



        if humanoidRoot then

        local radius = 10 + math.sin(currentTime * 2) * 3



        Settings["Grab"]["GrabbedCharacter"].UpperTorso.CFrame = CFrame.Angles(math.pi * 0.1, 1.5 * math.pi * currentTime, 0) * CFrame.new(radius, 2, radius) + humanoidRoot.Position

        Settings["Grab"]["GrabbedCharacter"].LowerTorso.CFrame = CFrame.Angles(math.pi * -0.1, 1.5 * math.pi * -currentTime, 0) * CFrame.new(radius, 2, radius) + humanoidRoot.Position

        Settings["Grab"]["GrabbedCharacter"].LeftUpperArm.CFrame = CFrame.Angles(math.pi * .25, 3 * math.pi * currentTime, 0) * CFrame.new(radius, 2, radius) + humanoidRoot.Position

        Settings["Grab"]["GrabbedCharacter"].RightUpperArm.CFrame = CFrame.Angles(math.pi * -.25, 3 * math.pi * -currentTime, 0) * CFrame.new(radius, 2, radius) + humanoidRoot.Position

        Settings["Grab"]["GrabbedCharacter"].LeftUpperLeg.CFrame = CFrame.Angles(math.pi * .3, 2.5 * math.pi * currentTime, 0) * CFrame.new(radius, 2, radius) + humanoidRoot.Position

        Settings["Grab"]["GrabbedCharacter"].RightUpperLeg.CFrame = CFrame.Angles(math.pi * -.3, 2.5 * math.pi * -currentTime, 0) * CFrame.new(radius, 0, radius) + humanoidRoot.Position

        Settings["Grab"]["GrabbedCharacter"].LeftLowerLeg.CFrame = CFrame.Angles(math.pi * .7, 2 * math.pi * currentTime, 0) * CFrame.new(radius, 2, radius + 2) + humanoidRoot.Position

        Settings["Grab"]["GrabbedCharacter"].RightLowerLeg.CFrame = CFrame.Angles(math.pi * .8, 2 * math.pi * -currentTime, 0) * CFrame.new(radius, 2, radius + 2) + humanoidRoot.Position

        Settings["Grab"]["GrabbedCharacter"].LeftLowerArm.CFrame = CFrame.Angles(math.pi * .9, 2 * math.pi * currentTime, 0) * CFrame.new(radius, 2, radius + 2) + humanoidRoot.Position

        Settings["Grab"]["GrabbedCharacter"].RightLowerArm.CFrame = CFrame.Angles(math.pi * 1, 2 * math.pi * -currentTime, 0) * CFrame.new(radius, 2, radius + 2) + humanoidRoot.Position

        end

        end)

    end



    WormTool.Activated:Connect(function()

        IsOrbiting = not IsOrbiting

        if IsOrbiting then

        startOrbit()

        else

            stopOrbit()

        end

        end)



    WormTool.Deactivated:Connect(function()

        end)

    end



    local function onCharacterAdded(character)

    task.wait(1)

    createWormTool()

    end



    Services.LocalPlayer.CharacterAdded:Connect(onCharacterAdded)



    if Services.Players.LocalPlayer.Character then

    onCharacterAdded(Services.Players.LocalPlayer.Character)

    end
