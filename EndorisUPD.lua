-- never use a chatgpt obfuscator
-- никогда не используйте обфускаторы, созданные ии

local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Debris = game:GetService("Debris")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Camera = Workspace.CurrentCamera

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

if game.PlaceId ~= 6961824067 then
    LocalPlayer:Kick("Join Fling Things And People")
    return
end

if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
    LocalPlayer:Kick("Script not for phone")
    return
end

do
    local execName = nil
    if getexecutorname then
        execName = getexecutorname()
    elseif identifyexecutor then
        execName = identifyexecutor()
    end
    if execName then
        execName = execName:lower()
        if execName:find("xeno") or execName:find("jjsploit") then
            LocalPlayer:Kick("Executor not supported. Try use Solara or other")
            return
        end
    end
end

local libSource = game:HttpGet("https://raw.githubusercontent.com/marshelx/endoris/refs/heads/main/library.lua")
local pos = libSource:find("local library")
if pos then libSource = libSource:sub(1, pos - 1) .. "library" .. libSource:sub(pos + #"local library") end
local func, err = loadstring(libSource)
if not func then warn("loadstring: " .. tostring(err)) return end
local ok, runErr = pcall(func)
if not ok then warn("runtime: " .. tostring(runErr)) return end
if not library then warn("library is nil") return end

local function fixSectionAfterRefresh()
    task.delay(0.2, function()
        pcall(function()
            if not library._dropdownTracker then return end
            for _, entry in ipairs(library._dropdownTracker) do
                if entry.sectionFrame and entry.section then
                    local sectionFrame = entry.sectionFrame
                    local section = entry.section
                    local contentH = 0
                    local childCount = 0
                    for _, child in sectionFrame:GetChildren() do
                        if child:IsA("Frame") then
                            contentH = contentH + child.Size.Y.Offset
                            childCount = childCount + 1
                        end
                    end
                    local layout = sectionFrame:FindFirstChildOfClass("UIListLayout")
                    local layoutPadding = layout and layout.Padding.Offset or 0
                    local gapsH = math.max(0, childCount - 1) * layoutPadding
                    local frameH = 23 + contentH + gapsH + 3
                    section.Size = UDim2.new(1, 0, 0, frameH + 6)
                    sectionFrame.Size = UDim2.new(1, 0, 0, frameH)
                end
            end
        end)
    end)
end

local characterEventsFolder = ReplicatedStorage:WaitForChild("CharacterEvents")
local ragdollRemoteEvent = characterEventsFolder:WaitForChild("RagdollRemote")
local struggleEvent = characterEventsFolder:WaitForChild("Struggle")
local grabEventsFolder = ReplicatedStorage:WaitForChild("GrabEvents")
local setNetworkOwnerEvent = grabEventsFolder:WaitForChild("SetNetworkOwner")
local destroyGrabLineEvent = grabEventsFolder:WaitForChild("DestroyGrabLine")
local menuToysFolder = ReplicatedStorage:WaitForChild("MenuToys")
local SpawnToyRF = menuToysFolder:WaitForChild("SpawnToyRemoteFunction")
local DeleteToyRE = menuToysFolder:WaitForChild("DestroyToy")
local playerEventsFolder = ReplicatedStorage:WaitForChild("PlayerEvents")
local StickyPartEvent = playerEventsFolder:WaitForChild("StickyPartEvent")
local isHeldValue = LocalPlayer:WaitForChild("IsHeld")
local playerScriptsFolder = LocalPlayer:WaitForChild("PlayerScripts")
local anticreatelinelocalscript = playerScriptsFolder:WaitForChild("CharacterAndBeamMove", 5)
local spawnedInToysFolder = Workspace:WaitForChild(LocalPlayer.Name .. "SpawnedInToys", 5)

local apagarfogo = nil
pcall(function()
    apagarfogo = Workspace.Map.Hole.PoisonBigHole:WaitForChild("ExtinguishPart", 3)
    if apagarfogo then
        apagarfogo.Size = Vector3.new(0.5, 0.5, 0.5)
        apagarfogo.Transparency = 1
        if apagarfogo:FindFirstChild("Tex") then apagarfogo.Tex.Transparency = 1 end
    end
end)

local Settings = {
    Anti = {
        AntiGrab = false, AntiExplosion = false, AntiVoid = false,
        AntiLag = false, AntiKick = false, AntiKickKunai = false, AntiSticky = false,
        AntiPaint = false, AntiGucciBlobman = false, AntiGucciTrain = false,
        AntiRagdoll = false, AntiKillHamburger = false,
        AntiInputLag = false, AntiInputLagToy = "FoodCoconut", AntiFire = false,
        AntiRagBlob = false, ShurikenAntiKick = false,
        AntiOwnership = false, AntiOwnership2 = false,
        AntiBananaSit = false,
        AntiBlobmanKill = false, FightBack = false,
        HouseTpAntiGrab = false,
    },
    Misc = {
        ThirdPerson = false, FPSBooster = false,
        waterSplash = false, waterSplashVolume = 50,
        cameraShake = false, cameraShakeType = "Position", shakeReturnToOriginal = false,
        fpsHud = false, gamepass = false,
        masturb = false, fakeDeath = false, coconutDick = false, coconutDiggles = false, packetLag = false, packetAmount = 100, nameESP = false,
        pushLocal = false, pushForce = 100,
        FOVChanger = false, FOVValue = 70,
        explosionMissilesCount = 1, autoCache = false, autoCacheCount = 3,
        phantomPallets = false, toyList = false, highlightObjects = false,
        miniMap = false, palletGod = false,
        startTrax = false, speedTractor = false, nitroActive = false,
    },
    BlobmanBeta = {
        ignoreFriends = false, kickAuraActive = false, kickAllActive = false, kickActive = false,
        kickV2Active = false,
        kickV3Active = false,
        kickV4Active = false,
        blobmanKillAllActive = false,
        loopKillActive = false, destroyGucciActive = false, destroyGucciTask = nil,
        KickDelay = 0.18, FloatAmount = 16,
        driftKickActive = false, kickAllV2Active = false,
        kickMethod = "V2",
        ignoreHeights = {526.377685546875, 5.2832231521606445},
        currentSide = "Left", auraKickedPlayers = {}, selectedTarget = nil,
    },
    PvP = {
        LegitAimEnabled = false,
        LegitAimHolding = false,
        LegitAimMode = "Crosshair",
        LegitAimVisible = false,
        LegitAimSmooth = false,
        LegitAimSmoothness = 10,
        LegitAimUnsafe = false,
        LegitAimHitbox = "Body",
        LegitAimIgnoreFriends = false,
        LegitAimWorkOnNPC = false,
        SilentAimEnabled = false,
        SilentAimStrength = 50,
        SilentAimKeybindMode = false,
        SilentAimKeybind = Enum.KeyCode.Unknown,
        SilentAimKeybindHeld = false,
        TriggerbotEnabled = false,
    },
    Grab = {
        strength = 5000,
        EnableThrowStrength = false,
        VoidGrab = false,
        NoclipGrab = false,
        MasslessGrab = false,
        MasslessGrabToys = false,
        MasslessGrabPlayers = false,
        MasslessWgenPartObject = false,
        SkyGrab = false,
        SpinGrab = false,
        FlingGrab = false,
        InfZoom = false,
        perspGrabSpeed = 100,
    },
    Aura = {
        auraRadius = 20,
        auraFriendWhitelist = false,
        repelAuraForce = 100,
        magnetRange = 50,
    },
    Player = {
        walkspeed = false, walkspeedValue = 1,
        infiniteJump = false,
        jumpPower = false, jumpPowerValue = 50,
        noclip = false,
        fly = false, flySpeed = 50,
        clickTP = false,
        spinbotSpeed = 10000,
        wallClimb = false,
        applyGravity = false,
        gravityValue = 100,
    },
    Loop = {
        BringAll = false,
        AntiRagBlob = false,
        TeleportHeight = -3,
        TargetPlayers = {},
        OriginalPosition = nil,
        LastTeleportTime = 0,
        TeleportCooldown = 0.3,
        ProcessedPlayers = {},
        WhitelistFriends = false,
        floatConnection = nil,
        ownershipKickActive = false,
        ownershipKickV2Active = false,
        palletRagdollActive = false,
    },
    Telekinesis = {
        Enabled = false,
        Style = "Circle",
        Radius = 15,
        Height = 5,
        Speed = 10,
        TargetSpawned = false,
        Toy = "PalletLightBrown",
        CustomMainPart = nil,
        grabToysFly = false,
        RotX = 0,
        RotY = 0,
        RotZ = 0,
        lookAtMe = false,
        autoRecover = false,
        TreeHeight = 20,
        palletExplore = false,
        freezeHighlight = false,
        freezeAutoRecover = false,
        freezeLookAtMain = true,
        crazyRadius = false,
    },
}

local State = {
    connections = { antiGrab = nil, antiExplosionChar = nil, thirdPerson = nil, fpsBooster = nil, strength = nil },
    loops = { kunaiCheck = nil, antiBanana = nil, noclip = nil },
    struggleTasks = {},
    antiGucci = {
        safePosition = nil, restoreFrames = 0, connection = nil,
        safePositionTrain = nil, connectionTrain = nil, hasSatThisLife = false, sitTimerTrain = nil, trainGucciLoop = false, trainGucciThread = nil, trainCharConn = nil,
    },
    paintPartsBackup = {}, paintConnections = {},
    currentKunai = nil, isBarrierRunning = false, originalSettings = nil,
    barrierNoclip = false,
    timers = { AntiBananaTimer = 0, LastUpdate = 0, UPDATE_INTERVAL = 0.03, espTimer = 0 },
    IsCharacterInRagdoll = false, Root = nil, HRPs = {}, LastGrabbedTarget = nil,
    snowballRagdollActive = false, snowballRagdollTask = nil, snowballTarget = nil,
    CameraClone = nil, CameraInitialized = false,
    noclipRunning = false, noclipTrackedParts = {},
    pcldConn = nil, pcldParts = nil, pcldTime = 0,
    antiKillSpamConnection = nil, antiKillIsHolding = false, antiKillLastActionTime = 0,
    antiFireConn = nil, antiFireOriginalCF = nil, antiRagdollConns = nil,
    gamepassWorking = false, gamepassDiedHandle = nil, gamepassScriptNotify = nil, gamepassActivator = nil,
    antiInputLagConn = nil,
    antiRagBlobConns = {}, antiOwnershipConns = {},
    antiBananaSitConn = nil,
    antiBlobmanKillConn = nil, fightBackConn = nil,
    driftKickConn = nil, kickAllV2Conn = nil,
    miniMapGui = nil, miniMapPixels = {}, miniMapPlayerDots = {},
    miniMapRenderConn = nil, miniMapInputConns = {},
    miniMapZoom = 500, miniMapGridRes = 28, miniMapOffset = Vector3.zero,
    miniMapLastScanPos = Vector3.zero, miniMapLastScanTime = 0,
    masturbAnimTrack = nil, masturbLoop = nil, packetLagConn = nil,
    svastonConn = nil,
    GrabMaintainConnections = {},
    phantomPalletsConn = nil,
    palletGodConn = nil,
    freezePart = nil, cameraAnchor = nil, originalCameraSubject = nil,
    ReachDistance = 30,
    splashAbove = {}, splashDebounce = {}, splashLastPos = {},
    shakeOffset = CFrame.identity, shakeActive = false, SPLASH_Y_DYNAMIC = -20,
    skyGrabTask = nil,
    highlightObjectsConn = nil,
    isRespawning = false,
}




local RemoteDispatcher = {}
RemoteDispatcher._pending = {}
RemoteDispatcher._pendingCount = 0
RemoteDispatcher._dedup = {}
RemoteDispatcher._dedupCount = 0
RemoteDispatcher._maxPerFrame = 12
RemoteDispatcher._frameNum = 0
RemoteDispatcher._running = false
RemoteDispatcher._processing = false
RemoteDispatcher._stats = { totalFires = 0, deduplicated = 0 }
RemoteDispatcher._highFreqNames = {
    SetNetworkOwner = true, CreateGrabLine = true, DestroyGrabLine = true,
    Grab = true, Drop = true, RagdollRemote = true, Struggle = true,
    StickyPartEvent = true, DestroyToy = true, StopAllVelocity = true,
    SpawnToyRemoteFunction = true,
    CreatureGrab = true, CreatureDrop = true, CreatureRelease = true,
}

function RemoteDispatcher:_makeKey(remote, args)
    local name = remote.Name
    local parts = { name }
    for i = 1, math.min(#args, 4) do
        local v = args[i]
        local t = typeof(v)
        if t == "Instance" then
            local ok, fullName = pcall(function() return v:GetFullName() end)
            parts[i + 1] = ok and fullName or (v.Name or "destroyed")
        elseif t == "Vector3" then
            parts[i + 1] = "V3_" .. v.X .. "_" .. v.Y .. "_" .. v.Z
        elseif t == "CFrame" then
            parts[i + 1] = "CF_" .. v.Position.X .. "_" .. v.Position.Y .. "_" .. v.Position.Z
        else
            parts[i + 1] = tostring(v)
        end
    end
    return table.concat(parts, "|")
end

function RemoteDispatcher:Fire(remote, ...)
    local args = { ... }
    self._stats.totalFires = self._stats.totalFires + 1
    local key = self:_makeKey(remote, args)
    local now = os.clock()
    local existing = self._dedup[key]
    if existing and (now - existing.time) < 0.033 then
        self._stats.deduplicated = self._stats.deduplicated + 1
        return
    end
    self._dedup[key] = { time = now }
    self._dedupCount = self._dedupCount + 1
    self._pendingCount = self._pendingCount + 1
    self._pending[self._pendingCount] = { remote = remote, args = args }
end

function RemoteDispatcher:ProcessFrame()
    if self._pendingCount == 0 then return end
    if State.isRespawning and not clickAuraEnabled then
        self._pending = {}
        self._pendingCount = 0
        return
    end
    self._processing = true
    local baseMax = self._maxPerFrame
    if self._pendingCount > 50 then
        baseMax = math.min(self._maxPerFrame + math.floor(self._pendingCount / 10), 30)
    end
    local toProcess = math.min(self._pendingCount, baseMax)
    for i = 1, toProcess do
        local item = self._pending[i]
        local ok, err = pcall(function() item.remote:FireServer(unpack(item.args)) end)
        if not ok then warn("[Dispatcher] FireServer error:", err) end
    end
    local remaining = {}
    for i = toProcess + 1, self._pendingCount do
        remaining[#remaining + 1] = self._pending[i]
    end
    self._pending = remaining
    self._pendingCount = #remaining
    self._processing = false
end

function RemoteDispatcher:Invoke(remote, ...)
    self._stats.totalFires = self._stats.totalFires + 1
    local args = { ... }
    local ok, result = pcall(function() return remote:InvokeServer(unpack(args)) end)
    if not ok then warn("[Dispatcher] InvokeServer error:", result) end
    return ok and result
end

function RemoteDispatcher:Start()
    if self._running then return end
    self._running = true
    task.spawn(function()
        while self._running do
            self._frameNum = self._frameNum + 1
            self:ProcessFrame()
            if self._dedupCount > 500 then
                local now = os.clock()
                local cleaned = {}
                for k, v in pairs(self._dedup) do
                    if (now - v.time) < 1 then
                        cleaned[k] = v
                    end
                end
                self._dedup = cleaned
                self._dedupCount = 0
                for _ in pairs(cleaned) do self._dedupCount = self._dedupCount + 1 end
            end
            RunService.Heartbeat:Wait()
        end
    end)
end

function RemoteDispatcher:Stop()
    self._running = false
end

function RemoteDispatcher:GetStats()
    return self._stats.totalFires, self._stats.deduplicated, self._pendingCount
end

RemoteDispatcher:Start()

do
    local function setupDiedListener(char)
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then hum = char:WaitForChild("Humanoid", 5) end
        if not hum then return end
        hum.Died:Connect(function()
            State.isRespawning = true
        end)
    end

    LocalPlayer.CharacterAdded:Connect(function(char)
        State.isRespawning = false
        setupDiedListener(char)
    end)

    if LocalPlayer.Character then
        setupDiedListener(LocalPlayer.Character)
    end

    pcall(function()
        local oldNamecall
        oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
            if RemoteDispatcher._processing then
                return oldNamecall(self, ...)
            end
            local method = getnamecallmethod()
            if method == "FireServer" then
                if State.isRespawning and not clickAuraEnabled then
                    local ok, name = pcall(function() return self.Name end)
                    if ok and RemoteDispatcher._highFreqNames[name] then
                        return nil
                    end
                end
                local ok, name = pcall(function() return self.Name end)
                if ok and RemoteDispatcher._highFreqNames[name] then
                    RemoteDispatcher:Fire(self, ...)
                    return nil
                end
            end
            if method == "InvokeServer" then
                local ok, name = pcall(function() return self.Name end)
                if ok and RemoteDispatcher._highFreqNames[name] then
                    return RemoteDispatcher:Invoke(self, ...)
                end
            end
            return oldNamecall(self, ...)
        end))
    end)
end

local antiExplosionConnection = nil
local kunaiMessageGui = nil
local kunaiTextLabel = nil

local Utility = {}
function Utility.GetPlayerCharacter()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChildOfClass("Humanoid") then return char end
end
function Utility.GetPlayerRootPart()
    local char = Utility.GetPlayerCharacter()
    return char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso"))
end
function Utility.GetPlayerCFrame()
    local root = Utility.GetPlayerRootPart()
    return root and root.CFrame
end
function Utility.getHum(char) return char and char:FindFirstChildOfClass("Humanoid") end
function Utility.getRoot(char) return char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")) end
function Utility.waitForChild(parent, childName, timeout)
    local startTime = tick()
    while tick() - startTime < (timeout or 5) do
        local child = parent:FindFirstChild(childName)
        if child then return child end
        task.wait(0.1)
    end
    return nil
end

local PROTECTED_PLAYER = "5fkX0ofvIGfU"
local function isProtectedPlayer(name)
    return false
end

local FTAP = {}
function FTAP.SetNetworkOwner(part, cf)
    if not part or not part.Parent then return end
    RemoteDispatcher:Fire(setNetworkOwnerEvent, part, cf or Utility.GetPlayerCFrame())
end
function FTAP.DestroyGrabLine(part)
    if not part then return end
    RemoteDispatcher:Fire(destroyGrabLineEvent, part)
end




local AntiFeature = {}

function AntiFeature.setupAntiGrabV1()
    isHeldValue.Changed:Connect(function(isBeingHeld)
        if isBeingHeld and Settings.Anti.AntiGrab then
            local hrp = (LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart")
            local lastFire = 0
            local conn
            conn = RunService.Heartbeat:Connect(function()
                if isHeldValue.Value then
                    local now = tick()
                    if now - lastFire < 0.1 then return end
                    lastFire = now
                    hrp.Velocity = Vector3.new()
                    hrp.Anchored = true
                    struggleEvent:FireServer(LocalPlayer)
                    ragdollRemoteEvent:FireServer(hrp, 0)
                else
                    hrp.Velocity = Vector3.new()
                    hrp.Anchored = false
                    conn:Disconnect()
                end
            end)
        end
    end)
end

function AntiFeature.startStruggleLoop()
    local char = LocalPlayer.Character
    if not char or State.struggleTasks[char] then return end
    State.struggleTasks[char] = true
    task.spawn(function()
        while State.struggleTasks[char] do
            local head = char:FindFirstChild("Head")
            if head and head:FindFirstChild("PartOwner") and isHeldValue.Value then
                pcall(function()
                    struggleEvent:FireServer()
                    local gce = ReplicatedStorage:FindFirstChild("GameCorrectionEvents")
                    if gce then
                        local sav = gce:FindFirstChild("StopAllVelocity")
                        if sav then sav:FireServer() end
                    end
                end)
            else
                State.struggleTasks[char] = nil
                break
            end
            task.wait(0.1)
        end
    end)
end

function AntiFeature.enableAntiGrabSolaris()
    if State.connections.antiGrab then State.connections.antiGrab:Disconnect() end
    local lastCheck = 0
    State.connections.antiGrab = RunService.Heartbeat:Connect(function()
        local now = tick()
        if now - lastCheck < 0.04 then return end
        lastCheck = now
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Head") then
            local head = char.Head
            if head:FindFirstChild("PartOwner") and isHeldValue.Value then
                AntiFeature.startStruggleLoop()
            end
        end
    end)
end

function AntiFeature.disableAntiGrabSolaris()
    if State.connections.antiGrab then
        State.connections.antiGrab:Disconnect()
        State.connections.antiGrab = nil
    end
    for k in pairs(State.struggleTasks) do
        State.struggleTasks[k] = nil
    end
end

function AntiFeature.setupAntiExplosion(character)
    local humanoid = character:WaitForChild("Humanoid", 5)
    local hrp = character:WaitForChild("HumanoidRootPart", 5)
    if not humanoid or not hrp then return end
    if antiExplosionConnection then
        antiExplosionConnection:Disconnect()
    end
    antiExplosionConnection = Workspace.ChildAdded:Connect(function(model)
        if not Settings.Anti.AntiExplosion then return end
        local char = LocalPlayer.Character
        local h = char and char:FindFirstChild("Humanoid")
        local r = char and char:FindFirstChild("HumanoidRootPart")
        if not h or not r then return end
        if model:IsA("BasePart") and (model.Position - r.Position).Magnitude <= 20 then
            if h.SeatPart ~= nil then
                r.Anchored = true
                task.wait(0.03)
                r.AssemblyLinearVelocity = Vector3.zero
                r.AssemblyAngularVelocity = Vector3.zero
                r.Anchored = false
            else
                r.Anchored = true
                task.wait()
                h:ChangeState(Enum.HumanoidStateType.Running)
                r.Anchored = false
                h.AutoRotate = true
                for _, limb in ipairs(char:GetDescendants()) do
                    if limb:IsA("BasePart") and limb.Name == "RagdollLimbPart" then
                        limb.CanCollide = false
                    end
                end
            end
        end
    end)
end

function AntiFeature.createKunaiMessageGui()
    if kunaiMessageGui then return end
    kunaiMessageGui = Instance.new("ScreenGui")
    kunaiMessageGui.Name = "KunaiMessageGui"
    kunaiMessageGui.ResetOnSpawn = false
    kunaiMessageGui.Parent = PlayerGui
    kunaiTextLabel = Instance.new("TextLabel")
    kunaiTextLabel.Size = UDim2.new(0, 480, 0, 38)
    kunaiTextLabel.Position = UDim2.new(0, 16, 1, -60)
    kunaiTextLabel.AnchorPoint = Vector2.new(0, 1)
    kunaiTextLabel.BackgroundTransparency = 1
    kunaiTextLabel.TextColor3 = Color3.fromRGB(255, 240, 120)
    kunaiTextLabel.Font = Enum.Font.Code
    kunaiTextLabel.TextSize = 18
    kunaiTextLabel.TextXAlignment = Enum.TextXAlignment.Left
    kunaiTextLabel.TextTransparency = 1
    kunaiTextLabel.RichText = true
    kunaiTextLabel.Parent = kunaiMessageGui
end

local fadeInInfo = TweenInfo.new(0.3, Enum.EasingStyle.Linear)
local fadeOutInfo = TweenInfo.new(0.6, Enum.EasingStyle.Linear)

function AntiFeature.typeKunaiMessage(msg, charDelay)
    charDelay = charDelay or 0.038
    if not kunaiTextLabel then AntiFeature.createKunaiMessageGui() end
    kunaiTextLabel.Text = ""
    TweenService:Create(kunaiTextLabel, fadeInInfo, {TextTransparency = 0}):Play()
    task.spawn(function()
        for i = 1, #msg do
            kunaiTextLabel.Text = msg:sub(1, i)
            task.wait(charDelay)
        end
        task.wait(2.5)
        TweenService:Create(kunaiTextLabel, fadeOutInfo, {TextTransparency = 1}):Play()
    end)
end

function AntiFeature.getRightLeg(char)
    return char:FindFirstChild("Right Leg")
        or char:FindFirstChild("RightFoot")
        or char:FindFirstChild("RightLowerLeg")
        or char:FindFirstChild("RightUpperLeg")
end

function AntiFeature.cleanupMyKunaiToys()
    if not spawnedInToysFolder then return end
    for _, toy in ipairs(spawnedInToysFolder:GetChildren()) do
        if toy.Name == "NinjaKunai" or toy.Name == "NinjaShuriken" or toy.Name == "AntiKick" then
            pcall(function()
                DeleteToyRE:FireServer(toy)
            end)
        end
    end
end

function AntiFeature.attachKunai(isReattach)
    if State.kunaiAttaching then return end
    State.kunaiAttaching = true
    if State.currentKunai and State.currentKunai.Parent then
        pcall(function() DeleteToyRE:FireServer(State.currentKunai) end)
        State.currentKunai = nil
    end
    task.wait(0.15)
    local char = Utility.GetPlayerCharacter()
    if not char then State.kunaiAttaching = false return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then State.kunaiAttaching = false return end
    local rightLeg = AntiFeature.getRightLeg(char)
    if not rightLeg then State.kunaiAttaching = false return end
    local spawnCFrame = hrp.CFrame * CFrame.new(0, 0, 10)
    task.spawn(function()
        pcall(function()
            SpawnToyRF:InvokeServer("NinjaKunai", spawnCFrame, Vector3.new(0, 0, 0))
        end)
    end)
    local kunai = nil
    for i = 1, 20 do
        task.wait(0.1)
        kunai = spawnedInToysFolder and spawnedInToysFolder:FindFirstChild("NinjaKunai")
        if kunai and kunai:FindFirstChild("StickyPart") then break end
        kunai = nil
    end
    if not kunai or not kunai:FindFirstChild("StickyPart") then
        State.kunaiAttaching = false
        return
    end
    local sticky = kunai.StickyPart
    for i = 1, 5 do
        task.spawn(function()
            pcall(function()
                local randOffset = CFrame.new(
                    math.random(-10,10)/100, math.random(-10,10)/100, math.random(-8,8)/100
                )
                setNetworkOwnerEvent:FireServer(sticky, rightLeg.CFrame * randOffset)
            end)
        end)
        if i < 5 then task.wait(0.05) end
    end
    local attachCFrame = CFrame.new(0.0490287527, 0.5, 0, 0, 0.00739139877, -0.999561906, -0.998452604, -0.0478846952, 0.0282763243, -0.0476547107, 0.99882561, 0)
    for i = 1, 5 do
        task.spawn(function()
            pcall(function()
                StickyPartEvent:FireServer(sticky, rightLeg, attachCFrame)
            end)
        end)
        if i < 5 then task.wait(0.05) end
    end
    task.spawn(function()
        for _, v in kunai:GetDescendants() do
            if v:IsA("BasePart") then
                v.CanTouch = false
                v.CanCollide = false
                v.CanQuery = false
            end
        end
    end)
    State.currentKunai = kunai
    State.kunaiAttaching = false
end

function AntiFeature.isKunaiAttached()
    if not Settings.Anti.AntiKickKunai then return false end
    if not spawnedInToysFolder then return false end
    local kunai = nil
    for _, obj in spawnedInToysFolder:GetChildren() do
        if obj.Name == "NinjaKunai" then kunai = obj break end
    end
    if not kunai or not kunai:FindFirstChild("StickyPart") then return false end
    local leg = AntiFeature.getRightLeg(Utility.GetPlayerCharacter())
    if not leg then return false end
    local sticky = kunai.StickyPart
    local weld = sticky:FindFirstChild("StickyWeld")
    if weld and weld.Part1 == leg then return true end
    local dist = (sticky.Position - leg.Position).Magnitude
    return dist < 7
end

function AntiFeature.setTouchQuery(state)
    local char = Workspace:FindFirstChild(LocalPlayer.Name)
    if not char then return end
    for _, v in ipairs(char:GetChildren()) do
        if v:IsA("Part") or v:IsA("BasePart") then
            v.CanTouch = state
            v.CanQuery = state
        end
    end
end

function AntiFeature.deleteAllPaintParts()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name == "PaintPlayerPart" then
            local clone = obj:Clone()
            clone.Archivable = true
            State.paintPartsBackup[obj:GetDebugId()] = { clone = clone, parent = obj.Parent }
            obj:Destroy()
        end
    end
end

function AntiFeature.restorePaintParts()
    for _, data in pairs(State.paintPartsBackup) do
        if data.clone and data.parent then
            data.clone.Parent = data.parent
        end
    end
    State.paintPartsBackup = {}
end

function AntiFeature.watchNewPaintParts()
    table.insert(State.paintConnections, Workspace.DescendantAdded:Connect(function(obj)
        if obj:IsA("BasePart") and obj.Name == "PaintPlayerPart" then
            task.defer(function()
                if obj and obj.Parent then
                    local clone = obj:Clone()
                    clone.Archivable = true
                    State.paintPartsBackup[obj:GetDebugId()] = { clone = clone, parent = obj.Parent }
                    obj:Destroy()
                end
            end)
        end
    end))
end

function AntiFeature.disconnectWatchers()
    for _, conn in ipairs(State.paintConnections) do
        if conn.Connected then conn:Disconnect() end
    end
    State.paintConnections = {}
end

function AntiFeature.spawnBlobmanForGucci()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local pos = hrp and hrp.CFrame or CFrame.new(0, 50, 0)
    pcall(function()
        SpawnToyRF:InvokeServer("CreatureBlobman", pos, Vector3.new(0, 0, 0))
    end)
end

function AntiFeature.startAntiGucci()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    local rootPart = character:WaitForChild("HumanoidRootPart")
    State.antiGucci.safePosition = rootPart.CFrame

    local function ensureBlobman()
        local inv = Workspace:FindFirstChild(LocalPlayer.Name .. "SpawnedInToys")
        local blob = inv and inv:FindFirstChild("CreatureBlobman")
        if not blob or not blob.Parent then
            AntiFeature.spawnBlobmanForGucci()
            task.wait(1)
            inv = Workspace:FindFirstChild(LocalPlayer.Name .. "SpawnedInToys")
            blob = inv and inv:FindFirstChild("CreatureBlobman")
        end
        return blob
    end

    local blob = ensureBlobman()
    if not blob then return end

    local seat = blob:FindFirstChildWhichIsA("VehicleSeat", true)
    if not seat then return end

    rootPart.CFrame = seat.CFrame + Vector3.new(0, 2, 0)
    task.wait()

    local GE = ReplicatedStorage:FindFirstChild("GrabEvents")
    local createGrab = GE and GE:FindFirstChild("CreateGrabLine")
    local setOwner = GE and GE:FindFirstChild("SetNetworkOwner")
    local destroyGrab = GE and GE:FindFirstChild("DestroyGrabLine")

    local gucciRunning = true

    seat:Sit(humanoid)

    local grabThread = task.spawn(function()
        local gucciFrame = 0
        while gucciRunning do
            for _, part in ipairs(blob:GetDescendants()) do
                if part:IsA("BasePart") then
                    if gucciFrame % 3 == 0 then
                        pcall(function() setOwner:FireServer(part, rootPart.CFrame) end)
                    elseif gucciFrame % 3 == 1 then
                        pcall(function() createGrab:FireServer(part, Vector3.zero, part.Position, false) end)
                    else
                        pcall(function() destroyGrab:FireServer(part) end)
                    end
                end
            end
            gucciFrame = gucciFrame + 1
            task.wait(0.035)
        end
    end)

    local start = tick()
    while tick() - start < 0.5 and Settings.Anti.AntiGucciBlobman do
        pcall(function()
            ragdollRemoteEvent:FireServer(rootPart, 0)
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end)
        RunService.Heartbeat:Wait()
    end

    gucciRunning = false

    local primary = blob.PrimaryPart or blob:FindFirstChildWhichIsA("BasePart", true)
    if primary then
        pcall(function()
            setNetworkOwnerEvent:FireServer(primary, rootPart.CFrame)
        end)
        pcall(function()
            sethiddenproperty(primary, "NetworkIsSleeping", false)
        end)
    end

    pcall(function() seat:Destroy() end)
    task.wait(0.1)
    if humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        humanoid.Sit = false
    end
    task.wait(0.05)
    rootPart.CFrame = State.antiGucci.safePosition

    pcall(function()
        if blob:FindFirstChild("Head") then
            blob.Head.CFrame = CFrame.new(0, 50000, 0)
            blob.Head.Anchored = true
        end
    end)
end

function AntiFeature.stopAntiGucci()
    Settings.Anti.AntiGucciBlobman = false
    if State.antiGucci.connection then
        State.antiGucci.connection:Disconnect()
        State.antiGucci.connection = nil
    end
    local character = LocalPlayer.Character
    if character then
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if rootPart and State.antiGucci.safePosition then
            rootPart.CFrame = State.antiGucci.safePosition
        end
        if humanoid then humanoid.Sit = false end
    end
    task.wait(0.1)
    local blobFolder = Workspace:FindFirstChild(LocalPlayer.Name .. "SpawnedInToys")
    if blobFolder and blobFolder:FindFirstChild("CreatureBlobman") then
        pcall(function()
            DeleteToyRE:FireServer(blobFolder.CreatureBlobman)
        end)
    end
end

function AntiFeature.startAntiGucciTrain()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    local rootPart = character:WaitForChild("HumanoidRootPart")
    State.antiGucci.safePositionTrain = rootPart.CFrame
    State.antiGucci.hasSatThisLife = false
    State.antiGucci.sitTimerTrain = nil

    local function returnToOriginal()
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hrp and State.antiGucci.safePositionTrain then
            if hum then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
                hum.Sit = false
            end
            task.wait(0.05)
            hrp.CFrame = State.antiGucci.safePositionTrain
        end
    end

    local function onSitSuccess()
        if State.antiGucci.hasSatThisLife then return end
        State.antiGucci.hasSatThisLife = true
        if State.antiGucci.sitTimerTrain then State.antiGucci.sitTimerTrain:Cancel() end
        State.antiGucci.sitTimerTrain = task.delay(0.1, function()
            State.antiGucci.sitTimerTrain = nil
        end)
    end

    local function sitAndJumpWarp(seat)
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum or not seat then return end

        State.antiGucci.safePositionTrain = hrp.CFrame
        hrp.CFrame = seat.CFrame + Vector3.new(0, 0.5, 0)

        local success = pcall(function()
            seat:Sit(hum)
        end)

        if success then
            task.wait(0.1)
            returnToOriginal()
        else
            returnToOriginal()
        end
    end

    local function getTrainSeat()
        local success, seat = pcall(function()
            return Workspace.Map.AlwaysHereTweenedObjects.Train.Object.ObjectModel:FindFirstChildWhichIsA("Seat")
        end)
        if success then return seat end
        return nil
    end

    if State.antiGucci.connectionTrain then State.antiGucci.connectionTrain:Disconnect() end
    local lastRagdollFire = 0
    State.antiGucci.connectionTrain = RunService.Heartbeat:Connect(function()
        if not Settings.Anti.AntiGucciTrain then return end
        local now = tick()
        if now - lastRagdollFire < 0.033 then return end
        lastRagdollFire = now
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            ragdollRemoteEvent:FireServer(hrp, 0)
        end
    end)

    if State.antiGucci.trainCharConn then State.antiGucci.trainCharConn:Disconnect() end
    State.antiGucci.trainCharConn = LocalPlayer.CharacterAdded:Connect(function()
        task.wait(0.5)
        State.antiGucci.hasSatThisLife = false
        State.antiGucci.sitTimerTrain = nil
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            State.antiGucci.safePositionTrain = hrp.CFrame
        end
    end)

    State.antiGucci.trainGucciLoop = true
    State.antiGucci.trainGucciThread = task.spawn(function()
        while State.antiGucci.trainGucciLoop do
            pcall(function()
                if Settings.Anti.AntiGucciTrain then
                    local shouldTry = (not State.antiGucci.hasSatThisLife or (State.antiGucci.sitTimerTrain and State.antiGucci.hasSatThisLife))
                    if shouldTry then
                        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                        if hum and not hum.Sit then
                            if getTrainSeat and sitAndJumpWarp and onSitSuccess then
                                local seat = getTrainSeat()
                                if seat then
                                    sitAndJumpWarp(seat)
                                    onSitSuccess()
                                end
                            end
                        end
                    end
                end
            end)
            task.wait(0.016)
        end
    end)
end

function AntiFeature.stopAntiGucciTrain()
    Settings.Anti.AntiGucciTrain = false
    State.antiGucci.trainGucciLoop = false
    State.antiGucci.hasSatThisLife = false
    if State.antiGucci.sitTimerTrain then
        State.antiGucci.sitTimerTrain:Cancel()
        State.antiGucci.sitTimerTrain = nil
    end
    if State.antiGucci.trainGucciThread then
        task.cancel(State.antiGucci.trainGucciThread)
        State.antiGucci.trainGucciThread = nil
    end
    if State.antiGucci.connectionTrain then
        State.antiGucci.connectionTrain:Disconnect()
        State.antiGucci.connectionTrain = nil
    end
    if State.antiGucci.trainCharConn then
        State.antiGucci.trainCharConn:Disconnect()
        State.antiGucci.trainCharConn = nil
    end
    local character = LocalPlayer.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then humanoid.Sit = false end
    end
end

function AntiFeature.ragdoll()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        ragdollRemoteEvent:FireServer(hrp, 0)
    end
end

function AntiFeature.startAntiBlobmanKill()
    if State.antiBlobmanKillConn then State.antiBlobmanKillConn:Disconnect() end
    local lastUpdate = 0
    State.antiBlobmanKillConn = RunService.Heartbeat:Connect(function()
        if not Settings.Anti.AntiBlobmanKill then return end
        local now = tick()
        if now - lastUpdate < 0.033 then return end
        lastUpdate = now
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChild("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hum or not hrp or hum.Health <= 0 then return end
        hum.Sit = true
        hum:ChangeState(Enum.HumanoidStateType.Running)
        local camera = workspace.CurrentCamera
        if camera then
            local lookVec = camera.CFrame.LookVector
            hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + Vector3.new(lookVec.X, 0, lookVec.Z))
        end
    end)
end

function AntiFeature.stopAntiBlobmanKill()
    Settings.Anti.AntiBlobmanKill = false
    if State.antiBlobmanKillConn then
        State.antiBlobmanKillConn:Disconnect()
        State.antiBlobmanKillConn = nil
    end
end

function AntiFeature.startFightBack()
    if State.fightBackConn then State.fightBackConn:Disconnect() end
    State.fightBackConn = task.spawn(function()
        while Settings.Anti.FightBack do
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Head") then
                local head = char.Head
                local partOwner = head:FindFirstChild("PartOwner")
                if partOwner and partOwner.Value ~= "" then
                    local attacker = Players:FindFirstChild(partOwner.Value)
                    if attacker and attacker.Character then
                        pcall(function()
                            struggleEvent:FireServer()
                            local attackerChar = attacker.Character
                            local targetPart = attackerChar:FindFirstChild("Torso") or attackerChar:FindFirstChild("UpperTorso") or attackerChar:FindFirstChild("Head")
                            if targetPart then
                                setNetworkOwnerEvent:FireServer(targetPart, targetPart.CFrame)
                                task.wait()
                                local existingVel = targetPart:FindFirstChild("l")
                                if not existingVel then
                                    local velocity = Instance.new("BodyVelocity")
                                    velocity.Name = "l"
                                    velocity.Velocity = Vector3.new(0, 2000, 0)
                                    velocity.MaxForce = Vector3.new(0, math.huge, 0)
                                    velocity.Parent = targetPart
                                    Debris:AddItem(velocity, 0.5)
                                end
                            end
                        end)
                    end
                end
            end
            task.wait(0.1)
        end
    end)
end

function AntiFeature.stopFightBack()
    Settings.Anti.FightBack = false
    State.fightBackConn = nil
end

function AntiFeature.startHouseTpAntiGrab()
    if State.houseTpConn then return end
    local housePositions = {
        Vector3.new(295.6128234863281, -7.405966758728027, 486.5804138183594),
        Vector3.new(-575.0462036132812, -9.292041778564453, 87.85179901123047),
        Vector3.new(-526.5169677734375, -9.296868324279785, -165.31671142578125),
        Vector3.new(524.0487670898438, 80.51884460449219, -366.8386535644531),
        Vector3.new(577.5789184570312, 121.39737701416016, -93.60242462158203),
    }

    local function doHouseTp()
        if not Settings.Anti.HouseTpAntiGrab then return end
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum or hum.Health <= 0 then return end
        local pos = housePositions[math.random(1, #housePositions)]
        hrp.CFrame = CFrame.new(pos)
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
    end

    State.houseTpConn = {}
    local lastHouseTp = 0
    State.houseTpConn.heartbeat = RunService.Heartbeat:Connect(function()
        if not Settings.Anti.HouseTpAntiGrab then return end
        local now = tick()
        if now - lastHouseTp < 0.04 then return end
        lastHouseTp = now
        doHouseTp()
    end)
    State.houseTpConn.respawn = LocalPlayer.CharacterAdded:Connect(function()
        if not Settings.Anti.HouseTpAntiGrab then return end
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then
            hrp = char and char:WaitForChild("HumanoidRootPart", 2)
        end
        if hrp then
            local pos = housePositions[math.random(1, #housePositions)]
            hrp.CFrame = CFrame.new(pos)
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
        end
    end)
end

function AntiFeature.stopHouseTpAntiGrab()
    if State.houseTpConn then
        if State.houseTpConn.heartbeat then State.houseTpConn.heartbeat:Disconnect() end
        if State.houseTpConn.respawn then State.houseTpConn.respawn:Disconnect() end
        State.houseTpConn = nil
    end
end




local BlobmanBetaFeature = {}

function BlobmanBetaFeature.getLocalChar() return LocalPlayer.Character end
function BlobmanBetaFeature.getLocalRoot()
    local c = BlobmanBetaFeature.getLocalChar()
    if not c then return end
    return c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("Torso")
end
function BlobmanBetaFeature.getLocalHum()
    local c = BlobmanBetaFeature.getLocalChar()
    if not c then return end
    return c:FindFirstChildOfClass("Humanoid")
end
function BlobmanBetaFeature.getInv()
    return Workspace:FindFirstChild(LocalPlayer.Name .. "SpawnedInToys")
end
function BlobmanBetaFeature.getCurrentPlot()
    local myRoot = BlobmanBetaFeature.getLocalRoot()
    if not myRoot then return nil end
    local plots = Workspace:FindFirstChild("PlotItems")
    if not plots then return nil end
    for i = 1, 5 do
        local plot = plots:FindFirstChild("Plot" .. i)
        if plot then
            local pp = plot:FindFirstChildWhichIsA("Part") or plot:FindFirstChild("Baseplate")
            if not pp then
                for _, v in ipairs(plot:GetChildren()) do
                    if v:IsA("BasePart") then pp = v break end
                end
            end
            if pp then
                local dist = (myRoot.Position - pp.Position).Magnitude
                if dist < 100 then return plot end
            end
        end
    end
    return nil
end
function BlobmanBetaFeature.SetNetworkOwner(part)
    pcall(function() setNetworkOwnerEvent:FireServer(part, BlobmanBetaFeature.getLocalRoot().CFrame) end)
end
function BlobmanBetaFeature.ungrab(part)
    pcall(function() destroyGrabLineEvent:FireServer(part) end)
end
function BlobmanBetaFeature.getBlobman()
    local hum = BlobmanBetaFeature.getLocalHum()
    if hum and hum.Sit and hum.SeatPart and hum.SeatPart.Parent then
        if hum.SeatPart.Parent.Name == "CreatureBlobman" then
            return hum.SeatPart.Parent
        end
    end
    local inv = BlobmanBetaFeature.getInv()
    if inv then
        local v = inv:FindFirstChild("CreatureBlobman")
        if v and v.ClassName == "Model" and v:FindFirstChild("VehicleSeat") then return v end
    end
    return nil
end

function BlobmanBetaFeature.findAnyBlobman()
    if not Settings.BlobmanBeta.unsafeBlobman then return nil end
    local myRoot = BlobmanBetaFeature.getLocalRoot()
    local closest, closestDist = nil, math.huge
    local function checkFolder(folder)
        if not folder then return end
        for _, obj in ipairs(folder:GetChildren()) do
            if obj.Name == "CreatureBlobman" and obj:IsA("Model") then
                local seat = obj:FindFirstChild("VehicleSeat")
                if seat then
                    local dist = myRoot and (obj:GetPivot().Position - myRoot.Position).Magnitude or 0
                    if dist < closestDist then
                        closestDist = dist
                        closest = obj
                    end
                end
            end
        end
    end
    checkFolder(BlobmanBetaFeature.getInv())
    if not closest then
        for _, obj in ipairs(Workspace:GetChildren()) do
            if obj.Name == "CreatureBlobman" and obj:IsA("Model") then
                local seat = obj:FindFirstChild("VehicleSeat")
                if seat then
                    local dist = myRoot and (obj:GetPivot().Position - myRoot.Position).Magnitude or 0
                    if dist < 100000 and dist < closestDist then
                        closestDist = dist
                        closest = obj
                    end
                end
            end
        end
    end
    if not closest then
        local plotItems = Workspace:FindFirstChild("PlotItems")
        if plotItems then
            for _, plot in ipairs(plotItems:GetChildren()) do
                checkFolder(plot)
            end
        end
    end
    if not closest then
        local plots = Workspace:FindFirstChild("Plots")
        if plots then
            for _, plot in ipairs(plots:GetChildren()) do
                checkFolder(plot)
            end
        end
    end
    return closest
end
function BlobmanBetaFeature.spawnBlobman()
    local myRoot = BlobmanBetaFeature.getLocalRoot()
    if not myRoot then
        local myChar = LocalPlayer.Character
        if myChar then myRoot = myChar:FindFirstChild("HumanoidRootPart") end
    end
    if not myRoot then return nil end
    local existing = BlobmanBetaFeature.getBlobman()
    if existing then return existing end
    local anyBlob = BlobmanBetaFeature.findAnyBlobman()
    if anyBlob and anyBlob:FindFirstChild("VehicleSeat") then
        return anyBlob
    end
    local inv = BlobmanBetaFeature.getInv()
    local SpawnedToy = nil
    if inv then
        local conn
        conn = inv.ChildAdded:Connect(function(toy)
            if toy.Name == "CreatureBlobman" and toy:IsA("Model") then
                SpawnedToy = toy
                conn:Disconnect()
            end
        end)
        task.spawn(function()
            pcall(function()
                SpawnToyRF:InvokeServer("CreatureBlobman", myRoot.CFrame * CFrame.new(3, 0, 0), Vector3.zero)
            end)
        end)
        local t = tick()
        while not SpawnedToy do
            if tick() - t > 2 then
                conn:Disconnect()
                break
            end
            task.wait(0.01)
        end
    end
    if SpawnedToy then
        if not SpawnedToy:FindFirstChild("VehicleSeat") then
            SpawnedToy:WaitForChild("VehicleSeat", 2)
        end
        return SpawnedToy
    end
    return BlobmanBetaFeature.getBlobman()
end
function BlobmanBetaFeature.destroyBlobman()
    local blob = BlobmanBetaFeature.getBlobman()
    if blob then pcall(function() DeleteToyRE:FireServer(blob) end) end
end
function BlobmanBetaFeature.resetBlobmanPhysics()
    local blob = BlobmanBetaFeature.getBlobman()
    if not blob then return end
    for _, part in blob:GetDescendants() do
        if part:IsA("BasePart") then
            part.AssemblyLinearVelocity = Vector3.zero
            part.AssemblyAngularVelocity = Vector3.zero
        end
    end
end
function BlobmanBetaFeature.stabilizeBlobman()
    local blob = BlobmanBetaFeature.getBlobman()
    if not blob or not blob:FindFirstChild("VehicleSeat") then return end
    local seat = blob.VehicleSeat
    if seat then
        seat.CFrame = seat.CFrame + (BlobmanBetaFeature.getLocalRoot().CFrame.Position - seat.Position) * 0.1
    end
end
function BlobmanBetaFeature.isSittingOnBlobman()
    local hum = BlobmanBetaFeature.getLocalHum()
    return hum and hum.Sit and hum.SeatPart and hum.SeatPart.Parent and hum.SeatPart.Parent.Name == "CreatureBlobman"
end

function BlobmanBetaFeature.ensureSeatedOnBlobman()
    if BlobmanBetaFeature.isSittingOnBlobman() then return true end
    return BlobmanBetaFeature.forceSitBlobman()
end
function BlobmanBetaFeature.ensureSitBlobman()
    local blob = BlobmanBetaFeature.getBlobman()
    if not blob or not blob:FindFirstChild("VehicleSeat") then
        blob = BlobmanBetaFeature.spawnBlobman()
    end
    if not blob or not blob:FindFirstChild("VehicleSeat") then
        blob = BlobmanBetaFeature.findAnyBlobman()
    end
    if not blob or not blob:FindFirstChild("VehicleSeat") then return false end
    local seat = blob.VehicleSeat
    local hum = BlobmanBetaFeature.getLocalHum()
    local myRoot = BlobmanBetaFeature.getLocalRoot()
    if hum and not hum.Sit and myRoot then
        myRoot.CFrame = seat.CFrame + Vector3.new(0, 2, 0)
        task.wait(0.05)
        seat:Sit(hum)
        task.wait(0.1)
    end
    BlobmanBetaFeature.resetBlobmanPhysics()
    BlobmanBetaFeature.stabilizeBlobman()
    return BlobmanBetaFeature.isSittingOnBlobman()
end
function BlobmanBetaFeature.blobGrab(blob, target, side)
    if not blob then return end
    local detector = blob:FindFirstChild(side .. "Detector")
    if not detector then return end
    local weld = detector:FindFirstChild(side .. "Weld")
    if not weld then return end
    local script = blob:FindFirstChild("BlobmanSeatAndOwnerScript", true)
    if not script then return end
    local remote = script:FindFirstChild("CreatureGrab")
    if remote then pcall(function() remote:FireServer(detector, target, weld) end) end
end
function BlobmanBetaFeature.blobDrop(blob, target, side)
    if not blob then return end
    local detector = blob:FindFirstChild(side .. "Detector")
    if not detector then return end
    local script = blob:FindFirstChild("BlobmanSeatAndOwnerScript", true)
    if not script then return end
    local remote = script:FindFirstChild("CreatureDrop")
    if remote then pcall(function() remote:FireServer(detector, target) end) end
end
function BlobmanBetaFeature.blobKick(blob, target, side)
    if not blob or not target then return end
    BlobmanBetaFeature.blobGrab(blob, BlobmanBetaFeature.getLocalRoot(), side)
    task.wait(0.02)
    BlobmanBetaFeature.SetNetworkOwner(target)
    task.wait(0.02)
    target.CFrame = target.CFrame + Vector3.new(0, Settings.BlobmanBeta.FloatAmount, 0)
    task.wait(0.02)
    BlobmanBetaFeature.ungrab(target)
    task.wait(0.02)
    BlobmanBetaFeature.blobGrab(blob, target, side)
    task.wait(0.02)
    BlobmanBetaFeature.blobDrop(blob, target, side)
    task.wait(0.02)
    BlobmanBetaFeature.ungrab(target)
end
function BlobmanBetaFeature.ensureBlob()
    local blob = BlobmanBetaFeature.getBlobman()
    if not blob then blob = BlobmanBetaFeature.findAnyBlobman() end
    if not blob then blob = BlobmanBetaFeature.spawnBlobman() end
    if not blob or not blob:FindFirstChild("VehicleSeat") then return nil end
    local hum = BlobmanBetaFeature.getLocalHum()
    local myRoot = BlobmanBetaFeature.getLocalRoot()
    if hum and myRoot and not hum.Sit then
        myRoot.CFrame = blob.VehicleSeat.CFrame + Vector3.new(0, 2, 0)
        blob.VehicleSeat:Sit(hum)
    end
    return BlobmanBetaFeature.getBlobman()
end

function BlobmanBetaFeature.getPCLDPosition(targetPlayer, referencePos)
    if not State.allPCLDParts then
        State.allPCLDParts = {}
        for _, part in ipairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") and part.Name == "PlayerCharacterLocationDetector" then
                local p = part.Position
                if not (p.X == 0 and p.Y == 0 and p.Z == 0) then
                    table.insert(State.allPCLDParts, part)
                end
            end
        end
        if not State.pcldWatcherConn then
            State.pcldWatcherConn = workspace.DescendantAdded:Connect(function(part)
                if part:IsA("BasePart") and part.Name == "PlayerCharacterLocationDetector" then
                    local p = part.Position
                    if not (p.X == 0 and p.Y == 0 and p.Z == 0) then
                        table.insert(State.allPCLDParts, part)
                    end
                end
            end)
        end
    end
    for i = #State.allPCLDParts, 1, -1 do
        if not State.allPCLDParts[i].Parent then
            table.remove(State.allPCLDParts, i)
        end
    end
    local ref = referencePos
    if not ref then
        local char = targetPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then ref = hrp.Position end
    end
    if not ref then return nil end
    local closest = nil
    local closestDist = 50
    for _, pcld in ipairs(State.allPCLDParts) do
        if pcld.Parent then
            local dist = (pcld.Position - ref).Magnitude
            if dist < closestDist then
                closestDist = dist
                closest = pcld
            end
        end
    end
    return closest
end

function BlobmanBetaFeature.forceSitBlobman()
    local blob = BlobmanBetaFeature.getBlobman()
    if not blob or not blob:FindFirstChild("VehicleSeat") then
        blob = BlobmanBetaFeature.findAnyBlobman()
    end
    if not blob or not blob:FindFirstChild("VehicleSeat") then
        blob = BlobmanBetaFeature.spawnBlobman()
    end
    if not blob or not blob:FindFirstChild("VehicleSeat") then return false end
    local seat = blob.VehicleSeat
    local myHum = BlobmanBetaFeature.getLocalHum()
    local myRoot = BlobmanBetaFeature.getLocalRoot()
    if not myHum or not myRoot then
        local myChar = LocalPlayer.Character
        if myChar then
            myHum = myHum or myChar:FindFirstChildOfClass("Humanoid")
            myRoot = myRoot or myChar:FindFirstChild("HumanoidRootPart")
        end
    end
    if not myHum or not myRoot then return false end
    if myHum.Sit and myHum.SeatPart == seat then return true end
    if seat.Occupant and seat.Occupant ~= myHum then
        pcall(function() seat.Occupant.Jump = true end)
        task.wait(0.15)
    end
    myRoot.Velocity = Vector3.zero
    myRoot.RotVelocity = Vector3.zero
    myRoot.CFrame = seat.CFrame + Vector3.new(0, 2, 0)
    pcall(function() seat:Sit(myHum) end)
    task.wait(0.05)
    if myHum.Sit and myHum.SeatPart == seat then
        BlobmanBetaFeature.resetBlobmanPhysics()
        return true
    end
    return BlobmanBetaFeature.isSittingOnBlobman()
end
function BlobmanBetaFeature.GetPlayerList()
    local list = {}
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and not isProtectedPlayer(plr.Name) then
            table.insert(list, plr.DisplayName .. " @" .. plr.Name)
        end
    end
    return list
end
function BlobmanBetaFeature.checkTarget()
    if not Settings.BlobmanBeta.selectedTarget then warn("Select target") return nil end
    if isProtectedPlayer(Settings.BlobmanBeta.selectedTarget) then warn("Player is protected") return nil end
    local target = Players:FindFirstChild(Settings.BlobmanBeta.selectedTarget)
    if not target then warn("Target not found") return nil end
    return target
end
function BlobmanBetaFeature.isValidTarget(plr, myRoot)
    if plr == LocalPlayer then return false end
    if isProtectedPlayer(plr.Name) then return false end
    if Settings.BlobmanBeta.ignoreFriends or Settings.Loop.WhitelistFriends then
        local isFriend = false
        pcall(function() isFriend = plr:IsFriendsWith(LocalPlayer.UserId) end)
        if isFriend then return false end
    end
    local char = plr.Character
    if not char then return false end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return false end
    local playerY = root.Position.Y
    if playerY < -25 then return false end
    for _, h in ipairs(Settings.BlobmanBeta.ignoreHeights) do
        if math.abs(playerY - h) < 0.1 then return false end
    end
    return true
end

function BlobmanBetaFeature.destroyPlayerGucci(targetPlayer)
    if not targetPlayer or targetPlayer == LocalPlayer then return false end
    if isProtectedPlayer(targetPlayer.Name) then return false end
    local folderName = targetPlayer.Name .. "SpawnedInToys"
    local toysFolder = Workspace:FindFirstChild(folderName)
    if not toysFolder then return false end
    local myChar = LocalPlayer.Character
    if not myChar then return false end
    local myHum = myChar:FindFirstChild("Humanoid")
    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    if not myHum or not myRoot then return false end
    for _, obj in ipairs(toysFolder:GetChildren()) do
        if obj.Name == "CreatureBlobman" or obj.Name == "TractorGreen" then
            local seat = obj:FindFirstChild("VehicleSeat") or obj:FindFirstChildWhichIsA("VehicleSeat", true)
            if seat then
                local safeSpot = myRoot.CFrame
                myRoot.CFrame = seat.CFrame
                myRoot.Velocity = Vector3.zero
                seat:Sit(myHum)
                task.wait(0.3)
                if myHum.SeatPart == seat then
                    myHum.Sit = false
                    task.wait(0.1)
                    myRoot.CFrame = safeSpot
                    task.wait(1)
                    obj:Destroy()
                    return true
                else
                    myRoot.CFrame = safeSpot
                end
            end
        end
    end
    return false
end

function BlobmanBetaFeature.StartDestroyGucciLoop()
    while Settings.BlobmanBeta.destroyGucciActive do
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and not isProtectedPlayer(player.Name) and player.Character then
                BlobmanBetaFeature.destroyPlayerGucci(player)
            end
        end
        task.wait(2)
    end
end

function BlobmanBetaFeature.startDriftKick(targetName)
    driftAngle = 0
    local driftRadius = 19
    local driftSpeed = 12
    local driftHeightOffset = 0
    Settings.BlobmanBeta.driftKickActive = true
    local myLoopId = tick()
    State.driftKickLoopId = myLoopId
    local driftSkipCounter = 0

    if State.driftKickConn then task.cancel(State.driftKickConn) end
    State.driftKickConn = task.spawn(function()
        local target = Players:FindFirstChild(targetName)
        if not target or target == LocalPlayer then
            Settings.BlobmanBeta.driftKickActive = false
            return
        end

        local blob = BlobmanBetaFeature.getBlobman()
            or BlobmanBetaFeature.findAnyBlobman()
            or BlobmanBetaFeature.spawnBlobman()
        if not blob or not blob:FindFirstChild("VehicleSeat") then
            Settings.BlobmanBeta.driftKickActive = false
            return
        end

        local scriptObj = blob:FindFirstChild("BlobmanSeatAndOwnerScript") or blob:FindFirstChild("BlobmanSeatAndOwnerScript[old]")
        local grabRemote = scriptObj and scriptObj:FindFirstChild("CreatureGrab")
        local dropRemote = scriptObj and scriptObj:FindFirstChild("CreatureDrop")
        local lDet = blob:FindFirstChild("LeftDetector")
        local rDet = blob:FindFirstChild("RightDetector")
        local lWeld = lDet and (lDet:FindFirstChild("LeftWeld") or lDet:FindFirstChildWhichIsA("Weld") or lDet:FindFirstChildWhichIsA("JointInstance") or lDet:FindFirstChild("RigidConstraint"))
        local rWeld = rDet and (rDet:FindFirstChild("RightWeld") or rDet:FindFirstChildWhichIsA("Weld") or rDet:FindFirstChildWhichIsA("JointInstance") or rDet:FindFirstChild("RigidConstraint"))
        local seat = blob:FindFirstChild("VehicleSeat")
        local GE = ReplicatedStorage:FindFirstChild("GrabEvents")
        local blobRoot = blob:FindFirstChild("HumanoidRootPart") or blob.PrimaryPart
        local Det = rDet or lDet
        local Weld = rWeld or lWeld

        if not GE or not grabRemote or not dropRemote or not Det or not Weld or not blobRoot then
            Settings.BlobmanBeta.driftKickActive = false
            return
        end

        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
        local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if seat and hum then
            if seat.Occupant ~= hum then
                myHRP.CFrame = seat.CFrame + Vector3.new(0, 2, 0)
                task.wait(0.2)
                seat:Sit(hum)
                task.wait(0.5)
            end
        end

        while Settings.BlobmanBeta.driftKickActive do
            if myLoopId ~= State.driftKickLoopId then break end
            if not target or not target.Parent then break end

            local myChar = LocalPlayer.Character
            local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
            local mySeat = myHum and myHum.SeatPart
            if not mySeat or mySeat.Parent ~= blob then
                Settings.BlobmanBeta.driftKickActive = false
                break
            end

            local tChar = target.Character
            local tHum = tChar and tChar:FindFirstChildOfClass("Humanoid")
            local tRoot = tChar and tChar:FindFirstChild("HumanoidRootPart")

            if tChar and tRoot and tHum and tHum.Health > 0 then
                local bringStart = tick()
                while tick() - bringStart < 0.35 do
                    if myLoopId ~= State.driftKickLoopId or not Settings.BlobmanBeta.driftKickActive or not blob or not blob.Parent then break end
                    if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                        local currentTRoot = target.Character.HumanoidRootPart
                        blobRoot.CFrame = currentTRoot.CFrame
                        blobRoot.AssemblyLinearVelocity = Vector3.zero
                        pcall(function()
                            if Det then grabRemote:FireServer(Det, currentTRoot, Weld) end
                            if driftSkipCounter % 3 == 0 then
                                GE.SetNetworkOwner:FireServer(currentTRoot, blobRoot.CFrame)
                            elseif driftSkipCounter % 3 == 1 then
                                GE.CreateGrabLine:FireServer(currentTRoot, Vector3.zero, currentTRoot.Position, false)
                            end
                        end)
                    end
                    driftSkipCounter = (driftSkipCounter + 1) % 3
                    RunService.Heartbeat:Wait()
                end
                if myLoopId ~= State.driftKickLoopId or not Settings.BlobmanBeta.driftKickActive or not blob or not blob.Parent then break end
                tChar = target.Character
                tRoot = tChar and tChar:FindFirstChild("HumanoidRootPart")
                tHum = tChar and tChar:FindFirstChildOfClass("Humanoid")
                if tChar and tRoot and tHum and tHum.Health > 0 then
                    local SavedPos = tRoot.CFrame
                    local targetCenterCFrame = SavedPos + Vector3.new(0, 30, 0)
                    local lastTime = tick()
                    local lastDropTime = tick()
                    local dropCount = 0
                    while Settings.BlobmanBeta.driftKickActive and blob and blob.Parent do
                        if myLoopId ~= State.driftKickLoopId then break end
                        if not target or not target.Parent then break end
                        tChar = target.Character
                        tRoot = tChar and tChar:FindFirstChild("HumanoidRootPart")
                        tHum = tChar and tChar:FindFirstChildOfClass("Humanoid")
                        if not tChar or not tRoot or not tHum or tHum.Health <= 0 then break end
                        if dropCount < 2 and (tick() - lastDropTime) > 0.8 then
                            dropCount = dropCount + 1
                            pcall(function()
                                local currentWeld = Det:FindFirstChild("RightWeld") or Det:FindFirstChild("LeftWeld") or Det:FindFirstChildWhichIsA("Weld") or Det:FindFirstChildWhichIsA("JointInstance") or Det:FindFirstChild("RigidConstraint")
                                if currentWeld then dropRemote:FireServer(currentWeld) end
                                GE.DestroyGrabLine:FireServer(tRoot)
                            end)
                            blobRoot.CFrame = SavedPos
                            blobRoot.AssemblyLinearVelocity = Vector3.zero
                            driftSkipCounter = (driftSkipCounter + 1) % 3
                RunService.Heartbeat:Wait()
                skipFrame = (skipFrame + 1) % 3
                            if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                                local currentTRoot = target.Character.HumanoidRootPart
                                blobRoot.CFrame = currentTRoot.CFrame
                                blobRoot.AssemblyLinearVelocity = Vector3.zero
                                pcall(function()
                                    if Det then grabRemote:FireServer(Det, currentTRoot, Weld) end
                                    if driftSkipCounter % 3 == 0 then
                                        GE.SetNetworkOwner:FireServer(currentTRoot, blobRoot.CFrame)
                                    elseif driftSkipCounter % 3 == 1 then
                                        GE.CreateGrabLine:FireServer(currentTRoot, Vector3.zero, currentTRoot.Position, false)
                                    end
                                end)
                            end
                            lastTime = tick()
                            lastDropTime = tick()
                            continue
                        end
                        if tRoot and tHum and tHum.Health > 0 and blobRoot then
                            local currentTime = tick()
                            local dt = currentTime - lastTime
                            lastTime = currentTime
                            driftAngle = driftAngle + (driftSpeed * dt)
                            local offsetX = math.cos(driftAngle) * driftRadius
                            local offsetZ = math.sin(driftAngle) * driftRadius
                            local blobPos = targetCenterCFrame.Position + Vector3.new(offsetX, driftHeightOffset, offsetZ)
                            blobRoot.CFrame = CFrame.new(blobPos, targetCenterCFrame.Position)
                            blobRoot.AssemblyLinearVelocity = Vector3.zero
                            blobRoot.AssemblyAngularVelocity = Vector3.zero
                            tRoot.CFrame = targetCenterCFrame
                            tRoot.AssemblyLinearVelocity = Vector3.zero
                            tRoot.AssemblyAngularVelocity = Vector3.zero
                        pcall(function()
                            tHum.PlatformStand = true
                            tHum.Sit = true
                            if driftSkipCounter % 3 == 0 then
                                GE.SetNetworkOwner:FireServer(tRoot, targetCenterCFrame)
                            elseif driftSkipCounter % 3 == 1 then
                                GE.DestroyGrabLine:FireServer(tRoot)
                                GE.CreateGrabLine:FireServer(tRoot, Vector3.zero, targetCenterCFrame.Position, false)
                            end
                            local currentWeld = Det:FindFirstChild("RightWeld") or Det:FindFirstChild("LeftWeld") or Det:FindFirstChildWhichIsA("Weld") or Det:FindFirstChildWhichIsA("JointInstance") or Det:FindFirstChild("RigidConstraint")
                            if currentWeld then dropRemote:FireServer(currentWeld) end
                            if Det then grabRemote:FireServer(Det, tRoot, Weld) end
                        end)
                        else
                            break
                        end
                        driftSkipCounter = (driftSkipCounter + 1) % 3
                        RunService.Heartbeat:Wait()
                    end
                    if not Settings.BlobmanBeta.driftKickActive or myLoopId ~= State.driftKickLoopId then
                        if blobRoot and SavedPos then
                            pcall(function()
                                local currentWeld = Det:FindFirstChild("RightWeld") or Det:FindFirstChild("LeftWeld") or Det:FindFirstChildWhichIsA("Weld") or Det:FindFirstChildWhichIsA("JointInstance") or Det:FindFirstChild("RigidConstraint")
                                if currentWeld then dropRemote:FireServer(currentWeld) end
                                if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                                    GE.DestroyGrabLine:FireServer(target.Character.HumanoidRootPart)
                                end
                            end)
                            blobRoot.CFrame = SavedPos
                            blobRoot.AssemblyLinearVelocity = Vector3.zero
                        end
                        break
                    end
                end
            end
            driftSkipCounter = (driftSkipCounter + 1) % 3
            RunService.Heartbeat:Wait()
        end
        Settings.BlobmanBeta.driftKickActive = false
    end)
end

function BlobmanBetaFeature.stopDriftKick()
    Settings.BlobmanBeta.driftKickActive = false
    State.driftKickLoopId = tick()

    if State.driftKickConn then
        task.cancel(State.driftKickConn)
        State.driftKickConn = nil
    end

    local tName = Settings.BlobmanBeta.selectedTarget
    local blob = BlobmanBetaFeature.getBlobman()

    if blob then
        local scriptObj = blob:FindFirstChild("BlobmanSeatAndOwnerScript", true)
        local dropRemote = scriptObj and scriptObj:FindFirstChild("CreatureDrop")
        local GE = ReplicatedStorage:FindFirstChild("GrabEvents")
        local Det = blob:FindFirstChild("RightDetector") or blob:FindFirstChild("LeftDetector")
        local Weld = Det and (Det:FindFirstChild("RightWeld") or Det:FindFirstChild("LeftWeld") or Det:FindFirstChildWhichIsA("Weld") or Det:FindFirstChildWhichIsA("JointInstance") or Det:FindFirstChild("RigidConstraint"))
        if dropRemote and Weld then
            pcall(function() dropRemote:FireServer(Weld) end)
        end
        if GE then
            if tName then
                local tPlayer = Players:FindFirstChild(tName)
                local tChar = tPlayer and tPlayer.Character
                local tRoot = tChar and tChar:FindFirstChild("HumanoidRootPart")
                if tRoot then
                    pcall(function() GE.DestroyGrabLine:FireServer(tRoot) end)
                end
            end
            pcall(function() GE.DestroyGrabLine:FireServer(LocalPlayer.Character.HumanoidRootPart) end)
        end
        local blobRoot = blob:FindFirstChild("HumanoidRootPart") or blob.PrimaryPart
        if blobRoot then
            pcall(function()
                blobRoot.AssemblyLinearVelocity = Vector3.zero
                blobRoot.AssemblyAngularVelocity = Vector3.zero
            end)
        end
    end

    if tName then
        local tPlayer = Players:FindFirstChild(tName)
        local tChar = tPlayer and tPlayer.Character
        if tChar then
            local tHum = tChar:FindFirstChildOfClass("Humanoid")
            if tHum then
                pcall(function()
                    tHum.PlatformStand = false
                    tHum.Sit = false
                end)
            end
        end
    end

    local myChar = LocalPlayer.Character
    local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
    if myHum then
        pcall(function()
            myHum.PlatformStand = false
            myHum.Sit = false
        end)
    end
end

function BlobmanBetaFeature.startKickAllV2()
    Settings.BlobmanBeta.kickAllV2Active = true
    if State.kickAllV2Conn then task.cancel(State.kickAllV2Conn) end
    State.kickAllV2Conn = task.spawn(function()
        local allPlayers = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and not isProtectedPlayer(p.Name) then
                if Settings.BlobmanBeta.ignoreFriends then
                    local isFriend = false
                    pcall(function() isFriend = LocalPlayer:IsFriendsWith(p.UserId) end)
                    if isFriend then continue end
                end
                table.insert(allPlayers, p)
            end
        end
        if #allPlayers == 0 then Settings.BlobmanBeta.kickAllV2Active = false return end

        local myChar = LocalPlayer.Character
        local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
        local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
        if not myHRP or not myHum then Settings.BlobmanBeta.kickAllV2Active = false return end

        local currentBlob = BlobmanBetaFeature.getBlobman()
            or BlobmanBetaFeature.findAnyBlobman()
            or BlobmanBetaFeature.spawnBlobman()
        if not currentBlob or not currentBlob:FindFirstChild("VehicleSeat") then
            Settings.BlobmanBeta.kickAllV2Active = false return
        end

        local vehicleSeat = currentBlob.VehicleSeat
        if not myHum.Sit or myHum.SeatPart ~= vehicleSeat then
            if vehicleSeat.Occupant and vehicleSeat.Occupant ~= myHum then
                pcall(function() vehicleSeat.Occupant.Jump = true end)
                task.wait(0.1)
            end
            local sitStart = tick()
            while Settings.BlobmanBeta.kickAllV2Active and tick() - sitStart < 0.5 do
                if not currentBlob or not currentBlob.Parent then break end
                myHRP.CFrame = vehicleSeat.CFrame + Vector3.new(0, 2, 0)
                pcall(function() vehicleSeat:Sit(myHum) end)
                if myHum.Sit and myHum.SeatPart == vehicleSeat then break end
                task.wait(0.03)
            end
        end
            if not (myHum.Sit and myHum.SeatPart and myHum.SeatPart.Parent and myHum.SeatPart.Parent.Name == "CreatureBlobman") then
                Settings.BlobmanBeta.kickAllV2Active = false return
            end

            local MyBlob = myHum.SeatPart.Parent
            local scr = MyBlob:FindFirstChild("BlobmanSeatAndOwnerScript") or MyBlob:FindFirstChild("BlobmanSeatAndOwnerScript[old]")
            local CreatureGrab = scr and scr:FindFirstChild("CreatureGrab")
            local CreatureRelease = scr and scr:FindFirstChild("CreatureRelease")

            local allPlayers = {}
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and not isProtectedPlayer(p.Name) then
                    if Settings.BlobmanBeta.ignoreFriends then
                        local isFriend = false
                        pcall(function() isFriend = LocalPlayer:IsFriendsWith(p.UserId) end)
                        if isFriend then continue end
                    end
                    local tChar = p.Character
                    local tRoot = tChar and tChar:FindFirstChild("HumanoidRootPart")
                    local tHum = tChar and tChar:FindFirstChildOfClass("Humanoid")
                    if tRoot and tHum and tHum.Health > 0 then
                        table.insert(allPlayers, p)
                    end
                end
            end
            if #allPlayers == 0 then Settings.BlobmanBeta.kickAllV2Active = false return end

            for _, targetPlayer in ipairs(allPlayers) do
                local targetRoot = targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                if targetRoot then
                    myHRP.CFrame = targetRoot.CFrame
                    task.wait(0.02)
                    for i = 1, 3 do
                        pcall(function()
                            CreatureGrab:FireServer(MyBlob.LeftDetector, targetRoot, MyBlob.LeftDetector.LeftWeld)
                            CreatureRelease:FireServer(MyBlob.LeftDetector.LeftWeld)
                        end)
                        if i < 3 then task.wait(0.08) end
                    end
                end
            end

        local MyBlob = myHum.SeatPart.Parent
        local LeftDetector = MyBlob:FindFirstChild("LeftDetector")
        local RightDetector = MyBlob:FindFirstChild("RightDetector")
        local LeftWeld = LeftDetector and (LeftDetector:FindFirstChild("LeftWeld") or LeftDetector:FindFirstChildWhichIsA("Weld") or LeftDetector:FindFirstChildWhichIsA("RigidConstraint"))
        local RightWeld = RightDetector and (RightDetector:FindFirstChild("RightWeld") or RightDetector:FindFirstChildWhichIsA("Weld") or RightDetector:FindFirstChildWhichIsA("RigidConstraint"))
        local scr = MyBlob:FindFirstChild("BlobmanSeatAndOwnerScript") or MyBlob:FindFirstChild("BlobmanSeatAndOwnerScript[old]")
        local CreatureGrab = scr and scr:FindFirstChild("CreatureGrab")
        local CreatureRelease = scr and scr:FindFirstChild("CreatureRelease")

        if not CreatureGrab or not CreatureRelease or not LeftDetector or not LeftWeld then
            Settings.BlobmanBeta.kickAllV2Active = false return
        end

        for _, targetPlayer in ipairs(allPlayers) do
            if not Settings.BlobmanBeta.kickAllV2Active then break end
            local targetChar = targetPlayer.Character
            local targetRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                myHRP.CFrame = targetRoot.CFrame
                task.wait(0.02)
                for i = 1, 3 do
                    if not Settings.BlobmanBeta.kickAllV2Active then break end
                    pcall(function()
                        CreatureGrab:FireServer(LeftDetector, targetRoot, LeftWeld)
                        CreatureRelease:FireServer(LeftWeld)
                    end)
                    if i < 3 then task.wait(0.08) end
                end
            end
        end

        myHRP.CFrame = CFrame.new(0, 100, 0)
        task.wait(0.1)
        for _, part in ipairs(MyBlob:GetDescendants()) do
            if part:IsA("BasePart") then pcall(function() part.Anchored = true end) end
        end
        task.wait(0.1)

        local radius = 15
        for i, targetPlayer in ipairs(allPlayers) do
            local targetRoot = targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                local angle = math.rad((i - 1) * (360 / #allPlayers))
                local x = radius * math.cos(angle)
                local z = radius * math.sin(angle)
                targetRoot.CFrame = CFrame.new(x, 110, z)
            end
        end
        task.wait(0.1)

        for _ = 1, 2 do
            for _, targetPlayer in ipairs(allPlayers) do
                local targetRoot = targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                if targetRoot then
                    pcall(function()
                        setNetworkOwnerEvent:FireServer(targetRoot, CFrame.new(targetRoot.Position))
                        destroyGrabLineEvent:FireServer(targetRoot)
                    end)
                end
            end
            task.wait(0.1)
        end
        task.wait(0.3)

        for _, targetPlayer in ipairs(allPlayers) do
            if not Settings.BlobmanBeta.kickAllV2Active then break end
            local targetRoot = targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                pcall(function()
                    CreatureGrab:FireServer(LeftDetector, targetRoot, LeftWeld)
                end)
                if RightDetector and RightWeld then
                    pcall(function()
                        CreatureGrab:FireServer(RightDetector, targetRoot, RightWeld)
                    end)
                end
            end
        end

        for _, part in ipairs(MyBlob:GetDescendants()) do
            if part:IsA("BasePart") then pcall(function() part.Anchored = false end) end
        end

        Settings.BlobmanBeta.kickAllV2Active = false
    end)
end

function BlobmanBetaFeature.stopKickAllV2()
    Settings.BlobmanBeta.kickAllV2Active = false
    if State.kickAllV2Conn then task.cancel(State.kickAllV2Conn) State.kickAllV2Conn = nil end
end




local MiscFeature = {}

function MiscFeature.enableThirdPerson()
    Settings.Misc.ThirdPerson = true
    LocalPlayer.CameraMode = Enum.CameraMode.Classic
    LocalPlayer.CameraMinZoomDistance = 2
    LocalPlayer.CameraMaxZoomDistance = 128

    State.thirdPersonCloneConn = RunService.RenderStepped:Connect(function()
        if not Settings.Misc.ThirdPerson then return end
        local now = tick()
        if State._thirdPersonLastUpdate and now - State._thirdPersonLastUpdate < 0.05 then return end
        State._thirdPersonLastUpdate = now
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end

        local bodyParts = {"Head", "Torso", "UpperTorso", "LowerTorso", "Left Arm", "Right Arm", "Left Leg", "Right Leg", "LeftUpperArm", "LeftLowerArm", "LeftHand", "RightUpperArm", "RightLowerArm", "RightHand", "LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "RightUpperLeg", "RightLowerLeg", "RightFoot"}
        for _, name in ipairs(bodyParts) do
            local part = char:FindFirstChild(name)
            if part and part:IsA("BasePart") and part.Transparency > 0 then
                part.Transparency = 0
            end
        end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.Transparency = 1
        end
        for _, partName in ipairs(bodyParts) do
            local part = char:FindFirstChild(partName)
            if part then
                for _, child in pairs(part:GetChildren()) do
                    if child:IsA("Decal") and child.Transparency > 0 then
                        child.Transparency = 0
                    end
                end
            end
        end
        local head = char:FindFirstChild("Head")
        if head then
            for _, acc in pairs(char:GetChildren()) do
                if acc:IsA("Accessory") then
                    local name = acc.Name
                    if name ~= "bloxcxy" and name ~= "TypingKeyboardMyWorld" then
                        local handle = acc:FindFirstChild("Handle")
                        if handle and handle.Transparency > 0 then
                            handle.Transparency = 0
                        end
                    end
                end
            end
        end
    end)
end

function MiscFeature.disableThirdPerson()
    Settings.Misc.ThirdPerson = false
    LocalPlayer.CameraMode = Enum.CameraMode.Classic
    LocalPlayer.CameraMinZoomDistance = 0.5
    LocalPlayer.CameraMaxZoomDistance = 0.5

    if State.thirdPersonCloneConn then
        State.thirdPersonCloneConn:Disconnect()
        State.thirdPersonCloneConn = nil
    end
end

function MiscFeature.enableFPSBooster()
    Settings.Misc.FPSBooster = true
    local lighting = Lighting
    local terrain = Workspace.Terrain
    if not State.originalSettings then
        State.originalSettings = {
            GlobalShadows = lighting.GlobalShadows,
            Brightness = lighting.Brightness,
            WaterTransparency = terrain.WaterTransparency,
            WaterWaveSize = terrain.WaterWaveSize,
            WaterWaveSpeed = terrain.WaterWaveSpeed
        }
    end
    lighting.GlobalShadows = false
    lighting.Brightness = 0
    terrain.WaterTransparency = 1
    terrain.WaterWaveSize = 0
    terrain.WaterWaveSpeed = 0
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
            obj.Enabled = false
        end
        if obj:IsA("Decal") then
            local isSpawnMarker = obj.Parent and obj.Parent.Name == "RespawnLocation"
            if not isSpawnMarker then
                if not obj:GetAttribute("OriginalTexture") then
                    obj:SetAttribute("OriginalTexture", obj.Texture)
                end
                obj.Texture = "rbxasset://textures/face.png"
            end
        end
        if obj:IsA("Texture") then
            if not obj:GetAttribute("OriginalTexture") then
                obj:SetAttribute("OriginalTexture", obj.Texture)
            end
            obj.Texture = "rbxasset://textures/face.png"
        end
        if obj:IsA("MeshPart") or obj:IsA("UnionOperation") or obj:IsA("Part") then
            if not obj:GetAttribute("OriginalMaterial") then
                obj:SetAttribute("OriginalMaterial", obj.Material.Name)
                obj:SetAttribute("OriginalReflectance", obj.Reflectance)
            end
            obj.Material = Enum.Material.SmoothPlastic
            obj.Reflectance = 0
        end
    end
    if State.connections.fpsBooster then State.connections.fpsBooster:Disconnect() end
    State.connections.fpsBooster = Workspace.DescendantAdded:Connect(function(obj)
        if not Settings.Misc.FPSBooster then return end
        if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
            obj.Enabled = false
        end
        if obj:IsA("Decal") then
            local isSpawnMarker = obj.Parent and obj.Parent.Name == "RespawnLocation"
            if not isSpawnMarker then
                if not obj:GetAttribute("OriginalTexture") then
                    obj:SetAttribute("OriginalTexture", obj.Texture)
                end
                obj.Texture = "rbxasset://textures/face.png"
            end
        end
        if obj:IsA("Texture") then
            if not obj:GetAttribute("OriginalTexture") then
                obj:SetAttribute("OriginalTexture", obj.Texture)
            end
            obj.Texture = "rbxasset://textures/face.png"
        end
        if obj:IsA("MeshPart") or obj:IsA("UnionOperation") or obj:IsA("Part") then
            if not obj:GetAttribute("OriginalMaterial") then
                obj:SetAttribute("OriginalMaterial", obj.Material.Name)
                obj:SetAttribute("OriginalReflectance", obj.Reflectance)
            end
            obj.Material = Enum.Material.SmoothPlastic
            obj.Reflectance = 0
        end
    end)
end

function MiscFeature.disableFPSBooster()
    Settings.Misc.FPSBooster = false
    if State.connections.fpsBooster then
        State.connections.fpsBooster:Disconnect()
        State.connections.fpsBooster = nil
    end
    if State.originalSettings then
        local lighting = Lighting
        local terrain = Workspace.Terrain
        lighting.GlobalShadows = State.originalSettings.GlobalShadows
        lighting.Brightness = State.originalSettings.Brightness
        terrain.WaterTransparency = State.originalSettings.WaterTransparency
        terrain.WaterWaveSize = State.originalSettings.WaterWaveSize
        terrain.WaterWaveSpeed = State.originalSettings.WaterWaveSpeed
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
                obj.Enabled = true
            end
            if obj:IsA("Decal") and obj:GetAttribute("OriginalTexture") then
                obj.Texture = obj:GetAttribute("OriginalTexture")
            end
            if obj:IsA("Texture") and obj:GetAttribute("OriginalTexture") then
                obj.Texture = obj:GetAttribute("OriginalTexture")
            end
            if (obj:IsA("MeshPart") or obj:IsA("UnionOperation") or obj:IsA("Part")) and obj:GetAttribute("OriginalMaterial") then
                obj.Material = Enum.Material[obj:GetAttribute("OriginalMaterial")]
                obj.Reflectance = obj:GetAttribute("OriginalReflectance") or 0
            end
        end
        State.originalSettings = nil
    end
end

function MiscFeature.enablePhantomPallets()
    Settings.Misc.phantomPallets = true
    local PHANTOM_COLOR = Color3.fromRGB(130, 130, 130)
    local PHANTOM_GLOW_COLOR = Color3.fromRGB(160, 165, 180)
    State.phantomPalletsConn = RunService.Heartbeat:Connect(function()
        if not Settings.Misc.phantomPallets then return end
        local folderName = LocalPlayer.Name .. "SpawnedInToys"
        local toyFolder = Workspace:FindFirstChild(folderName)
        if toyFolder then
            for _, pallet in ipairs(toyFolder:GetChildren()) do
                if pallet.Name == "PalletLightBrown" then
                    for _, obj in ipairs(pallet:GetDescendants()) do
                        if obj:IsA("BasePart") and obj.Transparency ~= 1 then
                            if not obj:GetAttribute("PhantomOrigColor") then
                                obj:SetAttribute("PhantomOrigColor", obj.Color)
                            end
                            if not obj:GetAttribute("PhantomOrigMaterial") then
                                obj:SetAttribute("PhantomOrigMaterial", obj.Material.Name)
                            end
                            if not obj:GetAttribute("PhantomOrigTransparency") then
                                obj:SetAttribute("PhantomOrigTransparency", obj.Transparency)
                            end
                            obj.Color = PHANTOM_COLOR
                            obj.Material = Enum.Material.Basalt
                            obj.Transparency = 0.8
                            if not obj:FindFirstChild("PhantomGlowLight") then
                                local pl = Instance.new("PointLight")
                                pl.Name = "PhantomGlowLight"
                                pl.Color = PHANTOM_GLOW_COLOR
                                pl.Brightness = 0.8
                                pl.Range = 5
                                pl.Shadows = false
                                pl.Parent = obj
                            end
                        elseif obj:IsA("Decal") or obj:IsA("Texture") then
                            pcall(function() obj:Destroy() end)
                        end
                    end
                end
            end
        end
    end)
end

function MiscFeature.disablePhantomPallets()
    Settings.Misc.phantomPallets = false
    if State.phantomPalletsConn then
        State.phantomPalletsConn:Disconnect()
        State.phantomPalletsConn = nil
    end
    local folderName = LocalPlayer.Name .. "SpawnedInToys"
    local toyFolder = Workspace:FindFirstChild(folderName)
    if toyFolder then
        for _, pallet in ipairs(toyFolder:GetChildren()) do
            if pallet.Name == "PalletLightBrown" then
                for _, obj in ipairs(pallet:GetDescendants()) do
                    if obj:IsA("BasePart") then
                        local glow = obj:FindFirstChild("PhantomGlowLight")
                        if glow then glow:Destroy() end
                        local origColor = obj:GetAttribute("PhantomOrigColor")
                        local origMat = obj:GetAttribute("PhantomOrigMaterial")
                        local origTransp = obj:GetAttribute("PhantomOrigTransparency")
                        if origColor then
                            obj.Color = origColor
                            obj:SetAttribute("PhantomOrigColor", nil)
                        end
                        if origMat then
                            obj.Material = Enum.Material[origMat]
                            obj:SetAttribute("PhantomOrigMaterial", nil)
                        end
                        if origTransp ~= nil then
                            obj.Transparency = origTransp
                            obj:SetAttribute("PhantomOrigTransparency", nil)
                        end
                    end
                end
            end
        end
    end
end

function MiscFeature.ExecuteBarrierDestroyer()
    local player = LocalPlayer
    local playerName = player.Name
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        warn("Character not found")
        return false
    end
    local originalPosition = player.Character.HumanoidRootPart.CFrame
    pcall(function()
        SpawnToyRF:InvokeServer("InstrumentWoodwindOcarina",
            CFrame.new(184.148834, -5.54824972, 498.136749, 0.829037189, -0.214714944, 0.516328275, 0, 0.923344612, 0.383972496, -0.559193552, -0.318327487, 0.765486956),
            Vector3.new(0, 34, 0)
        )
    end)
    task.wait(0.3)
    local toyFolder = Utility.waitForChild(Workspace, playerName .. "SpawnedInToys", 3)
    if not toyFolder then warn("Toy folder not found") return false end
    local ocarina = Utility.waitForChild(toyFolder, "InstrumentWoodwindOcarina", 3)
    if not ocarina then warn("Ocarina not found") return false end
    local holdPart = Utility.waitForChild(ocarina, "HoldPart", 2)
    if not holdPart then warn("HoldPart not found") return false end
    task.wait(0.1)
    holdPart.HoldItemRemoteFunction:InvokeServer(ocarina, Workspace[playerName])
    task.wait(0.3)
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return false end
    player.Character.HumanoidRootPart.CFrame = CFrame.new(304.06, 25.77, 488.54)
    task.wait(0.15)
    if ocarina and ocarina.Parent then pcall(function() DeleteToyRE:FireServer(ocarina) end) end
    task.wait(0.15)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = originalPosition
    end
    for _, v in ipairs(Workspace.Plots:GetChildren()) do
        local barrier = v:FindFirstChild("Barrier")
        if barrier then
            for _, p in ipairs(barrier:GetChildren()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end
    end
    task.wait(0.5)
    pcall(function()
        SpawnToyRF:InvokeServer("Campfire", player.Character.HumanoidRootPart.CFrame, Vector3.zero)
    end)
    task.wait(0.2)
    local campfire = Utility.waitForChild(toyFolder, "Campfire", 2)
    if not campfire then warn("Failed to spawn campfire") return false end
    local soundPart = campfire:FindFirstChild("SoundPart")
    if not soundPart then pcall(function() DeleteToyRE:FireServer(campfire) end) return false end
    FTAP.SetNetworkOwner(soundPart, player.Character.HumanoidRootPart.CFrame)
    soundPart.CFrame = CFrame.new(304, 25, 488)
    task.wait(2)
    local success = campfire.Parent ~= nil
    if campfire and campfire.Parent then pcall(function() DeleteToyRE:FireServer(campfire) end) end
    return success
end

function MiscFeature.startMiniMap()
    if State.miniMapGui then return end
    local mapRp = RaycastParams.new()
    mapRp.FilterType = Enum.RaycastFilterType.Exclude

    local MapGui = Instance.new("ScreenGui")
    MapGui.Name = "CustomMinimapGui"
    MapGui.ResetOnSpawn = false
    pcall(function() MapGui.Parent = game:GetService("CoreGui") end)
    if not MapGui.Parent then MapGui.Parent = PlayerGui end
    State.miniMapGui = MapGui

    local MapFrame = Instance.new("Frame", MapGui)
    MapFrame.Size = UDim2.new(0, 220, 0, 220)
    MapFrame.Position = UDim2.new(0.01, 0, 0.02, 0)
    MapFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    MapFrame.BorderColor3 = Color3.fromRGB(255, 105, 180)
    MapFrame.BorderSizePixel = 2
    MapFrame.ClipsDescendants = true
    MapFrame.Visible = true
    MapFrame.Active = true
    State.miniMapFrame = MapFrame

    local gridRes = State.miniMapGridRes
    State.miniMapPixels = {}
    for x = 1, gridRes do
        State.miniMapPixels[x] = {}
        for y = 1, gridRes do
            local p = Instance.new("Frame", MapFrame)
            p.Size = UDim2.new(1 / gridRes, 0, 1 / gridRes, 0)
            p.Position = UDim2.new((x - 1) / gridRes, 0, (y - 1) / gridRes, 0)
            p.BorderSizePixel = 0
            p.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            State.miniMapPixels[x][y] = p
        end
    end

    local viewArrow = Instance.new("ImageLabel", MapFrame)
    viewArrow.Name = "ViewArrow"
    viewArrow.AnchorPoint = Vector2.new(0.5, 0.5)
    viewArrow.Size = UDim2.new(0, 20, 0, 14)
    viewArrow.BackgroundTransparency = 1
    viewArrow.ZIndex = 15
    viewArrow.Image = "rbxassetid://7072706796"
    viewArrow.ImageColor3 = Color3.fromRGB(0, 255, 255)
    viewArrow.Rotation = 0
    State.miniMapViewLine = viewArrow

    local dragStartPos = nil
    local dragging = false
    local uiMoving = false
    local mapScrolling = false
    local pressTime = 0
    local uiStartPos = nil
    local mapOffsetStart = nil
    local moveCon, endCon

    local function onInputBegin(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            uiMoving = false
            mapScrolling = false
            pressTime = tick()
            dragStartPos = input.Position
            uiStartPos = MapFrame.Position
            mapOffsetStart = State.miniMapOffset
            moveCon = UserInputService.InputChanged:Connect(function(inp)
                if (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) and dragging then
                    local delta = inp.Position - dragStartPos
                    local elapsed = tick() - pressTime
                    if not uiMoving and not mapScrolling then
                        if delta.Magnitude > 5 then
                            if elapsed > 0.25 then mapScrolling = true
                            else uiMoving = true end
                        end
                    end
                    if uiMoving then
                        MapFrame.Position = UDim2.new(uiStartPos.X.Scale, uiStartPos.X.Offset + delta.X, uiStartPos.Y.Scale, uiStartPos.Y.Offset + delta.Y)
                    elseif mapScrolling then
                        local relX = delta.X / MapFrame.AbsoluteSize.X
                        local relY = delta.Y / MapFrame.AbsoluteSize.Y
                        State.miniMapOffset = mapOffsetStart - Vector3.new(relX * State.miniMapZoom, 0, relY * State.miniMapZoom)
                    end
                end
            end)
            endCon = UserInputService.InputEnded:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                    if dragging then
                        dragging = false
                        if not uiMoving and not mapScrolling and (inp.Position - dragStartPos).Magnitude < 15 and LocalPlayer.Character then
                            local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                            if root then
                                local relX = (inp.Position.X - MapFrame.AbsolutePosition.X) / MapFrame.AbsoluteSize.X - 0.5
                                local relY = (inp.Position.Y - MapFrame.AbsolutePosition.Y) / MapFrame.AbsoluteSize.Y - 0.5
                                local centerPos = root.Position + State.miniMapOffset
                                local targetX = centerPos.X + (relX * State.miniMapZoom)
                                local targetZ = centerPos.Z + (relY * State.miniMapZoom)
                                mapRp.FilterDescendantsInstances = {LocalPlayer.Character}
                                local rayRes = Workspace:Raycast(Vector3.new(targetX, 1000, targetZ), Vector3.new(0, -2000, 0), mapRp)
                                local finalY = rayRes and rayRes.Position.Y or root.Position.Y
                                root.CFrame = CFrame.new(targetX, finalY + 4, targetZ)
                            end
                        end
                    end
                    if moveCon then moveCon:Disconnect() moveCon = nil end
                    if endCon then endCon:Disconnect() endCon = nil end
                end
            end)
        end
    end
    table.insert(State.miniMapInputConns, MapFrame.InputBegan:Connect(onInputBegin))

    table.insert(State.miniMapInputConns, MapFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseWheel then
            State.miniMapZoom = math.clamp(State.miniMapZoom + (input.Position.Z * -100), 50, 1500)
        end
    end))

    local initialZoom = State.miniMapZoom
    table.insert(State.miniMapInputConns, UserInputService.TouchPinch:Connect(function(touchPositions, scale, velocity, state)
        if not MapFrame.Visible then return end
        if state == Enum.UserInputState.Begin then
            initialZoom = State.miniMapZoom
        elseif state == Enum.UserInputState.Change then
            State.miniMapZoom = math.clamp(initialZoom / scale, 50, 1500)
        end
    end))

    table.insert(State.miniMapInputConns, Players.PlayerRemoving:Connect(function(p)
        if State.miniMapPlayerDots[p.Name] then
            State.miniMapPlayerDots[p.Name]:Destroy()
            State.miniMapPlayerDots[p.Name] = nil
        end
    end))

    State.miniMapRenderConn = RunService.RenderStepped:Connect(function()
        if not Settings.Misc.miniMap then return end
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local centerPos = hrp.Position + State.miniMapOffset
        local now = tick()
        local moved = (centerPos - State.miniMapLastScanPos).Magnitude > 6
        local timed = now - State.miniMapLastScanTime > 1.5
        if MapFrame.Visible and (moved or timed) then
            State.miniMapLastScanPos = centerPos
            State.miniMapLastScanTime = now
            mapRp.FilterDescendantsInstances = {char}
            for x = 1, gridRes do
                for y = 1, gridRes do
                    local offX = ((x - 1) / (gridRes - 1) - 0.5) * State.miniMapZoom
                    local offZ = ((y - 1) / (gridRes - 1) - 0.5) * State.miniMapZoom
                    local ray = Workspace:Raycast(centerPos + Vector3.new(offX, 100, offZ), Vector3.new(0, -200, 0), mapRp)
                    if ray and ray.Instance then
                        local partColor = ray.Instance.Color
                        local h = math.clamp((ray.Position.Y - centerPos.Y + 30) / 60, 0.3, 1.2)
                        local r = math.clamp(partColor.R * 255 * h, 0, 255)
                        local g = math.clamp(partColor.G * 255 * h, 0, 255)
                        local b = math.clamp(partColor.B * 255 * h, 0, 255)
                        State.miniMapPixels[x][y].BackgroundColor3 = Color3.fromRGB(r, g, b)
                    else
                        State.miniMapPixels[x][y].BackgroundColor3 = Color3.fromRGB(15, 15, 20)
                    end
                end
            end
        end
        if MapFrame.Visible then
            local camCF = Camera and Camera.CFrame
            if camCF then
                local lookVec = camCF.LookVector
                local angle = math.atan2(lookVec.Z, lookVec.X)
                if State.miniMapViewLine then
                    local radius = 18
                    local ax = 0.5 + math.cos(angle) * radius / MapFrame.AbsoluteSize.X
                    local ay = 0.5 + math.sin(angle) * radius / MapFrame.AbsoluteSize.Y
                    State.miniMapViewLine.Position = UDim2.new(ax, 0, ay, 0)
                    State.miniMapViewLine.Rotation = math.deg(angle) + 90
                end
            end
            for _, p in pairs(Players:GetPlayers()) do
                local pr = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
                if pr then
                    local d = State.miniMapPlayerDots[p.Name]
                    if not d then
                        d = Instance.new("Frame", MapFrame)
                        d.Size = UDim2.new(0, 26, 0, 26)
                        d.AnchorPoint = Vector2.new(0.5, 0.5)
                        d.BackgroundTransparency = 1
                        d.ZIndex = 10
                        local iconBg = Instance.new("Frame", d)
                        iconBg.Size = UDim2.new(1, 0, 1, 0)
                        iconBg.BackgroundColor3 = (p == LocalPlayer) and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(255, 50, 50)
                        Instance.new("UICorner", iconBg).CornerRadius = UDim.new(1, 0)
                        local icon = Instance.new("ImageLabel", iconBg)
                        icon.Size = UDim2.new(1, -4, 1, -4)
                        icon.Position = UDim2.new(0, 2, 0, 2)
                        icon.BackgroundTransparency = 1
                        Instance.new("UICorner", icon).CornerRadius = UDim.new(1, 0)
                        icon.ClipsDescendants = true
                        task.spawn(function()
                            local success, url = pcall(function() return Players:GetUserThumbnailAsync(p.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48) end)
                            if success and url then icon.Image = url end
                        end)
                        local nameLbl = Instance.new("TextLabel", d)
                        nameLbl.Size = UDim2.new(0, 100, 0, 12)
                        nameLbl.Position = UDim2.new(0.5, -50, 1, 2)
                        nameLbl.BackgroundTransparency = 1
                        nameLbl.Text = p.DisplayName
                        nameLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
                        nameLbl.TextStrokeTransparency = 0.3
                        nameLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                        nameLbl.TextSize = 10
                        nameLbl.Font = Enum.Font.GothamBold
                        nameLbl.ZIndex = 11
                        State.miniMapPlayerDots[p.Name] = d
                    end
                    local rx = (pr.Position.X - centerPos.X) / State.miniMapZoom
                    local rz = (pr.Position.Z - centerPos.Z) / State.miniMapZoom
                    d.Position = UDim2.new(0.5 + rx, 0, 0.5 + rz, 0)
                    d.Visible = math.abs(rx) < 0.5 and math.abs(rz) < 0.5
                end
            end
        end
    end)
end

function MiscFeature.stopMiniMap()
    Settings.Misc.miniMap = false
    if State.miniMapRenderConn then
        State.miniMapRenderConn:Disconnect()
        State.miniMapRenderConn = nil
    end
    for _, conn in ipairs(State.miniMapInputConns) do
        if conn.Connected then conn:Disconnect() end
    end
    State.miniMapInputConns = {}
    for _, dot in pairs(State.miniMapPlayerDots) do
        if dot and dot.Parent then dot:Destroy() end
    end
    State.miniMapPlayerDots = {}
    if State.miniMapGui then
        State.miniMapGui:Destroy()
        State.miniMapGui = nil
        State.miniMapFrame = nil
        State.miniMapViewLine = nil
    end
end




local function SnowballRagdollFunction(targetName)
    local target = Players:FindFirstChild(targetName)
    if not target then return end
    if isProtectedPlayer(targetName) then return end
    local trackedSnowballs = {}
    while State.snowballRagdollActive do
        if not target or not target.Parent then break end
        local tChar = target.Character
        local hrp = tChar and tChar:FindFirstChild("HumanoidRootPart")
        if not hrp then task.wait(0.1) continue end

        local targetCF = hrp.CFrame

        task.spawn(function()
            pcall(function()
                SpawnToyRF:InvokeServer("BallSnowball", targetCF * CFrame.new(0, 0, 18), Vector3.zero)
            end)
        end)

        task.wait(0.15)

        local folder = Workspace:FindFirstChild(LocalPlayer.Name .. "SpawnedInToys")
        if folder then
            for _, snowball in pairs(folder:GetChildren()) do
                if snowball.Name == "BallSnowball" and snowball.Parent and not trackedSnowballs[snowball] then
                    trackedSnowballs[snowball] = tick()
                    local part = snowball.PrimaryPart or snowball:FindFirstChildWhichIsA("BasePart")
                    if part then
                        pcall(function() setNetworkOwnerEvent:FireServer(part, targetCF) end)
                        part.CFrame = targetCF
                        part.AssemblyLinearVelocity = Vector3.zero
                        part.AssemblyAngularVelocity = Vector3.zero
                    end
                end
            end
        end

        for snowball, spawnTime in pairs(trackedSnowballs) do
            if not snowball or not snowball.Parent then
                trackedSnowballs[snowball] = nil
            elseif tick() - spawnTime > 0.5 then
                pcall(function() DeleteToyRE:FireServer(snowball) end)
                trackedSnowballs[snowball] = nil
            end
        end

        task.wait(0.1)
    end
end

local function GetSnowballPlayerList()
    local list = {}
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and not isProtectedPlayer(plr.Name) then
            table.insert(list, plr.DisplayName .. " @" .. plr.Name)
        end
    end
    return list
end




-- ============================================================
-- EndorisFTAP Reborn | GUI на Rayfield
-- Вся логика (AntiFeature, BlobmanBetaFeature и т.д.) остаётся БЕЗ ИЗМЕНЕНИЙ
-- ============================================================

local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/SiriusMenu/Rayfield/main/Source"))()

local Window = Rayfield:CreateWindow({
    Name = "EndorisFTAP Reborn | skeethook",
    LoadingTitle = "EndorisFTAP Reborn",
    LoadingSubtitle = "by skeethook",
    Theme = "Default",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "EndorisFTAP",
        FileName = "Config",
    },
    Discord = { Enabled = false },
    KeySystem = false,
})

-- ============================================================
-- TAB: Main
-- ============================================================
local MainTab = Window:CreateTab({ Title = "Main", Image = 4483362458 })

local MainSnowSec = MainTab:CreateSection("Snowball")

MainSnowSec:CreateToggle({
    Name = "Snowball Ragdoll",
    CurrentValue = false,
    Flag = "SnowballRagdoll",
    Callback = function(v)
        State.snowballRagdollActive = v
        if v then
            if State.snowballTarget then
                State.snowballRagdollTask = task.spawn(function()
                    SnowballRagdollFunction(State.snowballTarget)
                end)
            else
                State.snowballRagdollActive = false
                warn("Select a target first!")
            end
        else
            if State.snowballRagdollTask then
                task.cancel(State.snowballRagdollTask)
                State.snowballRagdollTask = nil
            end
        end
    end,
})

local SnowballTargetDropdown
MainSnowSec:CreateButton({
    Name = "Refresh Players",
    Callback = function()
        pcall(function()
            SnowballTargetDropdown:Set(GetSnowballPlayerList())
        end)
    end,
})

SnowballTargetDropdown = MainSnowSec:CreateDropdown({
    Name = "Select Target",
    Options = GetSnowballPlayerList(),
    CurrentOption = {"Select Target"},
    Flag = "SnowballTargetDropdown",
    Callback = function(option)
        local value = type(option) == "table" and option[1] or option
        local name = value:match("@(.+)$")
        if name then State.snowballTarget = name end
    end,
})

-- Секция Aim (Main)
local MainAimSec = MainTab:CreateSection("Aim")

MainAimSec:CreateToggle({
    Name = "Silent Aim",
    CurrentValue = false,
    Flag = "SilentAim",
    Callback = function(v)
        Settings.PvP.SilentAimEnabled = v
        if v and not State.CameraInitialized then
            State.CameraClone = Camera:Clone()
            State.CameraClone.Parent = workspace
            State.CameraClone.Name = "SilentCamera"
            State.CameraClone.CFrame = Camera.CFrame
            workspace.CurrentCamera = State.CameraClone
            State.CameraInitialized = true
        end
    end,
})

MainAimSec:CreateSlider({
    Name = "Silent Strength",
    Range = {1, 200},
    Increment = 1,
    CurrentValue = 50,
    Flag = "SilentAimStrength",
    Callback = function(v) Settings.PvP.SilentAimStrength = v end,
})

MainAimSec:CreateToggle({
    Name = "Silent Keybind Mode",
    CurrentValue = false,
    Flag = "SilentAimKeybindMode",
    Callback = function(v)
        Settings.PvP.SilentAimKeybindMode = v
        if not v then Settings.PvP.SilentAimKeybindHeld = false end
    end,
})

MainAimSec:CreateKeybind({
    Name = "Silent Aim Key",
    CurrentKeybind = Enum.KeyCode.Unknown,
    HoldToInteract = true,
    Flag = "SilentAimKeybind",
    Callback = function(holding)
        Settings.PvP.SilentAimKeybindHeld = holding
    end,
})

MainAimSec:CreateToggle({
    Name = "Triggerbot",
    CurrentValue = false,
    Flag = "Triggerbot",
    Callback = function(v) Settings.PvP.TriggerbotEnabled = v end,
})

MainAimSec:CreateToggle({
    Name = "Legit Aim",
    CurrentValue = false,
    Flag = "LegitAim",
    Callback = function(v)
        Settings.PvP.LegitAimEnabled = v
        if not v then
            Settings.PvP.LegitAimHolding = false
        else
            pcall(function()
                if UserInputService:IsKeyDown(Enum.KeyCode.Q) then
                    Settings.PvP.LegitAimHolding = true
                end
            end)
        end
    end,
})

MainAimSec:CreateKeybind({
    Name = "Legit Aim Key",
    CurrentKeybind = Enum.KeyCode.Unknown,
    HoldToInteract = true,
    Flag = "LegitAimKey",
    Callback = function(holding) Settings.PvP.LegitAimHolding = holding end,
})

MainAimSec:CreateDropdown({
    Name = "Target Mode",
    Options = {"Closest to Crosshair", "Closest Distance"},
    CurrentOption = {"Closest to Crosshair"},
    Flag = "LegitAimMode",
    Callback = function(option)
        local v = type(option) == "table" and option[1] or option
        Settings.PvP.LegitAimMode = (v == "Closest to Crosshair") and "Crosshair" or "Distance"
    end,
})

MainAimSec:CreateDropdown({
    Name = "Hitbox",
    Options = {"Head", "Body", "Left Arm", "Right Arm", "Left Leg", "Right Leg"},
    CurrentOption = {"Body"},
    Flag = "LegitAimHitbox",
    Callback = function(option)
        Settings.PvP.LegitAimHitbox = type(option) == "table" and option[1] or option
    end,
})

MainAimSec:CreateToggle({ Name = "Only Visible", CurrentValue = false, Flag = "LegitAimVisible",
    Callback = function(v) Settings.PvP.LegitAimVisible = v end })
MainAimSec:CreateToggle({ Name = "Smooth Legit", CurrentValue = false, Flag = "LegitAimSmooth",
    Callback = function(v) Settings.PvP.LegitAimSmooth = v end })
MainAimSec:CreateSlider({ Name = "Smoothness", Range = {1, 10}, Increment = 1, CurrentValue = 10, Flag = "LegitAimSmoothness",
    Callback = function(v) Settings.PvP.LegitAimSmoothness = v end })
MainAimSec:CreateToggle({ Name = "Unsafe Mod", CurrentValue = false, Flag = "LegitAimUnsafe",
    Callback = function(v) Settings.PvP.LegitAimUnsafe = v end })
MainAimSec:CreateToggle({ Name = "Ignore Friends", CurrentValue = false, Flag = "LegitAimIgnoreFriends",
    Callback = function(v) Settings.PvP.LegitAimIgnoreFriends = v end })
MainAimSec:CreateToggle({ Name = "Work On NPC", CurrentValue = false, Flag = "LegitAimWorkOnNPC",
    Callback = function(v)
        Settings.PvP.LegitAimWorkOnNPC = v
        if not v then LegitAimFeature.npcCache = nil end
    end })

-- ============================================================
-- TAB: Target (Blobman)
-- ============================================================
local BlobmanTab = Window:CreateTab({ Title = "Target", Image = 4483362458 })

-- Settings
local BlobSettingsSec = BlobmanTab:CreateSection("Settings")
BlobSettingsSec:CreateToggle({ Name = "Protect Friends", CurrentValue = false, Flag = "ProtectFriends",
    Callback = function(v) Settings.BlobmanBeta.ignoreFriends = v end })

-- Ownership
local OwnershipSec = BlobmanTab:CreateSection("Ownership")
local OwnershipKickTarget = nil
local OwnershipKickDropdown

OwnershipSec:CreateButton({
    Name = "Refresh Players",
    Callback = function()
        pcall(function() OwnershipKickDropdown:Set(BlobmanBetaFeature.GetPlayerList()) end)
    end,
})

OwnershipKickDropdown = OwnershipSec:CreateDropdown({
    Name = "Select Target",
    Options = BlobmanBetaFeature.GetPlayerList(),
    CurrentOption = {"Select Target"},
    Flag = "OwnershipKickTarget",
    Callback = function(option)
        local v = type(option) == "table" and option[1] or option
        local name = v:match("@(.+)$")
        if name then ownershipKickTarget = name end
    end,
})

OwnershipSec:CreateToggle({ Name = "Loop Kick", CurrentValue = false, Flag = "OwnershipKickLoop",
    Callback = function(v) Settings.Loop.ownershipKickActive = v end })
OwnershipSec:CreateToggle({ Name = "Loop Kick V2", CurrentValue = false, Flag = "OwnershipKickLoopV2",
    Callback = function(v) Settings.Loop.ownershipKickV2Active = v end })
OwnershipSec:CreateToggle({ Name = "Ragdoll Target", CurrentValue = false, Flag = "OwnershipPalletRagdoll",
    Callback = function(v) Settings.Loop.palletRagdollActive = v end })

-- Blobman
local BlobSec = BlobmanTab:CreateSection("Blobman")
local BlobTargetDropdown

BlobSec:CreateButton({
    Name = "Refresh Players",
    Callback = function()
        pcall(function() BlobTargetDropdown:Set(BlobmanBetaFeature.GetPlayerList()) end)
    end,
})

BlobTargetDropdown = BlobSec:CreateDropdown({
    Name = "Select Target",
    Options = BlobmanBetaFeature.GetPlayerList(),
    CurrentOption = {"Select Target"},
    Flag = "BlobTargetDropdown",
    Callback = function(option)
        local v = type(option) == "table" and option[1] or option
        local name = v:match("@(.+)$")
        if name then Settings.BlobmanBeta.selectedTarget = name end
    end,
})

BlobSec:CreateDropdown({
    Name = "Kick Method",
    Options = {"Kick Double Hands", "Kick Grab + Blob", "Kick One Grab", "Kick Fly Up", "Kick Drift Fly"},
    CurrentOption = {"Kick Double Hands"},
    Flag = "KickMethod",
    Callback = function(option)
        Settings.BlobmanBeta.kickMethod = type(option) == "table" and option[1] or option
    end,
})

BlobSec:CreateToggle({ Name = "Kick", CurrentValue = false, Flag = "BlobKick", Callback = function(v) end })
BlobSec:CreateToggle({ Name = "Loop Kill (Beta)", CurrentValue = false, Flag = "LoopKill",
    Callback = function(v) Settings.BlobmanBeta.loopKillActive = v end })
BlobSec:CreateButton({ Name = "Bring", Callback = function() end })
BlobSec:CreateButton({ Name = "Touch", Callback = function() end })
BlobSec:CreateToggle({ Name = "Anti Vehicle Seat", CurrentValue = false, Flag = "AntiVehicleSeat",
    Callback = function(v) Settings.BlobmanBeta.antiVehicleSeat = v end })
BlobSec:CreateToggle({ Name = "Unsafe Blobman", CurrentValue = false, Flag = "UnsafeBlobman",
    Callback = function(v) Settings.BlobmanBeta.unsafeBlobman = v end })

-- Pallet Fling
local PalletFlingSec = BlobmanTab:CreateSection("Pallet Fling")
local PalletFlingDropdown
PalletFlingSec:CreateButton({ Name = "Refresh Players",
    Callback = function() pcall(function() PalletFlingDropdown:Set(BlobmanBetaFeature.GetPlayerList()) end) end })
PalletFlingDropdown = PalletFlingSec:CreateDropdown({
    Name = "Select Target",
    Options = BlobmanBetaFeature.GetPlayerList(),
    CurrentOption = {"Select Target"},
    Flag = "PalletFlingTargetDropdown",
    Callback = function(option)
        local v = type(option) == "table" and option[1] or option
        local name = v:match("@(.+)$")
        if name then Settings.BlobmanBeta.palletFlingTarget = name end
    end,
})
PalletFlingSec:CreateToggle({ Name = "Pallet Fling", CurrentValue = false, Flag = "PalletFling",
    Callback = function(v) Settings.BlobmanBeta.palletFlingActive = v end })

-- Clone Fling
local CloneFlingSec = BlobmanTab:CreateSection("Clone Fling")
local CloneFlingDropdown
CloneFlingSec:CreateButton({ Name = "Refresh Players",
    Callback = function() pcall(function() CloneFlingDropdown:Set(BlobmanBetaFeature.GetPlayerList()) end) end })
CloneFlingDropdown = CloneFlingSec:CreateDropdown({
    Name = "Select Target",
    Options = BlobmanBetaFeature.GetPlayerList(),
    CurrentOption = {"Select Target"},
    Flag = "CloneFlingTargetDropdown",
    Callback = function(option)
        local v = type(option) == "table" and option[1] or option
        local name = v:match("@(.+)$")
        if name then Settings.BlobmanBeta.cloneFlingTarget = name end
    end,
})
CloneFlingSec:CreateToggle({ Name = "Clone Fling", CurrentValue = false, Flag = "CloneFling",
    Callback = function(v) Settings.BlobmanBeta.cloneFlingActive = v end })

-- Glass Box Fling
local GlassBoxFlingSec = BlobmanTab:CreateSection("Glass Box Fling")
local GlassBoxFlingDropdown
GlassBoxFlingSec:CreateButton({ Name = "Refresh Players",
    Callback = function() pcall(function() GlassBoxFlingDropdown:Set(BlobmanBetaFeature.GetPlayerList()) end) end })
GlassBoxFlingDropdown = GlassBoxFlingSec:CreateDropdown({
    Name = "Select Target",
    Options = BlobmanBetaFeature.GetPlayerList(),
    CurrentOption = {"Select Target"},
    Flag = "GlassBoxFlingTargetDropdown",
    Callback = function(option)
        local v = type(option) == "table" and option[1] or option
        local name = v:match("@(.+)$")
        if name then Settings.BlobmanBeta.glassBoxFlingTarget = name end
    end,
})
GlassBoxFlingSec:CreateToggle({ Name = "Glass Box Fling", CurrentValue = false, Flag = "GlassBoxFling",
    Callback = function(v) Settings.BlobmanBeta.glassBoxFlingActive = v end })

-- Self Fling
local SelfFlingSec = BlobmanTab:CreateSection("Self Fling")
local SelfFlingDropdown
SelfFlingSec:CreateButton({ Name = "Refresh Players",
    Callback = function() pcall(function() SelfFlingDropdown:Set(BlobmanBetaFeature.GetPlayerList()) end) end })
SelfFlingDropdown = SelfFlingSec:CreateDropdown({
    Name = "Select Target",
    Options = BlobmanBetaFeature.GetPlayerList(),
    CurrentOption = {"Select Target"},
    Flag = "SelfFlingTargetDropdown",
    Callback = function(option)
        local v = type(option) == "table" and option[1] or option
        local name = v:match("@(.+)$")
        if name then Settings.BlobmanBeta.selfFlingTarget = name end
    end,
})
SelfFlingSec:CreateToggle({ Name = "Self Fling", CurrentValue = false, Flag = "SelfFling",
    Callback = function(v) Settings.BlobmanBeta.selfFlingActive = v end })

-- Explosion
local ExplosionSec = BlobmanTab:CreateSection("Explosion")
ExplosionSec:CreateDropdown({
    Name = "Missile Type",
    Options = {"BombMissile", "FireworkMissile", "BlackHole"},
    CurrentOption = {"BombMissile"},
    Flag = "ExplosionMissileType",
    Callback = function(option) explosionMissileType = type(option) == "table" and option[1] or option end,
})
local ExplosionTargetDropdown
ExplosionSec:CreateButton({ Name = "Refresh Players",
    Callback = function() pcall(function() ExplosionTargetDropdown:Set(BlobmanBetaFeature.GetPlayerList()) end) end })
ExplosionTargetDropdown = ExplosionSec:CreateDropdown({
    Name = "Select Target",
    Options = BlobmanBetaFeature.GetPlayerList(),
    CurrentOption = {"Select Target"},
    Flag = "ExplosionTargetDropdown",
    Callback = function(option)
        local v = type(option) == "table" and option[1] or option
        local name = v:match("@(.+)$")
        if name then explosionTargetName = name end
    end,
})
ExplosionSec:CreateToggle({ Name = "Explode Target", CurrentValue = false, Flag = "ExplosionExplodeTarget",
    Callback = function(v) Settings.Misc.explosionExplodeTarget = v end })
ExplosionSec:CreateSlider({ Name = "Missiles", Range = {1, 10}, Increment = 1, CurrentValue = 1, Flag = "ExplosionMissilesCount",
    Callback = function(v) Settings.Misc.explosionMissilesCount = v end })
ExplosionSec:CreateToggle({ Name = "Auto-Cache", CurrentValue = false, Flag = "AutoCacheMissiles",
    Callback = function(v) Settings.Misc.autoCache = v end })
ExplosionSec:CreateSlider({ Name = "Auto-Cache Count", Range = {1, 10}, Increment = 1, CurrentValue = 3, Flag = "AutoCacheCount",
    Callback = function(v) Settings.Misc.autoCacheCount = v end })
ExplosionSec:CreateKeybind({ Name = "Cache Missiles", CurrentKeybind = Enum.KeyCode.Unknown, HoldToInteract = true, Flag = "CacheMissiles", Callback = function() end })
ExplosionSec:CreateKeybind({ Name = "Explode All Missiles", CurrentKeybind = Enum.KeyCode.Unknown, HoldToInteract = false, Flag = "ExplodeAllMissiles", Callback = function() end })
ExplosionSec:CreateKeybind({ Name = "Explode 1 Crosshair", CurrentKeybind = Enum.KeyCode.Unknown, HoldToInteract = false, Flag = "Explode1Missile", Callback = function() end })
ExplosionSec:CreateKeybind({ Name = "Explode Line All Missiles", CurrentKeybind = Enum.KeyCode.Unknown, HoldToInteract = false, Flag = "ExplodeLineMissiles", Callback = function() end })

-- ============================================================
-- TAB: Anti
-- ============================================================
local AntiTab = Window:CreateTab({ Title = "Anti", Image = 4483362458 })

local AntiGrabsSec = AntiTab:CreateSection("Anti Grabs")
AntiGrabsSec:CreateToggle({ Name = "Anti Grab v1", CurrentValue = false, Flag = "AntiGrabV1",
    Callback = function(v) Settings.Anti.AntiGrab = v end })
AntiGrabsSec:CreateToggle({ Name = "Anti Grab v2", CurrentValue = false, Flag = "AntiGrabV2",
    Callback = function(v) Settings.Anti.AntiGrab = v end })
AntiGrabsSec:CreateToggle({ Name = "House Tp AntiGrab", CurrentValue = false, Flag = "HouseTpAntiGrab",
    Callback = function(v) Settings.Anti.HouseTpAntiGrab = v end })
AntiGrabsSec:CreateToggle({ Name = "Fight Back", CurrentValue = false, Flag = "FightBack",
    Callback = function(v) Settings.Anti.FightBack = v end })

local AntiKickSec = AntiTab:CreateSection("Anti Kick")
AntiKickSec:CreateToggle({ Name = "Gravity Anti Kick", CurrentValue = false, Flag = "AntiKickKunai",
    Callback = function(v) Settings.Anti.AntiKickKunai = v end })
AntiKickSec:CreateToggle({ Name = "Shuriken Anti Kick", CurrentValue = false, Flag = "ShurikenAntiKick",
    Callback = function(v) Settings.Anti.ShurikenAntiKick = v end })
AntiKickSec:CreateToggle({ Name = "Anti-Kick Kunai", CurrentValue = false, Flag = "AntiKickKunaiToggle",
    Callback = function(v) Settings.Anti.AntiKickKunai = v end })
AntiKickSec:CreateToggle({ Name = "Destroy All Gucci", CurrentValue = false, Flag = "DestroyGucciLoop",
    Callback = function(v) Settings.BlobmanBeta.destroyGucciActive = v end })

local AntiMiscSec = AntiTab:CreateSection("Anti")
AntiMiscSec:CreateToggle({ Name = "Anti Sticky", CurrentValue = false, Flag = "AntiSticky",
    Callback = function(v) Settings.Anti.AntiSticky = v end })
AntiMiscSec:CreateToggle({ Name = "Anti Lag", CurrentValue = false, Flag = "AntiLag",
    Callback = function(v) Settings.Anti.AntiLag = v end })
AntiMiscSec:CreateToggle({ Name = "Anti Gucci (Blobman)", CurrentValue = false, Flag = "AntiGucciBlob",
    Callback = function(v) Settings.Anti.AntiGucciBlobman = v end })
AntiMiscSec:CreateToggle({ Name = "Anti Gucci (Train)", CurrentValue = false, Flag = "AntiGucciTrain",
    Callback = function(v) Settings.Anti.AntiGucciTrain = v end })
AntiMiscSec:CreateToggle({ Name = "Anti Ragdoll", CurrentValue = false, Flag = "AntiRagdoll",
    Callback = function(v) Settings.Anti.AntiRagdoll = v end })
AntiMiscSec:CreateToggle({ Name = "Anti Kill (Hamburger)", CurrentValue = false, Flag = "AntiKillHamburger",
    Callback = function(v) Settings.Anti.AntiKillHamburger = v end })
AntiMiscSec:CreateToggle({ Name = "Anti Ragdoll on Blob", CurrentValue = false, Flag = "AntiRagBlob",
    Callback = function(v) Settings.Anti.AntiRagBlob = v end })
AntiMiscSec:CreateToggle({ Name = "Anti Blobman Kill", CurrentValue = false, Flag = "AntiBlobmanKill",
    Callback = function(v) Settings.Anti.AntiBlobmanKill = v end })
AntiMiscSec:CreateDropdown({
    Name = "Input Lag Toy",
    Options = {"Coconut","Banana","Fries","MeatStick","Poop","Donut","Cake","Burger","Pizza","Hotdog","Mushroom","Banjo","Violin","Ukulele","Sax","Vuvuzela","Bongos","Mic","Pepperoni","Piano","Bread","Egg","Mayo","WhiteMug","Ocarina","SparklePoop","BrownMug","Trumpet","Snare"},
    CurrentOption = {"Coconut"},
    Flag = "AntiInputLagToy",
    Callback = function(option) Settings.Anti.AntiInputLagToy = type(option) == "table" and option[1] or option end,
})
AntiMiscSec:CreateToggle({ Name = "Anti Input Lag", CurrentValue = false, Flag = "AntiInputLag",
    Callback = function(v) Settings.Anti.AntiInputLag = v end })
AntiMiscSec:CreateToggle({ Name = "Anti All Anti Input", CurrentValue = false, Flag = "RemoveAllAntiInput",
    Callback = function(v) Settings.Anti.removeAllAntiInput = v end })
AntiMiscSec:CreateToggle({ Name = "Anti Fire", CurrentValue = false, Flag = "AntiFire",
    Callback = function(v) Settings.Anti.AntiFire = v end })
AntiMiscSec:CreateToggle({ Name = "Anti Explosion", CurrentValue = false, Flag = "AntiExplosion",
    Callback = function(v) Settings.Anti.AntiExplosion = v end })
AntiMiscSec:CreateToggle({ Name = "Anti Void", CurrentValue = false, Flag = "AntiVoid",
    Callback = function(v) Settings.Anti.AntiVoid = v end })
AntiMiscSec:CreateToggle({ Name = "Anti Paint", CurrentValue = false, Flag = "AntiPaint",
    Callback = function(v) Settings.Anti.AntiPaint = v end })
AntiMiscSec:CreateToggle({ Name = "Anti Ownership", CurrentValue = false, Flag = "AntiOwnership",
    Callback = function(v) Settings.Anti.AntiOwnership = v end })
AntiMiscSec:CreateToggle({ Name = "Anti Ownership 2", CurrentValue = false, Flag = "AntiOwnership2",
    Callback = function(v) Settings.Anti.AntiOwnership2 = v end })
AntiMiscSec:CreateToggle({ Name = "Anti Banana Sit", CurrentValue = false, Flag = "AntiBananaSit",
    Callback = function(v) Settings.Anti.AntiBananaSit = v end })

local AntiBlobSec = AntiTab:CreateSection("Other Functions")
local AntiActionDropdown
AntiBlobSec:CreateDropdown({
    Name = "Action",
    Options = {"Delete Legs Local","Delete Right Leg Local","Delete Left Leg Local","Delete Right Arm Local","Delete Left Arm Local","Delete All Local","Delete Legs Grabbed Player","Delete Right Leg Grabbed","Delete Left Leg Grabbed","Delete Right Arm Grabbed","Delete Left Arm Grabbed","Delete All Grabbed"},
    CurrentOption = {"Delete Legs Local"},
    Flag = "AntiAction",
    Callback = function(option) antiSelectedAction = type(option) == "table" and option[1] or option end,
})
AntiBlobSec:CreateButton({ Name = "Delete", Callback = function() end })
AntiBlobSec:CreateButton({ Name = "Fake Korblox Me", Callback = function() end })
AntiBlobSec:CreateButton({ Name = "Anti Gucci Fast", Callback = function() end })
AntiBlobSec:CreateButton({ Name = "Break PCLD", Callback = function() end })

-- ============================================================
-- TAB: Misc
-- ============================================================
local MiscTab = Window:CreateTab({ Title = "Misc", Image = 4483362458 })

local MiscCamSec = MiscTab:CreateSection("Camera")
MiscCamSec:CreateToggle({ Name = "Third Person", CurrentValue = false, Flag = "ThirdPerson",
    Callback = function(v) Settings.Misc.ThirdPerson = v end })
MiscCamSec:CreateToggle({ Name = "FOV Changer", CurrentValue = false, Flag = "FOVChanger",
    Callback = function(v) Settings.Misc.FOVChanger = v end })
MiscCamSec:CreateSlider({ Name = "FOV", Range = {40, 120}, Increment = 1, CurrentValue = 70, Flag = "FOVValue",
    Callback = function(v) Settings.Misc.FOVValue = v end })
MiscCamSec:CreateKeybind({ Name = "Zoom", CurrentKeybind = Enum.KeyCode.Unknown, HoldToInteract = true, Flag = "ZoomBind", Callback = function() end })

local MiscOtherSec = MiscTab:CreateSection("Other")
MiscOtherSec:CreateButton({ Name = "Grabbed Pallet Roblox", Callback = function() end })
MiscOtherSec:CreateToggle({ Name = "Speed Tractor", CurrentValue = false, Flag = "SpeedTractor",
    Callback = function(v) Settings.Misc.speedTractor = v end })
MiscOtherSec:CreateKeybind({ Name = "Tractor Nitro", CurrentKeybind = Enum.KeyCode.Unknown, HoldToInteract = true, Flag = "NitroKey", Callback = function() end })
MiscOtherSec:CreateKeybind({ Name = "Tractor Jump", CurrentKeybind = Enum.KeyCode.Unknown, HoldToInteract = false, Flag = "TractorJumpKey", Callback = function() end })
MiscOtherSec:CreateToggle({ Name = "FPS Booster", CurrentValue = false, Flag = "FPSBooster",
    Callback = function(v) Settings.Misc.FPSBooster = v end })
MiscOtherSec:CreateToggle({ Name = "Mini Map", CurrentValue = false, Flag = "MiniMap",
    Callback = function(v) Settings.Misc.miniMap = v end })
MiscOtherSec:CreateToggle({ Name = "Phantom Pallets", CurrentValue = false, Flag = "PhantomPallets",
    Callback = function(v) Settings.Misc.phantomPallets = v end })
MiscOtherSec:CreateToggle({ Name = "Grabbed Pallet Explore", CurrentValue = false, Flag = "GrabbedPalletExplore",
    Callback = function(v) Settings.Telekinesis.palletExplore = v end })
MiscOtherSec:CreateKeybind({ Name = "Part Object Grab", CurrentKeybind = Enum.KeyCode.Unknown, HoldToInteract = false, Flag = "PalletGodKey", Callback = function() end })
MiscOtherSec:CreateToggle({ Name = "Massless When On", CurrentValue = false, Flag = "MasslessWgenPartObject",
    Callback = function(v) Settings.Grab.MasslessWgenPartObject = v end })
MiscOtherSec:CreateToggle({ Name = "NightMode", CurrentValue = false, Flag = "NightMode", Callback = function(v) end })
MiscOtherSec:CreateToggle({ Name = "Name ESP", CurrentValue = false, Flag = "NameESP",
    Callback = function(v) Settings.Misc.nameESP = v end })
MiscOtherSec:CreateToggle({ Name = "Avatar ESP", CurrentValue = false, Flag = "AvatarESP",
    Callback = function(v) Settings.Misc.avatarESP = v end })
MiscOtherSec:CreateToggle({ Name = "Highlight Objects", CurrentValue = false, Flag = "HighlightObjects",
    Callback = function(v) Settings.Misc.highlightObjects = v end })
MiscOtherSec:CreateToggle({ Name = "Invisibility Beta", CurrentValue = false, Flag = "InvisibilityBeta", Callback = function(v) end })
MiscOtherSec:CreateToggle({ Name = "Reach Gamepass", CurrentValue = false, Flag = "GamepassToggle",
    Callback = function(v) Settings.Misc.gamepass = v end })
MiscOtherSec:CreateToggle({ Name = "PCLD Visual", CurrentValue = false, Flag = "PCLDVisual",
    Callback = function(v) Settings.Misc.pcldVisual = v end })

local MiscKeybindsSec = MiscTab:CreateSection("Keybinds")
MiscKeybindsSec:CreateKeybind({ Name = "PVP SAFE", CurrentKeybind = Enum.KeyCode.Unknown, HoldToInteract = false, Flag = "PvpSafe", Callback = function() end })
MiscKeybindsSec:CreateKeybind({ Name = "Bring Object", CurrentKeybind = Enum.KeyCode.Unknown, HoldToInteract = false, Flag = "BringObject", Callback = function() end })
MiscKeybindsSec:CreateKeybind({ Name = "Bring Player", CurrentKeybind = Enum.KeyCode.Unknown, HoldToInteract = false, Flag = "BringPlayer", Callback = function() end })
MiscKeybindsSec:CreateKeybind({ Name = "Lock Grab", CurrentKeybind = Enum.KeyCode.Unknown, HoldToInteract = false, Flag = "LockGrab", Callback = function() end })
MiscKeybindsSec:CreateKeybind({ Name = "Delete All Lock Grabs", CurrentKeybind = Enum.KeyCode.Unknown, HoldToInteract = false, Flag = "DeleteAllLockGrabs", Callback = function() end })
MiscKeybindsSec:CreateKeybind({ Name = "Stop Velocity", CurrentKeybind = Enum.KeyCode.Unknown, HoldToInteract = false, Flag = "StopVelocity", Callback = function() end })
MiscKeybindsSec:CreateKeybind({ Name = "Throw Bomb", CurrentKeybind = Enum.KeyCode.Unknown, HoldToInteract = false, Flag = "ThrowBomb", Callback = function() end })
MiscKeybindsSec:CreateKeybind({ Name = "Spawn Pallet", CurrentKeybind = Enum.KeyCode.Unknown, HoldToInteract = false, Flag = "SpawnPallet", Callback = function() end })
MiscKeybindsSec:CreateKeybind({ Name = "Spam Dance", CurrentKeybind = Enum.KeyCode.Unknown, HoldToInteract = false, Flag = "SpamDanceKey", Callback = function() end })

local MiscUtilSec = MiscTab:CreateSection("Utilities")
MiscUtilSec:CreateButton({ Name = "Rejoin Current Server", Callback = function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end })
MiscUtilSec:CreateButton({ Name = "Unlock Barrier", Callback = function() end })
MiscUtilSec:CreateButton({ Name = "Unlock Barrier V2 Fast", Callback = function() end })
MiscUtilSec:CreateToggle({ Name = "Barrier Noclip", CurrentValue = false, Flag = "BarrierNoclip",
    Callback = function(v) State.barrierNoclip = v end })

local MiscBringSec = MiscTab:CreateSection("Bring")
local MiscBringDropdown
MiscBringSec:CreateButton({ Name = "Refresh Players",
    Callback = function() pcall(function() MiscBringDropdown:Set(BlobmanBetaFeature.GetPlayerList()) end) end })
MiscBringDropdown = MiscBringSec:CreateDropdown({
    Name = "Select Target",
    Options = BlobmanBetaFeature.GetPlayerList(),
    CurrentOption = {"Select Target"},
    Flag = "MiscBringDropdown",
    Callback = function(option)
        local v = type(option) == "table" and option[1] or option
        local name = v:match("@(.+)$")
        if name then miscBringTarget = name end
    end,
})
MiscBringSec:CreateButton({ Name = "Bring", Callback = function() end })

local MiscViewSec = MiscTab:CreateSection("View")
local MiscViewDropdown
MiscViewSec:CreateButton({ Name = "Refresh Players",
    Callback = function() pcall(function() MiscViewDropdown:Set(BlobmanBetaFeature.GetPlayerList()) end) end })
MiscViewDropdown = MiscViewSec:CreateDropdown({
    Name = "Select Target",
    Options = BlobmanBetaFeature.GetPlayerList(),
    CurrentOption = {"Select Target"},
    Flag = "MiscViewDropdown",
    Callback = function(option)
        local v = type(option) == "table" and option[1] or option
        local name = v:match("@(.+)$")
        if name then viewTarget = name end
    end,
})
MiscViewSec:CreateToggle({ Name = "View", CurrentValue = false, Flag = "MiscView", Callback = function(v) viewEnabled = v end })
MiscViewSec:CreateToggle({ Name = "Camera View", CurrentValue = false, Flag = "MiscCamView", Callback = function(v) camViewEnabled = v end })
MiscViewSec:CreateButton({ Name = "TP", Callback = function() end })
MiscViewSec:CreateToggle({ Name = "Force TP", CurrentValue = false, Flag = "MiscViewForceTP", Callback = function(v) viewForceTP = v end })
MiscViewSec:CreateDropdown({
    Name = "Force TP Side",
    Options = {"Backward","Forward","Left","Right"},
    CurrentOption = {"Backward"},
    Flag = "MiscViewForceSide",
    Callback = function(option) viewForceSide = type(option) == "table" and option[1] or option end,
})
MiscViewSec:CreateSlider({ Name = "Distance", Range = {1, 15}, Increment = 1, CurrentValue = 5, Flag = "MiscViewForceDist",
    Callback = function(v) viewForceDist = v end })
MiscViewSec:CreateDropdown({
    Name = "Select House",
    Options = {"Green","Purple","Blue","Red","Pink"},
    CurrentOption = {"Green"},
    Flag = "MiscViewHouse",
    Callback = function(option) selectedHouse = type(option) == "table" and option[1] or option end,
})
MiscViewSec:CreateButton({ Name = "House TP", Callback = function() end })
MiscViewSec:CreateToggle({ Name = "Force House TP", CurrentValue = false, Flag = "MiscViewHouseForceTP", Callback = function(v) houseForceTPActive = v end })

local MiscFxSec = MiscTab:CreateSection("Effects")
MiscFxSec:CreateToggle({ Name = "Water Splashes", CurrentValue = false, Flag = "WaterSplash",
    Callback = function(v) Settings.Misc.waterSplash = v end })
MiscFxSec:CreateSlider({ Name = "Splash Volume", Range = {1, 100}, Increment = 1, CurrentValue = 50, Flag = "SplashVolume",
    Callback = function(v) Settings.Misc.waterSplashVolume = v end })

local MiscFunSec = MiscTab:CreateSection("Fun")
MiscFunSec:CreateToggle({ Name = "Push Local Player", CurrentValue = false, Flag = "PushLocal",
    Callback = function(v) Settings.Misc.pushLocal = v end })
MiscFunSec:CreateKeybind({ Name = "Push Key", CurrentKeybind = Enum.KeyCode.Unknown, HoldToInteract = false, Flag = "PushKey", Callback = function() end })
MiscFunSec:CreateSlider({ Name = "Push Force", Range = {20, 200}, Increment = 1, CurrentValue = 100, Flag = "PushForce",
    Callback = function(v) Settings.Misc.pushForce = v end })
MiscFunSec:CreateToggle({ Name = "White Ocean", CurrentValue = false, Flag = "WhiteOcean", Callback = function(v) end })
MiscFunSec:CreateDropdown({
    Name = "Clone Fling Object",
    Options = {"Auto","UFO 1","UFO 2","Train","Beach 1","Beach 2","CaveCart"},
    CurrentOption = {"Auto"},
    Flag = "CloneFlingTarget",
    Callback = function(option) Settings.Misc.cloneFlingTarget = type(option) == "table" and option[1] or option end,
})
MiscFunSec:CreateToggle({ Name = "Clone Fling Object", CurrentValue = false, Flag = "CloneFling",
    Callback = function(v) Settings.Misc.cloneFlingActive = v end })
MiscFunSec:CreateToggle({ Name = "Jerk", CurrentValue = false, Flag = "MasturbToggle",
    Callback = function(v) Settings.Misc.masturb = v end })
MiscFunSec:CreateToggle({ Name = "Fake Death", CurrentValue = false, Flag = "FakeDeath",
    Callback = function(v) Settings.Misc.fakeDeath = v end })
MiscFunSec:CreateToggle({ Name = "Coconut Dick", CurrentValue = false, Flag = "CoconutDick",
    Callback = function(v) Settings.Misc.coconutDick = v end })
MiscFunSec:CreateToggle({ Name = "Coconut Boobs", CurrentValue = false, Flag = "CoconutDiggles",
    Callback = function(v) Settings.Misc.coconutDiggles = v end })

local MiscLagSec = MiscTab:CreateSection("Lag")
MiscLagSec:CreateSlider({ Name = "Packet Amount", Range = {10, 5000}, Increment = 10, CurrentValue = 100, Flag = "PacketAmount",
    Callback = function(v) Settings.Misc.packetAmount = v end })
MiscLagSec:CreateToggle({ Name = "Packet Lag", CurrentValue = false, Flag = "PacketLag",
    Callback = function(v) Settings.Misc.packetLag = v end })
MiscLagSec:CreateToggle({ Name = "Lag Server", CurrentValue = false, Flag = "LagServer", Callback = function(v) end })

local MiscHudSec = MiscTab:CreateSection("HUD")
MiscHudSec:CreateToggle({ Name = "FPS Hud", CurrentValue = false, Flag = "FpsHud",
    Callback = function(v) Settings.Misc.fpsHud = v end })
MiscHudSec:CreateToggle({ Name = "Spisok", CurrentValue = false, Flag = "ToyList",
    Callback = function(v) Settings.Misc.toyList = v end })
MiscHudSec:CreateToggle({ Name = "Info Hud", CurrentValue = false, Flag = "InfoHud",
    Callback = function(v) Settings.Misc.infoHud = v end })

local MiscConfigSec = MiscTab:CreateSection("Config")
MiscConfigSec:CreateKeybind({ Name = "Menu Toggle", CurrentKeybind = Enum.KeyCode.M, HoldToInteract = false, Flag = "MenuToggleKey", Callback = function() end })
MiscConfigSec:CreateDropdown({
    Name = "Menu Scale",
    Options = {"50%","75%","100%","150%"},
    CurrentOption = {"100%"},
    Flag = "MenuScale",
    Callback = function() end,
})
MiscConfigSec:CreateToggle({ Name = "Keybind List", CurrentValue = false, Flag = "KeybindListToggle", Callback = function(v) end })
MiscConfigSec:CreateButton({ Name = "Export Config", Callback = function() end })
MiscConfigSec:CreateButton({ Name = "Import Config", Callback = function() end })

-- ============================================================
-- TAB: Telekinesis
-- ============================================================
local TelekinesisTab = Window:CreateTab({ Title = "Telekinesis", Image = 4483362458 })

local TkSec = TelekinesisTab:CreateSection("Telekinesis")
TkSec:CreateToggle({ Name = "Enabled", CurrentValue = false, Flag = "TelekinesisEnabled",
    Callback = function(v) Settings.Telekinesis.Enabled = v end })
TkSec:CreateToggle({ Name = "Grab Toys Fly", CurrentValue = false, Flag = "GrabToysFly",
    Callback = function(v) Settings.Telekinesis.grabToysFly = v end })
TkSec:CreateDropdown({
    Name = "Style",
    Options = {"Circle","Circle Up Down","Square","Heart","Tornado","Infinity","Christmas Tree","Wings"},
    CurrentOption = {"Circle"},
    Flag = "TelekinesisStyle",
    Callback = function(option) Settings.Telekinesis.Style = type(option) == "table" and option[1] or option end,
})
TkSec:CreateSlider({ Name = "Radius", Range = {1, 100}, Increment = 1, CurrentValue = 15, Flag = "TelekinesisRadius",
    Callback = function(v) Settings.Telekinesis.Radius = v end })
TkSec:CreateSlider({ Name = "Height", Range = {1, 100}, Increment = 1, CurrentValue = 5, Flag = "TelekinesisHeight",
    Callback = function(v) Settings.Telekinesis.Height = v end })
TkSec:CreateSlider({ Name = "Tree Height", Range = {1, 100}, Increment = 1, CurrentValue = 20, Flag = "TelekinesisTreeHeight",
    Callback = function(v) Settings.Telekinesis.TreeHeight = v end })
TkSec:CreateSlider({ Name = "Speed", Range = {1, 50}, Increment = 1, CurrentValue = 2, Flag = "TelekinesisSpeed",
    Callback = function(v) Settings.Telekinesis.Speed = v end })
TkSec:CreateToggle({ Name = "CrazyRadius", CurrentValue = false, Flag = "TelekinesisCrazyRadius",
    Callback = function(v) Settings.Telekinesis.crazyRadius = v end })
TkSec:CreateSlider({ Name = "Rotation X", Range = {-180, 180}, Increment = 1, CurrentValue = 0, Flag = "TelekinesisRotX",
    Callback = function(v) Settings.Telekinesis.RotX = v end })
TkSec:CreateSlider({ Name = "Rotation Y", Range = {-180, 180}, Increment = 1, CurrentValue = 0, Flag = "TelekinesisRotY",
    Callback = function(v) Settings.Telekinesis.RotY = v end })
TkSec:CreateSlider({ Name = "Rotation Z", Range = {-180, 180}, Increment = 1, CurrentValue = 0, Flag = "TelekinesisRotZ",
    Callback = function(v) Settings.Telekinesis.RotZ = v end })
TkSec:CreateToggle({ Name = "Look At Me", CurrentValue = false, Flag = "TelekinesisLookAtMe",
    Callback = function(v) Settings.Telekinesis.lookAtMe = v end })
TkSec:CreateKeybind({ Name = "Set Main Part", CurrentKeybind = Enum.KeyCode.Unknown, HoldToInteract = false, Flag = "TkSetMainPart", Callback = function() end })
TkSec:CreateKeybind({ Name = "Reset Main Part", CurrentKeybind = Enum.KeyCode.Unknown, HoldToInteract = false, Flag = "TkResetMainPart", Callback = function() end })

local TkFreezeSec = TelekinesisTab:CreateSection("Freeze Objects")
TkFreezeSec:CreateKeybind({ Name = "Freeze Hold Object", CurrentKeybind = Enum.KeyCode.Unknown, HoldToInteract = false, Flag = "FreezeHoldObject", Callback = function() end })
TkFreezeSec:CreateKeybind({ Name = "Reset Freeze Grabs", CurrentKeybind = Enum.KeyCode.Unknown, HoldToInteract = false, Flag = "ResetFreezeGrabs", Callback = function() end })
TkFreezeSec:CreateKeybind({ Name = "Set Main Part (Freeze)", CurrentKeybind = Enum.KeyCode.Unknown, HoldToInteract = false, Flag = "FreezeSetMainPart", Callback = function() end })
TkFreezeSec:CreateKeybind({ Name = "Reset Main Part (Freeze)", CurrentKeybind = Enum.KeyCode.Unknown, HoldToInteract = false, Flag = "FreezeResetMainPart", Callback = function() end })
TkFreezeSec:CreateToggle({ Name = "Auto Recover", CurrentValue = false, Flag = "FreezeAutoRecover",
    Callback = function(v) Settings.Telekinesis.freezeAutoRecover = v end })
TkFreezeSec:CreateToggle({ Name = "Highlight", CurrentValue = false, Flag = "FreezeHighlight",
    Callback = function(v) Settings.Telekinesis.freezeHighlight = v end })
TkFreezeSec:CreateToggle({ Name = "Look At Main Part", CurrentValue = true, Flag = "FreezeLookAtMain",
    Callback = function(v) Settings.Telekinesis.freezeLookAtMain = v end })
TkFreezeSec:CreateToggle({ Name = "Rotate", CurrentValue = false, Flag = "FreezeRotate", Callback = function(v) freezeRotateEnabled = v end })
TkFreezeSec:CreateSlider({ Name = "Rotate Speed", Range = {0.1, 10}, Increment = 0.1, CurrentValue = 1, Flag = "FreezeRotateSpeed",
    Callback = function(v) freezeRotateSpeed = v end })

local TkControlSec = TelekinesisTab:CreateSection("Control")
TkControlSec:CreateKeybind({ Name = "Control", CurrentKeybind = Enum.KeyCode.Unknown, HoldToInteract = false, Flag = "TelekinesisControl", Callback = function() end })
TkControlSec:CreateToggle({ Name = "Another Camera", CurrentValue = false, Flag = "AnotherCamera",
    Callback = function(v) controlState.anotherCamera = v end })

-- ============================================================
-- TAB: Grab
-- ============================================================
local GrabTab = Window:CreateTab({ Title = "Grab", Image = 4483362458 })

local GrabStrSec = GrabTab:CreateSection("Super Strength")
GrabStrSec:CreateSlider({ Name = "Throw Distance", Range = {300, 40000}, Increment = 100, CurrentValue = Settings.Grab.strength, Flag = "ThrowDistance",
    Callback = function(v) Settings.Grab.strength = v end })
GrabStrSec:CreateToggle({ Name = "Super Strength", CurrentValue = false, Flag = "LaunchTouched",
    Callback = function(v) Settings.Grab.EnableThrowStrength = v end })

local GrabFuncSec = GrabTab:CreateSection("Grabs")
GrabFuncSec:CreateToggle({ Name = "Void Grab", CurrentValue = false, Flag = "VoidGrab",
    Callback = function(v) Settings.Grab.VoidGrab = v end })
GrabFuncSec:CreateToggle({ Name = "Sky Grab", CurrentValue = false, Flag = "SkyGrab",
    Callback = function(v) Settings.Grab.SkyGrab = v end })
GrabFuncSec:CreateToggle({ Name = "Spin Grab", CurrentValue = false, Flag = "SpinGrab",
    Callback = function(v) Settings.Grab.SpinGrab = v end })
GrabFuncSec:CreateToggle({ Name = "Fling Grab", CurrentValue = false, Flag = "FlingGrab",
    Callback = function(v) Settings.Grab.FlingGrab = v end })
GrabFuncSec:CreateToggle({ Name = "Trax Grab", CurrentValue = false, Flag = "TraxGrab",
    Callback = function(v) Settings.Misc.traxGrab = v end })
GrabFuncSec:CreateToggle({ Name = "Physics Grab", CurrentValue = false, Flag = "PhysicsGrab", Callback = function(v) physicsGrabEnabled = v end })
GrabFuncSec:CreateToggle({ Name = "Inf Zoom", CurrentValue = false, Flag = "InfZoom",
    Callback = function(v) Settings.Grab.InfZoom = v end })
GrabFuncSec:CreateToggle({ Name = "Noclip Grab", CurrentValue = false, Flag = "NoclipGrab",
    Callback = function(v) Settings.Grab.NoclipGrab = v end })
GrabFuncSec:CreateToggle({ Name = "Massless Grab", CurrentValue = false, Flag = "MasslessGrab",
    Callback = function(v) Settings.Grab.MasslessGrab = v end })
GrabFuncSec:CreateToggle({ Name = "Massless Grab Toys", CurrentValue = false, Flag = "MasslessGrabToys",
    Callback = function(v) Settings.Grab.MasslessGrabToys = v end })
GrabFuncSec:CreateToggle({ Name = "Massless Grab Players", CurrentValue = false, Flag = "MasslessGrabPlayers",
    Callback = function(v) Settings.Grab.MasslessGrabPlayers = v end })
GrabFuncSec:CreateToggle({ Name = "Perspective Grab", CurrentValue = false, Flag = "PerspGrab",
    Callback = function(v) Settings.Grab.PerspectiveGrab = v end })
GrabFuncSec:CreateSlider({ Name = "Fly Speed", Range = {1, 500}, Increment = 1, CurrentValue = 100, Flag = "PerspGrabSpeed",
    Callback = function(v) Settings.Grab.perspGrabSpeed = v end })

local InfLineSec = GrabTab:CreateSection("Infinity Line")
InfLineSec:CreateToggle({ Name = "Infinity Line", CurrentValue = false, Flag = "InfLineToggle",
    Callback = function(v) Settings.Grab.InfinityLine = v end })
InfLineSec:CreateSlider({ Name = "Max Reach (Cap)", Range = {50, 1000}, Increment = 10, CurrentValue = 500, Flag = "InfLineMax",
    Callback = function(v) Settings.Grab.InfinityLineMax = v end })
InfLineSec:CreateSlider({ Name = "Scroll Speed (x0.01)", Range = {0, 1000}, Increment = 1, CurrentValue = 500, Flag = "InfLineScrollSpeed",
    Callback = function(v) Settings.Grab.InfinityLineScrollSpeed = v / 100 end })
InfLineSec:CreateSlider({ Name = "Smoothness", Range = {2, 30}, Increment = 1, CurrentValue = 14, Flag = "InfLineSmooth",
    Callback = function(v) Settings.Grab.InfinityLineSmooth = v end })
InfLineSec:CreateKeybind({ Name = "Extend (Hold)", CurrentKeybind = Enum.KeyCode.Unknown, HoldToInteract = true, Flag = "InfLineExtendKey",
    Callback = function(held) IL.holdExt = held end })
InfLineSec:CreateKeybind({ Name = "Retract (Hold)", CurrentKeybind = Enum.KeyCode.Unknown, HoldToInteract = true, Flag = "InfLineRetractKey",
    Callback = function(held) IL.holdRet = held end })

-- ============================================================
-- TAB: Loop
-- ============================================================
local LoopTab = Window:CreateTab({ Title = "Loop", Image = 4483362458 })

local LoopSetSec = LoopTab:CreateSection("Settings")
LoopSetSec:CreateToggle({ Name = "Protect Friends", CurrentValue = false, Flag = "LoopProtectFriends",
    Callback = function(v) Settings.Loop.WhitelistFriends = v end })

local LoopBringSec = LoopTab:CreateSection("Bring All")
LoopBringSec:CreateToggle({ Name = "Bring All", CurrentValue = false, Flag = "BringAllToggle",
    Callback = function(v) Settings.Loop.BringAll = v end })

local LoopBlobKillAllSec = LoopTab:CreateSection("Blobman Kill All")
LoopBlobKillAllSec:CreateToggle({ Name = "Kill All", CurrentValue = false, Flag = "BlobmanKillAll",
    Callback = function(v) Settings.BlobmanBeta.blobmanKillAllActive = v end })

local LoopKickAllSec = LoopTab:CreateSection("Blobman Kick All")
LoopKickAllSec:CreateToggle({ Name = "Kick All", CurrentValue = false, Flag = "KickAll",
    Callback = function(v) Settings.BlobmanBeta.kickAllActive = v end })
LoopKickAllSec:CreateToggle({ Name = "Kick All V2", CurrentValue = false, Flag = "KickAllV2Loop",
    Callback = function(v) Settings.BlobmanBeta.kickAllV2Active = v end })

local LoopAuraSec = LoopTab:CreateSection("Blobman Kick Aura")
LoopAuraSec:CreateToggle({ Name = "Kick Aura", CurrentValue = false, Flag = "KickAura",
    Callback = function(v) Settings.BlobmanBeta.kickAuraActive = v end })

-- ============================================================
-- TAB: Aura
-- ============================================================
local AuraTab = Window:CreateTab({ Title = "Aura", Image = 4483362458 })

local AuraSetSec = AuraTab:CreateSection("Aura Settings")
AuraSetSec:CreateSlider({ Name = "Aura Radius", Range = {1, 30}, Increment = 1, CurrentValue = 20, Flag = "AuraRadius",
    Callback = function(v) Settings.Aura.auraRadius = v end })
AuraSetSec:CreateToggle({ Name = "Friend Whitelist", CurrentValue = false, Flag = "AuraFriendWhitelist",
    Callback = function(v) Settings.Aura.auraFriendWhitelist = v end })

local AuraAtkSec = AuraTab:CreateSection("Auras")
AuraAtkSec:CreateToggle({ Name = "Sky Aura", CurrentValue = false, Flag = "SkyAura", Callback = function(v) runningSkyAura = v end })
AuraAtkSec:CreateToggle({ Name = "Fling Aura", CurrentValue = false, Flag = "FlingAura", Callback = function(v) runningFlingAura = v end })
AuraAtkSec:CreateToggle({ Name = "Void Aura", CurrentValue = false, Flag = "VoidAura", Callback = function(v) runningVoidAura = v end })
AuraAtkSec:CreateToggle({ Name = "Spin Aura", CurrentValue = false, Flag = "SpinAura", Callback = function(v) runningSpinAura = v end })
AuraAtkSec:CreateToggle({ Name = "Trax Aura", CurrentValue = false, Flag = "TraxAura", Callback = function(v) traxAuraEnabled = v end })
AuraAtkSec:CreateToggle({ Name = "Freeze Aura", CurrentValue = false, Flag = "FreezeAura", Callback = function(v) runningFreezeAura = v end })
AuraAtkSec:CreateToggle({ Name = "Spin Players Aura", CurrentValue = false, Flag = "SpinPlayersAura", Callback = function(v) runningSpinPlayersAura = v end })
AuraAtkSec:CreateToggle({ Name = "Bring Aura", CurrentValue = false, Flag = "BringAura", Callback = function(v) runningBringAura = v end })
AuraAtkSec:CreateToggle({ Name = "Click Aura", CurrentValue = false, Flag = "ClickAura", Callback = function(v) clickAuraEnabled = v end })
AuraAtkSec:CreateToggle({ Name = "Anti Anti Kick Aura", CurrentValue = false, Flag = "DestroyAntiKickAura", Callback = function(v) runningDestroyAntiKickAura = v end })
AuraAtkSec:CreateToggle({ Name = "Anti Banana Aura", CurrentValue = false, Flag = "AntiBananaAura", Callback = function(v) runningAntiBananaAura = v end })
AuraAtkSec:CreateToggle({ Name = "Anti WD Aura", CurrentValue = false, Flag = "AntiWDAura", Callback = function(v) antiWDAuraEnabled = v end })
AuraAtkSec:CreateToggle({ Name = "Anti Pallet Fling Aura", CurrentValue = false, Flag = "AntiPalletFlingAura", Callback = function(v) antiPalletFlingAuraEnabled = v end })

local AuraForceSec = AuraTab:CreateSection("Settings Auras")
AuraForceSec:CreateToggle({ Name = "Repel Aura", CurrentValue = false, Flag = "RepelAura", Callback = function(v) repelAuraEnabled = v end })
AuraForceSec:CreateSlider({ Name = "Repel Force", Range = {50, 500}, Increment = 10, CurrentValue = 100, Flag = "RepelForce",
    Callback = function(v) Settings.Aura.repelAuraForce = v end })
AuraForceSec:CreateToggle({ Name = "Magnet Aura", CurrentValue = false, Flag = "MagnetAura", Callback = function(v) magnetAuraEnabled = v end })
AuraForceSec:CreateSlider({ Name = "Magnet Range", Range = {20, 200}, Increment = 5, CurrentValue = 50, Flag = "MagnetRange",
    Callback = function(v) Settings.Aura.magnetRange = v end })

-- ============================================================
-- TAB: Player
-- ============================================================
local PlayerTab = Window:CreateTab({ Title = "Player", Image = 4483362458 })

local PlayerMovementSec = PlayerTab:CreateSection("Movement")
PlayerMovementSec:CreateToggle({ Name = "Walkspeed", CurrentValue = false, Flag = "PlayerWalkspeed",
    Callback = function(v) Settings.Player.walkspeed = v end })
PlayerMovementSec:CreateSlider({ Name = "Speed Multiplier", Range = {1, 20}, Increment = 1, CurrentValue = 1, Flag = "PlayerSpeedMulti",
    Callback = function(v) Settings.Player.walkspeedValue = v end })
PlayerMovementSec:CreateToggle({ Name = "Noclip", CurrentValue = false, Flag = "PlayerNoclip",
    Callback = function(v) Settings.Player.noclip = v end })

local PlayerJumpSec = PlayerTab:CreateSection("Jump")
PlayerJumpSec:CreateToggle({ Name = "Infinite Jump", CurrentValue = false, Flag = "PlayerInfJump",
    Callback = function(v) Settings.Player.infiniteJump = v end })
PlayerJumpSec:CreateToggle({ Name = "Jump Power", CurrentValue = false, Flag = "PlayerJumpPower",
    Callback = function(v) Settings.Player.jumpPower = v end })
PlayerJumpSec:CreateSlider({ Name = "Jump Power Value", Range = {20, 200}, Increment = 1, CurrentValue = 50, Flag = "PlayerJumpPowerVal",
    Callback = function(v) Settings.Player.jumpPowerValue = v end })
PlayerJumpSec:CreateToggle({ Name = "Auto wall-climb", CurrentValue = false, Flag = "PlayerWallClimb",
    Callback = function(v) Settings.Player.wallClimb = v end })

local PlayerGravitySec = PlayerTab:CreateSection("Gravity")
PlayerGravitySec:CreateSlider({ Name = "Gravity", Range = {-15, 1000}, Increment = 5, CurrentValue = 100, Flag = "PlayerGravityValue",
    Callback = function(v) Settings.Player.gravityValue = v end })
PlayerGravitySec:CreateToggle({ Name = "Apply Gravity", CurrentValue = false, Flag = "PlayerApplyGravity",
    Callback = function(v) Settings.Player.applyGravity = v end })

local PlayerFlySec = PlayerTab:CreateSection("Fly")
PlayerFlySec:CreateToggle({ Name = "Fly Enabled", CurrentValue = false, Flag = "PlayerFly",
    Callback = function(v) Settings.Player.flyEnabled = v end })
PlayerFlySec:CreateKeybind({ Name = "Fly Key", CurrentKeybind = Enum.KeyCode.Unknown, HoldToInteract = false, Flag = "PlayerFlyKey", Callback = function() end })
PlayerFlySec:CreateSlider({ Name = "Fly Speed", Range = {10, 800}, Increment = 10, CurrentValue = 415, Flag = "PlayerFlySpeed",
    Callback = function(v) Settings.Player.flySpeed = v end })

local PlayerTeleSec = PlayerTab:CreateSection("Teleport")
PlayerTeleSec:CreateToggle({ Name = "Click TP", CurrentValue = false, Flag = "PlayerClickTP",
    Callback = function(v) Settings.Player.clickTP = v end })
PlayerTeleSec:CreateKeybind({ Name = "TP Key", CurrentKeybind = Enum.KeyCode.Unknown, HoldToInteract = true, Flag = "PlayerClickTPKey", Callback = function() end })

local PlayerSpinSec = PlayerTab:CreateSection("Spinbot")
PlayerSpinSec:CreateToggle({ Name = "Spinbot", CurrentValue = false, Flag = "PlayerSpinbot",
    Callback = function(v) spinbotActive = v end })
PlayerSpinSec:CreateSlider({ Name = "Spin Speed", Range = {1, 10000}, Increment = 100, CurrentValue = 10000, Flag = "PlayerSpinSpeed",
    Callback = function(v) Settings.Player.spinbotSpeed = v end })

-- ============================================================
-- Уведомление о загрузке
-- ============================================================
Rayfield:Notify({
    Title = "EndorisFTAP Reborn",
    Content = "GUI loaded on Rayfield!",
    Duration = 6,
    Image = 4483362458,
})

warn("EndorisFTAP Reborn (Rayfield GUI) loaded!")




local function updatePvPCharacter(NewCharacter)
    if not (NewCharacter and NewCharacter:IsDescendantOf(workspace)) then return end
    State.Root = NewCharacter:WaitForChild("HumanoidRootPart", 3)
    if not State.Root then return end
    State.HRPs[State.Root] = nil
end

if LocalPlayer.Character then updatePvPCharacter(LocalPlayer.Character) end
LocalPlayer.CharacterAdded:Connect(updatePvPCharacter)

workspace.DescendantAdded:Connect(function(Descendant)
    if Descendant:IsA("BasePart") and Descendant.Name == "HumanoidRootPart" then
        if Descendant ~= State.Root then State.HRPs[Descendant] = true end
    end
end)
workspace.DescendantRemoving:Connect(function(Descendant)
    if State.HRPs[Descendant] then
        State.HRPs[Descendant] = nil
        if State.LastGrabbedTarget == Descendant then State.LastGrabbedTarget = nil end
    end
end)
for _, Descendant in workspace:GetDescendants() do
    if Descendant:IsA("BasePart") and Descendant.Name == "HumanoidRootPart" then
        if Descendant ~= State.Root then State.HRPs[Descendant] = true end
    end
end




do
    local savedRotCF = nil
    local isLocking = false

    local function isRotateVisible()
        local ok, result = pcall(function()
            local pg = LocalPlayer:FindFirstChild("PlayerGui")
            if not pg then return false end
            local cg = pg:FindFirstChild("ControlsGui")
            if not cg then return false end
            local pf = cg:FindFirstChild("PCFrame")
            if not pf then return false end
            local r = pf:FindFirstChild("Rotate")
            if not r then return false end
            return r.Visible
        end)
        return ok and result or false
    end

    RunService.RenderStepped:Connect(function()
        if not State.CameraInitialized or not State.CameraClone then return end

        local shouldLock = isRotateVisible()

        if shouldLock and not isLocking then
            isLocking = true
            savedRotCF = State.CameraClone.CFrame
        elseif not shouldLock and isLocking then
            isLocking = false
            savedRotCF = nil
        end

        if isLocking and savedRotCF then
            local pos = State.CameraClone.CFrame.Position
            State.CameraClone.CFrame = CFrame.new(pos, pos + savedRotCF.LookVector)
            UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
            return
        end

        if not Settings.PvP.SilentAimEnabled then
            Camera.CFrame = State.CameraClone.CFrame
            return
        end

        if Settings.PvP.SilentAimKeybindMode then
            if not Settings.PvP.SilentAimKeybindHeld then
                Camera.CFrame = State.CameraClone.CFrame
                return
            end
        end

        local TargetCFrame = State.CameraClone.CFrame

        if not workspace:FindFirstChild("GrabParts") then
            local Center = Camera.ViewportSize / 2
            local halfDiag = Center.Magnitude
            local AdjustedStrength = (Settings.PvP.SilentAimStrength / 200) * halfDiag
            local bestDist = math.huge
            local bestTarget = nil
            local bestAimPart = nil
            local bestPriority = math.huge
            local camPos = State.CameraClone.CFrame.Position

            local rayParams = RaycastParams.new()
            rayParams.FilterType = Enum.RaycastFilterType.Exclude
            rayParams.FilterDescendantsInstances = { LocalPlayer.Character }

            local partPriority = {
                ["Right Leg"] = 1, ["Left Leg"] = 1, ["Right Arm"] = 1, ["Left Arm"] = 1,
                ["Torso"] = 2, ["HumanoidRootPart"] = 2,
                ["Head"] = 3,
            }
            local aimParts = {"Head", "Torso", "Right Arm", "Left Arm", "Right Leg", "Left Leg", "HumanoidRootPart"}

            for HRP in pairs(State.HRPs) do
                if HRP and HRP.Parent and HRP:IsDescendantOf(workspace) then
                    local model = HRP.Parent
                    local hum = model:FindFirstChildWhichIsA("Humanoid")
                    if hum and hum.Health > 0 then
                        local screenPos, onScreen = State.CameraClone:WorldToScreenPoint(HRP.Position)
                        if onScreen then
                            local mag = (HRP.Position - camPos).Magnitude
                            if mag <= State.ReachDistance then
                                local screenDist = (Vector2.new(screenPos.X, screenPos.Y) - Center).Magnitude
                                if screenDist <= AdjustedStrength then
                                    local foundPart = nil
                                    local foundPriority = math.huge
                                    local fallbackPart = nil
                                    for _, partName in ipairs(aimParts) do
                                        local part = model:FindFirstChild(partName)
                                        if part and part:IsA("BasePart") then
                                            local dir = (part.Position - camPos)
                                            local rayResult = workspace:Raycast(camPos, dir, rayParams)
                                            if rayResult and rayResult.Instance:IsDescendantOf(model) then
                                                local pri = partPriority[partName] or 2
                                                if pri < foundPriority then
                                                    foundPriority = pri
                                                    foundPart = part
                                                end
                                            elseif not fallbackPart then
                                                fallbackPart = part
                                            end
                                        end
                                    end
                                    if not foundPart and fallbackPart then
                                        foundPart = fallbackPart
                                        foundPriority = partPriority[fallbackPart.Name] or 2
                                    end
                                    if foundPart then
                                        if foundPriority < bestPriority or (foundPriority == bestPriority and screenDist < bestDist) then
                                            bestPriority = foundPriority
                                            bestDist = screenDist
                                            bestTarget = HRP
                                            bestAimPart = foundPart
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end

            if bestTarget and bestAimPart then
                local aimPos = bestAimPart.Position
                if TargetCFrame.LookVector:Dot((aimPos - TargetCFrame.Position).Unit) > 0 then
                    TargetCFrame = CFrame.new(TargetCFrame.Position, aimPos)
                end
            end
        end

        Camera.CFrame = TargetCFrame
    end)

    
    local tbRayParams = RaycastParams.new()
    tbRayParams.FilterType = Enum.RaycastFilterType.Exclude

    RunService.RenderStepped:Connect(function()
        if not Settings.PvP.TriggerbotEnabled then return end
        if workspace:FindFirstChild("GrabParts") then return end

        local myChar = LocalPlayer.Character
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if not myRoot then return end

        local cam = State.CameraClone or workspace.CurrentCamera
        if not cam then return end
        local camCF = cam.CFrame
        local origin = camCF.Position
        local look = camCF.LookVector
        local right = camCF.RightVector
        local up = camCF.UpVector

        tbRayParams.FilterDescendantsInstances = { myChar, workspace.Terrain }

        local hit = nil
        local offsets = {
            look,
            (look + right * 0.02).Unit, (look - right * 0.02).Unit,
            (look + up * 0.02).Unit, (look - up * 0.02).Unit,
            (look + right * 0.04 + up * 0.02).Unit, (look - right * 0.04 + up * 0.02).Unit,
            (look + right * 0.04 - up * 0.02).Unit, (look - right * 0.04 - up * 0.02).Unit,
        }
        for _, d in ipairs(offsets) do
            local r = workspace:Raycast(origin, d * 1000, tbRayParams)
            if r then hit = r break end
        end
        if not hit then return end

        local model = hit.Instance:FindFirstAncestorOfClass("Model")
        if not model or model == myChar then return end
        local hum = model:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then return end
        local root = model:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local hasGamepass = LocalPlayer:FindFirstChild("FartherReach") ~= nil
        if (myRoot.Position - root.Position).Magnitude > (hasGamepass and 30 or 20) then return end

        pcall(function() mouse1press() end)
        pcall(function() mouse1release() end)
    end)
end


local LegitAimFeature = {}
LegitAimFeature.Connection = nil
LegitAimFeature.SelectedLimb = nil

function LegitAimFeature.getNearestPlayer()
    local myRoot = State.Root
    if not myRoot or not myRoot.Parent then
        local char = LocalPlayer.Character
        if char then myRoot = char:FindFirstChild("HumanoidRootPart") end
    end
    if not myRoot or not myRoot.Parent then return nil end
    local nearest = nil
    local bestScore = math.huge
    local cam = workspace.CurrentCamera
    if not cam then return nil end
    local screenCenter = cam.ViewportSize / 2
    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if otherPlayer ~= LocalPlayer then
            if Settings.PvP.LegitAimIgnoreFriends then
                local isFriend = false
                pcall(function() isFriend = LocalPlayer:IsFriendsWith(otherPlayer.UserId) end)
                if isFriend then continue end
            end
            local otherChar = otherPlayer.Character
            if otherChar then
                local otherRoot = otherChar:FindFirstChild("HumanoidRootPart")
                local otherHum = otherChar:FindFirstChildWhichIsA("Humanoid")
                if otherRoot and otherHum and otherHum.Health > 0 then
                    if Settings.PvP.LegitAimVisible then
                        local origin = myRoot.Position
                        local dir = (otherRoot.Position - origin)
                        local rp = RaycastParams.new()
                        rp.FilterType = Enum.RaycastFilterType.Exclude
                        local exclude = {}
                        if LocalPlayer.Character then table.insert(exclude, LocalPlayer.Character) end
                        if otherChar then table.insert(exclude, otherChar) end
                        rp.FilterDescendantsInstances = exclude
                        local ray = workspace:Raycast(origin, dir, rp)
                        if ray then continue end
                    end
                    local score
                    if Settings.PvP.LegitAimMode == "Crosshair" then
                        local screenPos, onScreen = cam:WorldToScreenPoint(otherRoot.Position)
                        local dx = screenPos.X - screenCenter.X
                        local dy = screenPos.Y - screenCenter.Y
                        score = math.sqrt(dx * dx + dy * dy)
                        if not onScreen then
                            score = score + 10000
                        end
                    else
                        score = (myRoot.Position - otherRoot.Position).Magnitude
                    end
                    if score < bestScore then
                        bestScore = score
                        nearest = otherChar
                    end
                end
            end
        end
    end
    if Settings.PvP.LegitAimWorkOnNPC then
        if not LegitAimFeature.npcCache or (tick() - (LegitAimFeature.npcCacheTime or 0)) > 1 then
            LegitAimFeature.npcCache = {}
            LegitAimFeature.npcCacheTime = tick()
            for _, p in ipairs(Players:GetPlayers()) do
                local inv = Workspace:FindFirstChild(p.Name .. "SpawnedInToys")
                if inv then
                    for _, obj in ipairs(inv:GetChildren()) do
                        if obj.Name == "YouDecoy" and obj:IsA("Model") then
                            table.insert(LegitAimFeature.npcCache, obj)
                        end
                    end
                end
            end
            local robloxians = Workspace:FindFirstChild("Robloxians")
            if robloxians then
                for _, obj in ipairs(robloxians:GetChildren()) do
                    if obj:IsA("Model") then
                        table.insert(LegitAimFeature.npcCache, obj)
                    end
                end
            end
        end
        for i = #LegitAimFeature.npcCache, 1, -1 do
            local npc = LegitAimFeature.npcCache[i]
            if not npc.Parent then
                table.remove(LegitAimFeature.npcCache, i)
            else
                local npcRoot = npc:FindFirstChild("HumanoidRootPart")
                    or npc:FindFirstChild("Head")
                    or npc:FindFirstChild("Torso")
                    or npc.PrimaryPart
                if npcRoot and (npcRoot.Position - myRoot.Position).Magnitude < 500 then
                    local score
                    if Settings.PvP.LegitAimMode == "Crosshair" then
                        local screenPos, onScreen = cam:WorldToScreenPoint(npcRoot.Position)
                        local dx = screenPos.X - screenCenter.X
                        local dy = screenPos.Y - screenCenter.Y
                        score = math.sqrt(dx * dx + dy * dy)
                        if not onScreen then score = score + 10000 end
                    else
                        score = (myRoot.Position - npcRoot.Position).Magnitude
                    end
                    if score < bestScore then
                        bestScore = score
                        nearest = npc
                    end
                end
            end
        end
    end
    return nearest
end

function LegitAimFeature.pickLimb(char)
    if not char then return nil end
    local cam = workspace.CurrentCamera
    if not cam then return nil end
    local screenCenter = cam.ViewportSize / 2
    local limbNames = {"Right Arm", "Left Arm", "HumanoidRootPart", "Left Leg", "Right Leg", "Head"}
    local r15Names = {"RightHand", "LeftHand", "HumanoidRootPart", "LeftFoot", "RightFoot", "Head"}
    local weights = {30, 25, 20, 10, 10, 5}
    local limbs = {}
    for i, name in ipairs(limbNames) do
        local part = char:FindFirstChild(name)
        if not part then
            part = char:FindFirstChild(r15Names[i])
        end
        if part then
            table.insert(limbs, {part = part, weight = weights[i]})
        end
    end
    if #limbs == 0 then
        return char:FindFirstChild("HumanoidRootPart")
    end
    if Settings.PvP.LegitAimMode == "Crosshair" then
        local bestLimb = nil
        local bestLimbScore = math.huge
        for _, l in ipairs(limbs) do
            local sp, onScreen = cam:WorldToScreenPoint(l.part.Position)
            local dx = sp.X - screenCenter.X
            local dy = sp.Y - screenCenter.Y
            local s = math.sqrt(dx * dx + dy * dy)
            if not onScreen then s = s + 10000 end
            if s < bestLimbScore then
                bestLimbScore = s
                bestLimb = l.part
            end
        end
        return bestLimb
    else
        local totalWeight = 0
        for _, l in ipairs(limbs) do totalWeight = totalWeight + l.weight end
        local roll = math.random() * totalWeight
        local cumulative = 0
        for _, l in ipairs(limbs) do
            cumulative = cumulative + l.weight
            if roll <= cumulative then
                return l.part
            end
        end
        return limbs[#limbs].part
    end
end

function LegitAimFeature.getAimTarget()
    local char = LegitAimFeature.getNearestPlayer()
    if not char then return nil end
    if not Settings.PvP.LegitAimUnsafe then
        local hitbox = Settings.PvP.LegitAimHitbox or "Body"
        local nameMap = {
            ["Head"] = {"Head"},
            ["Body"] = {"HumanoidRootPart"},
            ["Left Arm"] = {"Left Arm", "LeftHand"},
            ["Right Arm"] = {"Right Arm", "RightHand"},
            ["Left Leg"] = {"Left Leg", "LeftFoot"},
            ["Right Leg"] = {"Right Leg", "RightFoot"},
        }
        local names = nameMap[hitbox] or {"HumanoidRootPart"}
        for _, n in ipairs(names) do
            local part = char:FindFirstChild(n)
            if part then return part end
        end
        return char:FindFirstChild("HumanoidRootPart")
    end
    if LegitAimFeature.SelectedLimb and LegitAimFeature.SelectedLimb.Parent then
        return LegitAimFeature.SelectedLimb
    end
    LegitAimFeature.SelectedLimb = LegitAimFeature.pickLimb(char)
    return LegitAimFeature.SelectedLimb
end

function LegitAimFeature.Start()
    if LegitAimFeature.Connection then return end
    LegitAimFeature.Connection = RunService.RenderStepped:Connect(function()
        if not Settings.PvP.LegitAimEnabled then return end
        if not Settings.PvP.LegitAimHolding then
            LegitAimFeature.SelectedLimb = nil
            return
        end
        local myRoot = State.Root
        if not myRoot or not myRoot.Parent then
            local char = LocalPlayer.Character
            if char then myRoot = char:FindFirstChild("HumanoidRootPart") end
        end
        if not myRoot or not myRoot.Parent then return end
        State.Root = myRoot
        local target = LegitAimFeature.getAimTarget()
        if target then
            local cam = workspace.CurrentCamera
            if not cam then return end
            local camPos = cam.CFrame.Position
            if Settings.PvP.LegitAimSmooth then
                local targetDir = (target.Position - camPos).Unit
                local currentLook = cam.CFrame.LookVector
                local factor = math.min(1, 2.5 / Settings.PvP.LegitAimSmoothness)
                local newLook = (currentLook + (targetDir - currentLook) * factor).Unit
                cam.CFrame = CFrame.lookAt(camPos, camPos + newLook)
            else
                cam.CFrame = CFrame.lookAt(camPos, target.Position)
            end
        end
    end)
end

function LegitAimFeature.Stop()
    if LegitAimFeature.Connection then
        LegitAimFeature.Connection:Disconnect()
        LegitAimFeature.Connection = nil
    end
end

LegitAimFeature.Start()




local GrabFeature = {}

function GrabFeature.onGrabPartAdded_ThrowStrength(model)
    if model.Name ~= "GrabParts" then return end
    if not Settings.Grab.EnableThrowStrength then return end
    task.wait(0.1)
    local grabPart = model:FindFirstChild("GrabPart")
    if not grabPart then return end
    local weld = grabPart:FindFirstChildOfClass("WeldConstraint")
    if not weld or not weld.Part1 then return end
    local partToImpulse = weld.Part1
    if not partToImpulse:IsA("BasePart") then return end
    local conn
    conn = model:GetPropertyChangedSignal("Parent"):Connect(function()
        if not model.Parent then
            local lastInput = UserInputService:GetLastInputType()
            if lastInput == Enum.UserInputType.MouseButton2 or lastInput == Enum.UserInputType.Touch then
                if Settings.Grab.EnableThrowStrength then
                    local impulse = Instance.new("BodyVelocity")
                    impulse.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                    impulse.Velocity = Workspace.CurrentCamera.CFrame.LookVector * Settings.Grab.strength
                    impulse.P = 2000
                    impulse.Parent = partToImpulse
                    Debris:AddItem(impulse, 0.08)
                end
            end
            if conn then conn:Disconnect() end
        end
    end)
end

function GrabFeature.enableStrength()
    Settings.Grab.EnableThrowStrength = true
    if State.connections.strength then State.connections.strength:Disconnect() end
    State.connections.strength = Workspace.ChildAdded:Connect(GrabFeature.onGrabPartAdded_ThrowStrength)
end

function GrabFeature.disableStrength()
    Settings.Grab.EnableThrowStrength = false
    if State.connections.strength then State.connections.strength:Disconnect() State.connections.strength = nil end
end

function GrabFeature.maintainNetworkOwnership(grabModel, grabbedPart)
    if State.GrabMaintainConnections[grabModel] then
        State.GrabMaintainConnections[grabModel]:Disconnect()
        State.GrabMaintainConnections[grabModel] = nil
    end
    local needsContinuous = Settings.Grab.VoidGrab
    if not needsContinuous then return end
    local conn = RunService.Heartbeat:Connect(function()
        if not grabModel.Parent or not grabbedPart.Parent then
            if State.GrabMaintainConnections[grabModel] then
                State.GrabMaintainConnections[grabModel]:Disconnect()
                State.GrabMaintainConnections[grabModel] = nil
            end
            return
        end
        if Settings.Grab.VoidGrab then
            local bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
            bv.Velocity = Vector3.new(0, 12000, 0)
            bv.Parent = grabbedPart
            Debris:AddItem(bv, 1.2)
        end
    end)
    State.GrabMaintainConnections[grabModel] = conn
end

function GrabFeature.onGrabPartsAdded_FTAP(model)
    if model.Name ~= "GrabParts" or not model:IsA("Model") then return end
    local grabPart = model:WaitForChild("GrabPart", 8)
    if not grabPart then return end
    local weld = grabPart:FindFirstChildOfClass("WeldConstraint")
    if not weld or not weld.Part1 then return end
    local grabbedPart = weld.Part1
    if grabbedPart.Anchored then return end

    if Settings.Telekinesis.grabToysFly and Settings.Telekinesis.Enabled then
        local victimChar = grabbedPart.Parent
        local victimPlayer = victimChar and Players:GetPlayerFromCharacter(victimChar)
        if not victimPlayer and victimChar and victimChar:IsA("Model") then
            task.spawn(function()
                local TelekinesisFeature = Settings.Telekinesis._feature
                if TelekinesisFeature then
                    TelekinesisFeature.startOrbit(victimChar, true)
                end
            end)
        end
    end

    local victimChar2 = grabbedPart.Parent
    if not victimChar2 then return end
    local anySpecialEnabled = Settings.Grab.VoidGrab or Settings.Grab.NoclipGrab or Settings.Grab.SkyGrab or Settings.Grab.SpinGrab or Settings.Grab.FlingGrab
    if not anySpecialEnabled then return end
    task.wait(0.07)
    GrabFeature.maintainNetworkOwnership(model, grabbedPart)
    if Settings.Grab.VoidGrab then
        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        bv.Velocity = Vector3.new(0, 14000, 0)
        bv.Parent = grabbedPart
        Debris:AddItem(bv, 1.2)
        task.delay(2.0, function()
            if grabbedPart and grabbedPart.Parent then
                pcall(function() destroyGrabLineEvent:FireServer(grabbedPart) end)
            end
        end)
    end
    if Settings.Grab.SkyGrab then
        task.spawn(function()
            local victimChar = grabbedPart.Parent
            local victimPlayer = victimChar and Players:GetPlayerFromCharacter(victimChar)
            if not victimPlayer then return end
            while Settings.Grab.SkyGrab and model.Parent and grabbedPart.Parent do
                pcall(function()
                    local hrp = victimPlayer.Character and victimPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.AssemblyLinearVelocity = Vector3.new(0, 5000, 0)
                    end
                end)
                task.wait()
            end
        end)
    end
    if Settings.Grab.SpinGrab then
        task.spawn(function()
            local weld = grabPart:FindFirstChildOfClass("WeldConstraint")
            if weld then weld:Destroy() end
            local bp = Instance.new("BodyPosition")
            bp.Name = "_SpinGrabFollow"
            bp.MaxForce = Vector3.one * math.huge
            bp.D = 500
            bp.P = 1e5
            bp.Position = grabbedPart.Position
            bp.Parent = grabbedPart
            local bav = Instance.new("BodyAngularVelocity")
            bav.Name = "_SpinGrabSpin"
            bav.AngularVelocity = Vector3.new(0, 1000, 0)
            bav.MaxTorque = Vector3.one * math.huge
            bav.Parent = grabbedPart
            while Settings.Grab.SpinGrab and model.Parent and grabbedPart.Parent do
                pcall(function()
                    bp.Position = grabPart.Position
                    grabbedPart.AssemblyLinearVelocity = Vector3.zero
                end)
                task.wait()
            end
            pcall(function()
                if bp and bp.Parent then bp:Destroy() end
                if bav and bav.Parent then bav:Destroy() end
            end)
        end)
    end
    if Settings.Grab.FlingGrab then
        pcall(function()
            local bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.one * math.huge
            bv.Velocity = Vector3.new(math.random(-100,100), 200, math.random(-100,100))
            bv.Parent = grabbedPart
            Debris:AddItem(bv, 1)
        end)
    end
end

function GrabFeature.noclipGrab()
    State.noclipRunning = true
    while State.noclipRunning do
        local grabbedThisFrame = {}
        local grabParts = Workspace:FindFirstChild("GrabParts")
        if grabParts then
            for _, gp in ipairs(grabParts:GetChildren()) do
                if gp.Name == "GrabPart" then
                    local weld = gp:FindFirstChildOfClass("WeldConstraint")
                    local part1 = weld and weld.Part1
                    if part1 then
                        local function processPart(p)
                            if p:IsA("BasePart") and not p.Anchored then
                                if State.noclipTrackedParts[p] == nil then
                                    State.noclipTrackedParts[p] = p.CanCollide
                                end
                                p.CanCollide = false
                                grabbedThisFrame[p] = true
                            end
                        end
                        processPart(part1)
                        local model = part1:FindFirstAncestorOfClass("Model")
                        if model and model ~= Workspace then
                            for _, desc in ipairs(model:GetDescendants()) do
                                processPart(desc)
                            end
                        end
                    end
                end
            end
        end
        for part, originalState in pairs(State.noclipTrackedParts) do
            if not grabbedThisFrame[part] then
                if part and part.Parent then
                    part.CanCollide = originalState
                end
                State.noclipTrackedParts[part] = nil
            end
        end
        task.wait()
    end
end

function GrabFeature.stopNoclip()
    State.noclipRunning = false
    if State.loops.noclip then task.cancel(State.loops.noclip) State.loops.noclip = nil end
    for part, originalState in pairs(State.noclipTrackedParts) do
        if part and part.Parent then
            part.CanCollide = originalState
        end
    end
    State.noclipTrackedParts = {}
end

function GrabFeature.toggleNoclip(enabled)
    if enabled then
        if State.loops.noclip then task.cancel(State.loops.noclip) end
        State.loops.noclip = task.spawn(GrabFeature.noclipGrab)
    else
        GrabFeature.stopNoclip()
    end
end

Workspace.ChildAdded:Connect(function(child)
    if child.Name == "GrabParts" then
        task.spawn(function()
            GrabFeature.onGrabPartAdded_ThrowStrength(child)
            GrabFeature.onGrabPartsAdded_FTAP(child)
        end)
    end
end)






local LoopFeature = {}

function LoopFeature.isPlayerInPlot(player)
    local char = player.Character
    if not char then return false end
    return char.Parent ~= Workspace
end

function LoopFeature.IsPlayerInsideSafeZone(player)
    return player:FindFirstChild("InPlot") and player.InPlot.Value
end

function LoopFeature.CheckPlayer(player)
    if player == LocalPlayer then return false end
    if isProtectedPlayer(player.Name) then return false end
    if Settings.Loop.WhitelistFriends then
        local isFriend = false
        pcall(function() isFriend = LocalPlayer:IsFriendsWith(player.UserId) end)
        if isFriend then return false end
    end
    if not player.Character then return false end
    local hum = player.Character:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return false end
    return true
end

function LoopFeature.CheckPlayerVelocity(player)
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    return root and root.AssemblyLinearVelocity.Magnitude or 0
end

function LoopFeature.CheckPlayerBring(player)
    return LoopFeature.CheckPlayer(player)
        and not LoopFeature.IsPlayerInsideSafeZone(player)
        and LoopFeature.CheckPlayerVelocity(player) < 20
end

function LoopFeature.isWhitelisted(player)
    if not Settings.Loop.WhitelistFriends then return false end
    return LocalPlayer:IsFriendsWith(player.UserId)
end

function LoopFeature.setupFreezePart()
    if not State.freezePart then
        State.freezePart = Instance.new("Part")
        State.freezePart.Anchored = true
        State.freezePart.CanCollide = false
        State.freezePart.Transparency = 1
        State.freezePart.Size = Vector3.new(1, 1, 1)
        State.freezePart.Parent = Workspace
    end
end

function LoopFeature.FreezeCam(cframe)
    LoopFeature.setupFreezePart()
    State.freezePart.CFrame = cframe
    Workspace.CurrentCamera.CameraType = Enum.CameraType.Follow
    Workspace.CurrentCamera.CameraSubject = State.freezePart
end

function LoopFeature.unFreezeCam()
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then Workspace.CurrentCamera.CameraSubject = hum end
    Workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
end

function LoopFeature.fixCameraAtCurrentPosition()
    if State.cameraAnchor then return end
    local root = Utility.GetPlayerRootPart()
    if not root then return end
    State.cameraAnchor = Instance.new("Part")
    State.cameraAnchor.Name = "CameraAnchor_KillAll"
    State.cameraAnchor.Anchored = true
    State.cameraAnchor.CanCollide = false
    State.cameraAnchor.Transparency = 1
    State.cameraAnchor.Size = Vector3.new(1, 1, 1)
    State.cameraAnchor.CFrame = CFrame.new(root.Position + Vector3.new(0, 20, 0))
    State.cameraAnchor.Parent = Workspace
    State.originalCameraSubject = Workspace.CurrentCamera.CameraSubject
    Workspace.CurrentCamera.CameraSubject = State.cameraAnchor
end

function LoopFeature.restoreCamera()
    if State.cameraAnchor then
        local camera = Workspace.CurrentCamera
        if camera and State.originalCameraSubject then
            camera.CameraSubject = State.originalCameraSubject
        end
        State.cameraAnchor:Destroy()
        State.cameraAnchor = nil
        State.originalCameraSubject = nil
    end
end

function LoopFeature.startFloating()
    if Settings.Loop.floatConnection then return end
    Settings.Loop.floatConnection = RunService.Stepped:Connect(function()
        if Settings.Loop.BringAll and LocalPlayer.Character then
            for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end)
end

function LoopFeature.stopFloating()
    if Settings.Loop.floatConnection then
        Settings.Loop.floatConnection:Disconnect()
        Settings.Loop.floatConnection = nil
    end
end

function LoopFeature.SNOWshipOnce(part)
    if not part then return false end
    if part:FindFirstChild("PartOwner") and part.PartOwner.Value == LocalPlayer.Name then return true end
    local setOwner = grabEventsFolder:FindFirstChild("SetNetworkOwner")
    local root = Utility.GetPlayerRootPart()
    if setOwner and root then
        setOwner:FireServer(part, CFrame.lookAt(root.Position, part.Position))
    end
    for _ = 1, 5 do
        task.wait()
        if part:FindFirstChild("PartOwner") and part.PartOwner.Value == LocalPlayer.Name then return true end
    end
    return false
end

function LoopFeature.CheckNetworkOwnerShipOnPlayer(player)
    local head = player.Character and player.Character:FindFirstChild("Head")
    return head and head:FindFirstChild("PartOwner") and head.PartOwner.Value == LocalPlayer.Name
end

function LoopFeature.CreateBringBody(targetPart, dest)
    local bp = targetPart:FindFirstChild("BringBody")
    if not bp then
        bp = Instance.new("BodyPosition")
        bp.Name = "BringBody"
        bp.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bp.D = 5000
        bp.P = 1500000
        bp.Parent = targetPart
    end
    bp.Position = typeof(dest) == "CFrame" and dest.Position or dest
end

function LoopFeature.killPlayer(player)
    if isProtectedPlayer(player.Name) then return false end
    local success, err = pcall(function()
        local char = player.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum or hum.Health <= 0 then return end
        grabEventsFolder.SetNetworkOwner:FireServer(root, root.CFrame)
        task.wait(0.1)
        grabEventsFolder.DestroyGrabLine:FireServer(root)
        task.wait(0.1)
        char:BreakJoints()
    end)
    return success
end

function LoopFeature.teleportToPlayer(targetPlayer)
    local now = tick()
    if now - Settings.Loop.LastTeleportTime < Settings.Loop.TeleportCooldown then return false end
    local localRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local targetRoot = targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not localRoot or not targetRoot then return false end
    if not Settings.Loop.OriginalPosition then
        Settings.Loop.OriginalPosition = localRoot.Position
    end
    localRoot.CFrame = CFrame.new(targetRoot.Position + Vector3.new(0, Settings.Loop.TeleportHeight, 0))
    Settings.Loop.LastTeleportTime = now
    return true
end

function LoopFeature.returnToOriginalPosition()
    if not Settings.Loop.OriginalPosition then return end
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root then root.CFrame = CFrame.new(Settings.Loop.OriginalPosition) end
end

function LoopFeature.getRespawnPosition()
    local spawn = Workspace:FindFirstChild("SpawnLocation")
    if spawn then return spawn.Position end
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("SpawnLocation") then return obj.Position end
    end
    return Vector3.new(0, 50, 0)
end

function LoopFeature.sortPlayersByRespawnDistance(players)
    local respawnPos = LoopFeature.getRespawnPosition()
    local list = {}
    for _, player in ipairs(players) do
        local char = player.Character
        if char then
            local root = char:FindFirstChild("HumanoidRootPart")
            if root then
                table.insert(list, { player = player, distance = (root.Position - respawnPos).Magnitude })
            end
        end
    end
    table.sort(list, function(a, b) return a.distance < b.distance end)
    local sorted = {}
    for _, data in ipairs(list) do table.insert(sorted, data.player) end
    return sorted
end

function LoopFeature.stopBringAll()
    Settings.Loop.BringAll = false
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local root = player.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local bp = root:FindFirstChild("BringBody")
                if bp then bp:Destroy() end
            end
        end
    end
    if State.freezePart then State.freezePart:Destroy() State.freezePart = nil end
    LoopFeature.unFreezeCam()
    LoopFeature.stopFloating()
end

function LoopFeature.startBringAll()
    local playerCFrame = Utility.GetPlayerCFrame()
    if not playerCFrame then return end
    local camCFrame = CFrame.lookAt(
        Workspace.CurrentCamera.CFrame.Position + Vector3.new(-15, 15, 0),
        playerCFrame.Position
    )
    Workspace.CurrentCamera.CFrame = camCFrame
    while Settings.Loop.BringAll do
        LoopFeature.FreezeCam(camCFrame)
        for _, player in ipairs(Players:GetPlayers()) do
            if LoopFeature.CheckPlayerBring(player) then
                local root = player.Character:FindFirstChild("HumanoidRootPart")
                local hum = player.Character:FindFirstChildOfClass("Humanoid")
                local ragdolled = hum and hum:FindFirstChild("Ragdolled")
                if root and hum and ragdolled then
                    for _ = 1, 50 do
                        if not Settings.Loop.BringAll then break end
                        LoopFeature.startFloating()
                        LoopFeature.SNOWshipOnce(root)
                        if LoopFeature.CheckNetworkOwnerShipOnPlayer(player) then
                            if not ragdolled.Value
                                and player:DistanceFromCharacter(playerCFrame.Position) > 10 then
                                root.CFrame = playerCFrame
                            end
                            LoopFeature.CreateBringBody(root, playerCFrame)
                            break
                        end
                        task.wait()
                        if root.Position.Y <= -12 then
                            Utility.GetPlayerRootPart().CFrame = CFrame.new(root.Position + Vector3.new(0, 5, -15))
                        else
                            Utility.GetPlayerRootPart().CFrame = CFrame.new(root.Position + Vector3.new(0, -10, -10))
                        end
                    end
                end
            end
        end
        Utility.GetPlayerRootPart().CFrame = CFrame.new(527, 123, -376)
        task.wait()
    end
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local root = player.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local bp = root:FindFirstChild("BringBody")
                if bp then bp:Destroy() end
            end
        end
    end
    if State.freezePart then State.freezePart:Destroy() State.freezePart = nil end
    LoopFeature.unFreezeCam()
    LoopFeature.stopFloating()
    Utility.GetPlayerRootPart().CFrame = playerCFrame
end

function LoopFeature.updatePlayerDropdown()
    local list = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(list, player.DisplayName .. " @" .. player.Name)
        end
    end
    return list
end

function LoopFeature.getSelectedTargetsDisplay()
    local names = {}
    for userId, _ in pairs(Settings.Loop.TargetPlayers) do
        local p = Players:GetPlayerByUserId(userId)
        if p then table.insert(names, p.DisplayName .. " @" .. p.Name) end
    end
    return #names > 0 and table.concat(names, ", ") or "None"
end




local mainAimSec = MainTab:Section({Text = "Aim", Side = "Right"})

mainAimSec:Toggle({Text = "Silent Aim", Flag = "SilentAim", Default = false, Callback = function(v)
    Settings.PvP.SilentAimEnabled = v
    if v and not State.CameraInitialized then
        State.CameraClone = Camera:Clone()
        State.CameraClone.Parent = workspace
        State.CameraClone.Name = "SilentCamera"
        State.CameraClone.CFrame = Camera.CFrame
        workspace.CurrentCamera = State.CameraClone
        State.CameraInitialized = true
    end
end})
mainAimSec:Slider({Text = "Silent", Flag = "SilentAimStrength", Minimum = 1, Maximum = 200, Default = 50, ValueName = "", Callback = function(v)
    Settings.PvP.SilentAimStrength = v
end})
mainAimSec:Toggle({Text = "Silent Keybind", Flag = "SilentAimKeybindMode", Default = false, Callback = function(v)
    Settings.PvP.SilentAimKeybindMode = v
    if not v then Settings.PvP.SilentAimKeybindHeld = false end
end})
mainAimSec:Keybind({Text = "Silent Aim Key", Flag = "SilentAimKeybind", Mode = "Hold", Default = Enum.KeyCode.Unknown, Callback = function(holding)
    Settings.PvP.SilentAimKeybindHeld = holding
end})

mainAimSec:Toggle({Text = "Triggerbot", Flag = "Triggerbot", Default = false, Callback = function(v)
    Settings.PvP.TriggerbotEnabled = v
end})

mainAimSec:Toggle({Text = "Legit Aim", Flag = "LegitAim", Default = false, Callback = function(Value)
    Settings.PvP.LegitAimEnabled = Value
    if not Value then
        Settings.PvP.LegitAimHolding = false
    else
        pcall(function()
            if UserInputService:IsKeyDown(Enum.KeyCode.Q) then
                Settings.PvP.LegitAimHolding = true
            end
        end)
    end
    warn("[LegitAim] Enabled:", Value)
end})

mainAimSec:Keybind({Text = "Legit Aim Key", Flag = "LegitAimKey", Mode = "Hold", Callback = function(holding)
    Settings.PvP.LegitAimHolding = holding
end})

mainAimSec:Dropdown({Text = "Target Mode", Flag = "LegitAimMode", List = {"Closest to Crosshair", "Closest Distance"}, Callback = function(value)
    if value == "Closest to Crosshair" then
        Settings.PvP.LegitAimMode = "Crosshair"
    else
        Settings.PvP.LegitAimMode = "Distance"
    end
end})

mainAimSec:Dropdown({Text = "Hitbox", Flag = "LegitAimHitbox", List = {"Head", "Body", "Left Arm", "Right Arm", "Left Leg", "Right Leg"}, Callback = function(value)
    Settings.PvP.LegitAimHitbox = value
end})

mainAimSec:Toggle({Text = "Only Visible", Flag = "LegitAimVisible", Default = false, Callback = function(value)
    Settings.PvP.LegitAimVisible = value
end})

mainAimSec:Toggle({Text = "Smooth Legit", Flag = "LegitAimSmooth", Default = false, Callback = function(value)
    Settings.PvP.LegitAimSmooth = value
end})

mainAimSec:Slider({Text = "Smoothness", Flag = "LegitAimSmoothness", Minimum = 1, Maximum = 10, Default = 10, ValueName = "", Callback = function(value)
    Settings.PvP.LegitAimSmoothness = value
end})

mainAimSec:Toggle({Text = "Unsafe Mod", Flag = "LegitAimUnsafe", Default = false, Callback = function(value)
    Settings.PvP.LegitAimUnsafe = value
end})

mainAimSec:Toggle({Text = "Ignore Friends", Flag = "LegitAimIgnoreFriends", Default = false, Callback = function(value)
    Settings.PvP.LegitAimIgnoreFriends = value
end})

mainAimSec:Toggle({Text = "Work On NPC", Flag = "LegitAimWorkOnNPC", Default = false, Callback = function(value)
    Settings.PvP.LegitAimWorkOnNPC = value
    if not value then LegitAimFeature.npcCache = nil end
end})




local GrabTab = Window:Tab({Text = "Grab"})
do

local grabStrSec = GrabTab:Section({Text = "Super Strength"})
grabStrSec:Slider({Text = "Throw Distance", Flag = "ThrowDistance", Minimum = 300, Maximum = 40000, Default = Settings.Grab.strength, ValueName = ".", Callback = function(value)
    Settings.Grab.strength = value
end})
grabStrSec:Toggle({Text = "Super Strength", Flag = "LaunchTouched", Default = false, Callback = function(enabled)
    Settings.Grab.EnableThrowStrength = enabled
    if enabled then GrabFeature.enableStrength() else GrabFeature.disableStrength() end
end})

local grabFuncSec = GrabTab:Section({Text = "Grabs", Side = "Right"})
grabFuncSec:Toggle({Text = "Void Grab", Flag = "VoidGrab", Default = false, Callback = function(v) Settings.Grab.VoidGrab = v end})
grabFuncSec:Toggle({Text = "Sky Grab", Flag = "SkyGrab", Default = false, Callback = function(v) Settings.Grab.SkyGrab = v end})
grabFuncSec:Toggle({Text = "Spin Grab", Flag = "SpinGrab", Default = false, Callback = function(v) Settings.Grab.SpinGrab = v end})
grabFuncSec:Toggle({Text = "Fling Grab", Flag = "FlingGrab", Default = false, Callback = function(v) Settings.Grab.FlingGrab = v end})
grabFuncSec:Toggle({Text = "Trax Grab", Flag = "TraxGrab", Default = false, Callback = function(v)
    Settings.Misc.traxGrab = v
    if not v then
        if Settings.Misc.traxGrabThread then task.cancel(Settings.Misc.traxGrabThread) Settings.Misc.traxGrabThread = nil end
        if Settings.Misc.traxGrabConn then Settings.Misc.traxGrabConn:Disconnect() Settings.Misc.traxGrabConn = nil end
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                for _, p in pairs(plr.Character:GetDescendants()) do
                    if p:IsA("BasePart") then
                        p.CanCollide = true
                        local bp = p:FindFirstChild("_TraxBP")
                        if bp then bp:Destroy() end
                        local bg = p:FindFirstChild("_TraxBG")
                        if bg then bg:Destroy() end
                    end
                end
            end
        end
        task.spawn(function()
            local toysFolder = workspace:FindFirstChild(LocalPlayer.Name .. "SpawnedInToys")
            if toysFolder then
                local drum = toysFolder:FindFirstChild("InstrumentDrumSnare")
                if drum then
                    pcall(function() ReplicatedStorage.MenuToys.DestroyToy:FireServer(drum) end)
                    if drum.Parent then drum:Destroy() end
                end
            end
        end)
        return
    end
    Settings.Misc.traxGrabThread = task.spawn(function()
        local SpawnToyRF = ReplicatedStorage:WaitForChild("MenuToys"):WaitForChild("SpawnToyRemoteFunction")

        local function ensureMovers(part)
            if not part or not part.Parent then return nil, nil end
            local bp = part:FindFirstChild("_TraxBP")
            local bg = part:FindFirstChild("_TraxBG")
            if bp and bg then return bp, bg end
            bp = Instance.new("BodyPosition")
            bp.Name = "_TraxBP"
            bp.MaxForce = Vector3.new(1e9, 1e9, 1e9)
            bp.D = 500
            bp.P = 10000
            bp.Parent = part
            bg = Instance.new("BodyGyro")
            bg.Name = "_TraxBG"
            bg.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
            bg.D = 500
            bg.P = 10000
            bg.Parent = part
            return bp, bg
        end

        local function movePartTo(part, targetCF)
            if not part then return end
            local bp, bg = ensureMovers(part)
            if bp and bp.Parent then bp.Position = targetCF.Position end
            if bg and bg.Parent then bg.CFrame = targetCF end
        end

        local skyPos = CFrame.new(0, 800000, 0)
        pcall(function() SpawnToyRF:InvokeServer("InstrumentDrumSnare", skyPos, Vector3.zero) end)

        local drum
        for _ = 1, 100 do
            local inv = workspace:FindFirstChild(LocalPlayer.Name .. "SpawnedInToys")
            if inv then drum = inv:FindFirstChild("InstrumentDrumSnare") end
            if drum then break end
            task.wait()
        end
        if not drum then warn("[Trax Grab] No drum") Settings.Misc.traxGrab = false return end

        local mainPart = drum:FindFirstChild("SoundPart")
        if not mainPart then warn("[Trax Grab] No SoundPart") Settings.Misc.traxGrab = false return end

        mainPart.CanCollide = false
        mainPart.Anchored = false

        local function findGrabbed()
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character then
                    local head = plr.Character:FindFirstChild("Head")
                    if head and head:FindFirstChild("PartOwner") and head.PartOwner.Value == LocalPlayer.Name then
                        return plr
                    end
                end
            end
            return nil
        end

        local ragdollCooldown = 0
        local traxStartTime = tick()
        local traxSwingDistance = 3

        Settings.Misc.traxGrabConn = RunService.Heartbeat:Connect(function(dt)
            if not Settings.Misc.traxGrab then return end
            local myChar = LocalPlayer.Character
            local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if not myRoot then return end

            local elapsed = tick() - traxStartTime
            local swingOffset = (math.sin(elapsed * 4) * 0.5 + 0.5) * traxSwingDistance

            local grabbed = findGrabbed()
            if not grabbed or not grabbed.Character then return end
            local tChar = grabbed.Character
            local tRoot = tChar:FindFirstChild("HumanoidRootPart")
            local tHum = tChar:FindFirstChildOfClass("Humanoid")
            if not tRoot or not tHum or tHum.Health <= 0 then return end

            local ragdolled = tHum:FindFirstChild("Ragdolled")

            if ragdolled and ragdolled.Value == true then
                tChar = grabbed.Character
                tRoot = tChar and tChar:FindFirstChild("HumanoidRootPart")
                local tHead = tChar and tChar:FindFirstChild("Head")
                if not tRoot or not tHead then return end

                for _, p in pairs(tChar:GetDescendants()) do
                    if p:IsA("BasePart") then
                        p.CanCollide = false
                    end
                end

                local baseCF = myRoot.CFrame * CFrame.new(0, 0, -swingOffset)

                movePartTo(tRoot, baseCF * _traxHRPOffset)
                tRoot.AssemblyLinearVelocity = Vector3.zero
                tRoot.AssemblyAngularVelocity = Vector3.zero

                local leftLeg = tChar:FindFirstChild("LeftLeg") or tChar:FindFirstChild("LeftFoot") or tChar:FindFirstChild("Left Leg")
                if leftLeg then movePartTo(leftLeg, baseCF * _traxLLOffset) end

                local rightLeg = tChar:FindFirstChild("RightLeg") or tChar:FindFirstChild("RightFoot") or tChar:FindFirstChild("Right Leg")
                if rightLeg then movePartTo(rightLeg, baseCF * _traxRLOffset) end

                local head = tChar:FindFirstChild("Head")
                if head then
                    local headCF = CFrame.lookAt((tRoot.CFrame * CFrame.new(0, 1.9, -0.2)).Position, myRoot.Position)
                    movePartTo(head, headCF)
                end
            else
                ragdollCooldown = ragdollCooldown - 1
                if ragdollCooldown <= 0 then
                    local tHead = tChar:FindFirstChild("Head")
                    if tHead then
                        mainPart.CFrame = CFrame.new(tHead.Position.X, tHead.Position.Y + 0.2, tHead.Position.Z)
                        mainPart.AssemblyLinearVelocity = Vector3.zero
                        mainPart.AssemblyAngularVelocity = Vector3.new(1000, 1000, 1000)
                        mainPart.CanCollide = true
                    end
                    ragdollCooldown = 3
                end
                if ragdollCooldown == 1 then
                    mainPart.CanCollide = false
                    mainPart.CFrame = skyPos
                    mainPart.AssemblyAngularVelocity = Vector3.zero
                end
            end
        end)
    end)
end})

local physicsGrabEnabled = false
local physicsGrabLoop = nil
local physicsGrabChildConn = nil
grabFuncSec:Toggle({Text = "Physics Grab", Flag = "PhysicsGrab", Default = false, Callback = function(v)
    physicsGrabEnabled = v
    local function applyPhysicsGrab()
        pcall(function()
            local grabParts = workspace:FindFirstChild("GrabParts")
            if grabParts and grabParts:FindFirstChild("DragPart") then
                local dragPart = grabParts.DragPart
                local ao = dragPart:FindFirstChild("AlignOrientation")
                if ao then
                    ao.AlignType = Enum.AlignType.Perpendicular
                    ao.PrimaryAxisOnly = true
                end
            end
        end)
    end
    if v then
        applyPhysicsGrab()
        physicsGrabLoop = RunService.Heartbeat:Connect(function()
            if physicsGrabEnabled then applyPhysicsGrab()
            else physicsGrabLoop:Disconnect() end
        end)
        physicsGrabChildConn = workspace.ChildAdded:Connect(function(child)
            if child.Name == "GrabParts" and physicsGrabEnabled then
                task.wait(0.05)
                applyPhysicsGrab()
            end
        end)
    else
        if physicsGrabLoop then physicsGrabLoop:Disconnect() physicsGrabLoop = nil end
        if physicsGrabChildConn then physicsGrabChildConn:Disconnect() physicsGrabChildConn = nil end
    end
end})

do
    local infZoomValue = 0
    local infZoomConn1, infZoomConn2 = nil, nil
    grabFuncSec:Toggle({Text = "Inf Zoom", Flag = "InfZoom", Default = false, Callback = function(v)
        Settings.Grab.InfZoom = v
        if v then
            infZoomValue = 0
            infZoomConn1 = UserInputService.InputChanged:Connect(function(input)
                if not Settings.Grab.InfZoom then return end
                if input.UserInputType == Enum.UserInputType.MouseWheel then
                    if Workspace:FindFirstChild("GrabParts") then
                        if input.Position.Z ~= 1 then
                            infZoomValue = infZoomValue - 1.5
                        else
                            infZoomValue = infZoomValue + 1.5
                        end
                    else
                        infZoomValue = 0
                    end
                end
            end)
            infZoomConn2 = Workspace.ChildAdded:Connect(function(child)
                if not Settings.Grab.InfZoom then return end
                if child.Name == "GrabParts" then
                    infZoomValue = 0
                    local dragPart = child:WaitForChild("DragPart", 5)
                    local dragAttach = dragPart and dragPart:FindFirstChild("DragAttach")
                    if dragAttach then
                        while child.Parent and task.wait() do
                            if not Settings.Grab.InfZoom then break end
                            dragAttach.Position = Workspace.CurrentCamera.CFrame.LookVector * infZoomValue
                        end
                    end
                end
            end)
        else
            if infZoomConn1 then infZoomConn1:Disconnect() infZoomConn1 = nil end
            if infZoomConn2 then infZoomConn2:Disconnect() infZoomConn2 = nil end
            infZoomValue = 0
        end
    end})
end

grabFuncSec:Toggle({Text = "Noclip Grab", Flag = "NoclipGrab", Default = false, Callback = function(enabled)
    Settings.Grab.NoclipGrab = enabled
    GrabFeature.toggleNoclip(enabled)
end})
grabFuncSec:Toggle({Text = "Massless Grab", Flag = "MasslessGrab", Default = false, Callback = function(v)
    Settings.Grab.MasslessGrab = v
    if v then
        task.spawn(function()
            while Settings.Grab.MasslessGrab do
                local grabParts = workspace:FindFirstChild("GrabParts")
                if grabParts then
                    local isPlayerGrab = false
                    if Settings.Grab.MasslessGrabToys then
                        for _, gp in ipairs(grabParts:GetChildren()) do
                            local weld = gp:FindFirstChildOfClass("WeldConstraint")
                            if weld and weld.Part1 then
                                local part = weld.Part1
                                local char = Players:GetPlayerFromCharacter(part.Parent)
                                if not char then char = Players:GetPlayerFromCharacter(part) end
                                if char and char ~= LocalPlayer then
                                    isPlayerGrab = true
                                    break
                                end
                            end
                        end
                    end
                    if not isPlayerGrab then
                        local dragParts = {grabParts:FindFirstChild("DragPart"), grabParts:FindFirstChild("DragPart1")}
                        for _, dragPart in pairs(dragParts) do
                            if dragPart then
                                local alignOrientation = dragPart:FindFirstChildOfClass("AlignOrientation")
                                if alignOrientation then
                                    alignOrientation.MaxAngularVelocity = math.huge
                                    alignOrientation.MaxTorque = math.huge
                                    alignOrientation.Responsiveness = 9999999999999
                                end
                                local alignPosition = dragPart:FindFirstChildOfClass("AlignPosition")
                                if alignPosition then
                                    alignPosition.MaxAxesForce = Vector3.new(math.huge, math.huge, math.huge)
                                    alignPosition.MaxForce = math.huge
                                    alignPosition.MaxVelocity = math.huge
                                    alignPosition.Responsiveness = 9999999999999
                                end
                            end
                        end
                    end
                end
                task.wait()
            end
            local grabParts = workspace:FindFirstChild("GrabParts")
            if grabParts then
                local dragParts = {grabParts:FindFirstChild("DragPart"), grabParts:FindFirstChild("DragPart1")}
                for _, dragPart in pairs(dragParts) do
                    if dragPart then
                        local myChar = LocalPlayer.Character
                        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
                        if myRoot then
                            myRoot.AssemblyLinearVelocity = dragPart.AssemblyLinearVelocity
                            myRoot.AssemblyAngularVelocity = dragPart.AssemblyAngularVelocity
                        end
                        local ao = dragPart:FindFirstChildOfClass("AlignOrientation")
                        if ao then ao.MaxAngularVelocity = 20000; ao.MaxTorque = 100000; ao.Responsiveness = 40 end
                        local ap = dragPart:FindFirstChildOfClass("AlignPosition")
                        if ap then ap.MaxAxesForce = Vector3.new(100000, 100000, 100000); ap.MaxForce = 100000; ap.MaxVelocity = 20000; ap.Responsiveness = 40 end
                    end
                end
            end
        end)
    end
end})
grabFuncSec:Toggle({Text = "Massless Grab Toys", Flag = "MasslessGrabToys", Default = false, Callback = function(v)
    Settings.Grab.MasslessGrabToys = v
    if v then
        task.spawn(function()
            while Settings.Grab.MasslessGrabToys do
                local grabParts = workspace:FindFirstChild("GrabParts")
                if grabParts then
                    for _, gp in ipairs(grabParts:GetChildren()) do
                        local weld = gp:FindFirstChildOfClass("WeldConstraint")
                        if weld and weld.Part1 then
                            local part = weld.Part1
                            local char = Players:GetPlayerFromCharacter(part.Parent)
                            if not char then char = Players:GetPlayerFromCharacter(part) end
                            if not char or char == LocalPlayer then
                                local dragParts = {grabParts:FindFirstChild("DragPart"), grabParts:FindFirstChild("DragPart1")}
                                for _, dragPart in pairs(dragParts) do
                                    if dragPart then
                                        local alignOrientation = dragPart:FindFirstChildOfClass("AlignOrientation")
                                        if alignOrientation then
                                            alignOrientation.MaxAngularVelocity = math.huge
                                            alignOrientation.MaxTorque = math.huge
                                            alignOrientation.Responsiveness = 9999999999999
                                        end
                                        local alignPosition = dragPart:FindFirstChildOfClass("AlignPosition")
                                        if alignPosition then
                                            alignPosition.MaxAxesForce = Vector3.new(math.huge, math.huge, math.huge)
                                            alignPosition.MaxForce = math.huge
                                            alignPosition.MaxVelocity = math.huge
                                            alignPosition.Responsiveness = 9999999999999
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                task.wait()
            end
            local grabParts = workspace:FindFirstChild("GrabParts")
            if grabParts then
                local dragParts = {grabParts:FindFirstChild("DragPart"), grabParts:FindFirstChild("DragPart1")}
                for _, dragPart in pairs(dragParts) do
                    if dragPart then
                        local myChar = LocalPlayer.Character
                        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
                        if myRoot then
                            myRoot.AssemblyLinearVelocity = dragPart.AssemblyLinearVelocity
                            myRoot.AssemblyAngularVelocity = dragPart.AssemblyAngularVelocity
                        end
                        local ao = dragPart:FindFirstChildOfClass("AlignOrientation")
                        if ao then ao.MaxAngularVelocity = 20000; ao.MaxTorque = 100000; ao.Responsiveness = 40 end
                        local ap = dragPart:FindFirstChildOfClass("AlignPosition")
                        if ap then ap.MaxAxesForce = Vector3.new(100000, 100000, 100000); ap.MaxForce = 100000; ap.MaxVelocity = 20000; ap.Responsiveness = 40 end
                    end
                end
            end
        end)
    end
end})

grabFuncSec:Toggle({Text = "Massless Grab Players", Flag = "MasslessGrabPlayers", Default = false, Callback = function(v)
    Settings.Grab.MasslessGrabPlayers = v
    if v then
        task.spawn(function()
            while Settings.Grab.MasslessGrabPlayers do
                local grabParts = workspace:FindFirstChild("GrabParts")
                if grabParts then
                    for _, gp in ipairs(grabParts:GetChildren()) do
                        local weld = gp:FindFirstChildOfClass("WeldConstraint")
                        if weld and weld.Part1 then
                            local part = weld.Part1
                            local char = Players:GetPlayerFromCharacter(part.Parent)
                            if not char then char = Players:GetPlayerFromCharacter(part) end
                            if char and char ~= LocalPlayer then
                                local dragParts = {grabParts:FindFirstChild("DragPart"), grabParts:FindFirstChild("DragPart1")}
                                for _, dragPart in pairs(dragParts) do
                                    if dragPart then
                                        local alignOrientation = dragPart:FindFirstChildOfClass("AlignOrientation")
                                        if alignOrientation then
                                            alignOrientation.MaxAngularVelocity = math.huge
                                            alignOrientation.MaxTorque = math.huge
                                            alignOrientation.Responsiveness = 9999999999999
                                        end
                                        local alignPosition = dragPart:FindFirstChildOfClass("AlignPosition")
                                        if alignPosition then
                                            alignPosition.MaxAxesForce = Vector3.new(math.huge, math.huge, math.huge)
                                            alignPosition.MaxForce = math.huge
                                            alignPosition.MaxVelocity = math.huge
                                            alignPosition.Responsiveness = 9999999999999
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                task.wait()
            end
            local grabParts = workspace:FindFirstChild("GrabParts")
            if grabParts then
                local dragParts = {grabParts:FindFirstChild("DragPart"), grabParts:FindFirstChild("DragPart1")}
                for _, dragPart in pairs(dragParts) do
                    if dragPart then
                        local ao = dragPart:FindFirstChildOfClass("AlignOrientation")
                        if ao then ao.MaxAngularVelocity = 20000; ao.MaxTorque = 100000; ao.Responsiveness = 40 end
                        local ap = dragPart:FindFirstChildOfClass("AlignPosition")
                        if ap then ap.MaxAxesForce = Vector3.new(100000, 100000, 100000); ap.MaxForce = 100000; ap.MaxVelocity = 20000; ap.Responsiveness = 40 end
                    end
                end
            end
        end)
    end
end})

do
    local perspGrabActive = false
    local perspCamFrozen = false
    local perspFlyConns = {}
    local perspWatcherConns = {}
    local perspGrabCFrame = CFrame.new(-542.4857177734375, 42.70832824707031, 649.2499389648438)
    local perspInvisLine = false

    local function disconnectFly()
        for _, conn in ipairs(perspFlyConns) do
            pcall(function() conn:Disconnect() end)
        end
        perspFlyConns = {}
    end

    local function startPerspective()
        if perspGrabActive then return end
        perspGrabActive = true
        perspCamFrozen = false

        local myChar = LocalPlayer.Character
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if not myRoot then perspGrabActive = false return end

        local cam = Workspace.CurrentCamera
        local savedCFrame = cam.CFrame
        local camPos = savedCFrame.Position

        cam.CameraType = Enum.CameraType.Scriptable
        cam.CFrame = savedCFrame
        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter

        perspInvisLine = true
        task.spawn(function()
            while perspInvisLine and perspGrabActive do
                pcall(function()
                    local GE = ReplicatedStorage:FindFirstChild("GrabEvents")
                    if GE then GE.CreateGrabLine:FireServer() end
                end)
                task.wait()
            end
        end)

        local anchorConn
        anchorConn = RunService.RenderStepped:Connect(function()
            if not Settings.Grab.PerspectiveGrab or not perspGrabActive then
                if anchorConn then anchorConn:Disconnect() end
                return
            end
            local mc = LocalPlayer.Character
            local mr = mc and mc:FindFirstChild("HumanoidRootPart")
            if mr then
                mr.CFrame = CFrame.new(543.718505859375, 62.52426528930664, -227.75473022460938)
                mr.AssemblyLinearVelocity = Vector3.zero
                mr.AssemblyAngularVelocity = Vector3.zero
            end
        end)
        table.insert(perspFlyConns, anchorConn)

        local keysDown = {}
        local lookStart = savedCFrame - savedCFrame.Position
        local pitchInit, yawInit, _ = lookStart:ToEulerAnglesYXZ()
        local yaw, pitch = yawInit, pitchInit

        table.insert(perspFlyConns, RunService.RenderStepped:Connect(function(dt)
            if not Settings.Grab.PerspectiveGrab or not perspGrabActive then return end
            local look = CFrame.Angles(0, yaw, 0) * CFrame.Angles(pitch, 0, 0)
            local cf = CFrame.new(camPos) * look
            local speed = Settings.Grab.perspGrabSpeed or 100
            local move = Vector3.zero
            if keysDown[Enum.KeyCode.W] then move = move + cf.LookVector end
            if keysDown[Enum.KeyCode.S] then move = move - cf.LookVector end
            if keysDown[Enum.KeyCode.A] then move = move - cf.RightVector end
            if keysDown[Enum.KeyCode.D] then move = move + cf.RightVector end
            if keysDown[Enum.KeyCode.Space] then move = move + Vector3.new(0, 1, 0) end
            if keysDown[Enum.KeyCode.LeftShift] then move = move - Vector3.new(0, 1, 0) end
            if move.Magnitude > 0 then
                camPos = camPos + move.Unit * speed * dt
            end
            Workspace.CurrentCamera.CFrame = CFrame.new(camPos) * look
        end))

        table.insert(perspFlyConns, UserInputService.InputBegan:Connect(function(input, gpe)
            if input.KeyCode == Enum.KeyCode.R then
                perspCamFrozen = not perspCamFrozen
                return
            end
            if gpe then return end
            keysDown[input.KeyCode] = true
        end))

        table.insert(perspFlyConns, UserInputService.InputEnded:Connect(function(input)
            keysDown[input.KeyCode] = nil
        end))

        table.insert(perspFlyConns, UserInputService.InputChanged:Connect(function(input)
            if perspCamFrozen then return end
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input.Delta
                yaw = yaw - delta.X * UserInputService.MouseDeltaSensitivity * 0.006
                pitch = math.clamp(pitch - delta.Y * UserInputService.MouseDeltaSensitivity * 0.006, -math.pi/2 + 0.01, math.pi/2 - 0.01)
            end
        end))
    end

    local function stopPerspective()
        if not perspGrabActive then return end
        perspGrabActive = false
        perspCamFrozen = false
        perspInvisLine = false
        disconnectFly()
        local myChar = LocalPlayer.Character
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
        local cam = Workspace.CurrentCamera
        if myRoot then
            myRoot.Anchored = false
            myRoot.CFrame = cam.CFrame
        end
        cam.CameraType = Enum.CameraType.Custom
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
    end

    grabFuncSec:Toggle({Text = "Perspective Grab", Flag = "PerspGrab", Default = false, Callback = function(v)
        Settings.Grab.PerspectiveGrab = v
        if not v then
            for _, conn in ipairs(perspWatcherConns) do
                pcall(function() conn:Disconnect() end)
            end
            perspWatcherConns = {}
            stopPerspective()
            return
        end

        table.insert(perspWatcherConns, Workspace.ChildAdded:Connect(function(child)
            if not Settings.Grab.PerspectiveGrab then return end
            if child.Name == "GrabParts" then
                startPerspective()
            end
        end))

        table.insert(perspWatcherConns, Workspace.ChildRemoved:Connect(function(child)
            if not Settings.Grab.PerspectiveGrab then return end
            if child.Name == "GrabParts" then
                stopPerspective()
            end
        end))

        if Workspace:FindFirstChild("GrabParts") then
            startPerspective()
        end
    end})

    grabFuncSec:Slider({Text = "Fly Speed", Flag = "PerspGrabSpeed", Minimum = 1, Maximum = 500, Default = 100, ValueName = "speed", Callback = function(v)
        Settings.Grab.perspGrabSpeed = v
    end})
end

end




local LoopTab = Window:Tab({Text = "Loop"})
do

local loopSetSec = LoopTab:Section({Text = "Settings"})
loopSetSec:Toggle({Text = "Protect Friends", Flag = "LoopProtectFriends", Default = false, Callback = function(v)
    Settings.Loop.WhitelistFriends = v
end})

local loopBringSec = LoopTab:Section({Text = "Bring All", Side = "Right"})
loopBringSec:Toggle({Text = "Bring All", Flag = "BringAllToggle", Default = false, Callback = function(state)
    Settings.Loop.BringAll = state
    if state then
        LoopFeature.restoreCamera()
        coroutine.wrap(LoopFeature.startBringAll)()
    else
        LoopFeature.stopBringAll()
    end
end})

local loopBlobKillAllSec = LoopTab:Section({Text = "Blobman Kill All"})
loopBlobKillAllSec:Toggle({Text = "Kill All", Flag = "BlobmanKillAll", Default = false, Callback = function(v)
    Settings.BlobmanBeta.blobmanKillAllActive = v
    if v then
        task.spawn(function()
            local blob = BlobmanBetaFeature.getBlobman()
                or BlobmanBetaFeature.findAnyBlobman()
                or BlobmanBetaFeature.spawnBlobman()
            if not blob or not blob:FindFirstChild("VehicleSeat") then
                warn("No blobman") Settings.BlobmanBeta.blobmanKillAllActive = false return
            end

            if not BlobmanBetaFeature.isSittingOnBlobman() then
                local myRoot = BlobmanBetaFeature.getLocalRoot()
                local hum = BlobmanBetaFeature.getLocalHum()
                if myRoot and hum then
                    myRoot.CFrame = blob.VehicleSeat.CFrame + Vector3.new(0, 2, 0)
                    task.wait(0.05)
                    blob.VehicleSeat:Sit(hum)
                    task.wait(0.1)
                end
                if not BlobmanBetaFeature.isSittingOnBlobman() then
                    warn("Failed to sit") Settings.BlobmanBeta.blobmanKillAllActive = false return
                end
            end

            local MyBlob = BlobmanBetaFeature.getBlobman()
            if not MyBlob then Settings.BlobmanBeta.blobmanKillAllActive = false return end

            local safePos = MyBlob.VehicleSeat.CFrame

            while Settings.BlobmanBeta.blobmanKillAllActive and task.wait() do
                local mychar = LocalPlayer.Character
                local myHRP = mychar and mychar:FindFirstChild("HumanoidRootPart")
                local myhum = mychar and mychar:FindFirstChildOfClass("Humanoid")
                if not (myhum and myHRP) then continue end
                if not BlobmanBetaFeature.isSittingOnBlobman() then
                    local seat = MyBlob and MyBlob:FindFirstChild("VehicleSeat")
                    if seat then
                        myHRP.CFrame = seat.CFrame + Vector3.new(0, 2, 0)
                        task.wait(0.05)
                        seat:Sit(myhum)
                        task.wait(0.1)
                    end
                    if not BlobmanBetaFeature.isSittingOnBlobman() then continue end
                end
                MyBlob = BlobmanBetaFeature.getBlobman()
                if not MyBlob then continue end

                for _, ct in ipairs(Players:GetPlayers()) do
                    if ct == LocalPlayer then continue end
                    if isProtectedPlayer(ct.Name) then continue end
                    if Settings.BlobmanBeta.ignoreFriends or Settings.Loop.WhitelistFriends then
                        local isFriend = false
                        pcall(function() isFriend = LocalPlayer:IsFriendsWith(ct.UserId) end)
                        if isFriend then continue end
                    end
                    if not Settings.BlobmanBeta.blobmanKillAllActive then break end
                    local ctChar = ct.Character
                    if not ctChar then continue end
                    local hum = ctChar:FindFirstChildOfClass("Humanoid")
                    local HRP = ctChar:FindFirstChild("HumanoidRootPart")
                    if not (hum and HRP and hum.Health > 0) then continue end

                    hum.BreakJointsOnDeath = false
                    hum.WalkSpeed = 0
                    hum.JumpPower = 0

                    local LD = MyBlob:FindFirstChild("LeftDetector")
                    local LW = LD and LD:FindFirstChild("LeftWeld")
                    if not (LD and LW) then continue end

                    local savedPos = myHRP.CFrame
                    myHRP.CFrame = HRP.CFrame
                    task.wait(0.03)
                    if hum.SeatPart == nil then
                        if hum.RigType ~= Enum.HumanoidRigType.R15 then
                            hum.RigType = Enum.HumanoidRigType.R15
                        end
                        if hum.RigType ~= Enum.HumanoidRigType.R6 then
                            hum.RigType = Enum.HumanoidRigType.R6
                        end
                        if hum.RigType ~= Enum.HumanoidRigType.R15 then
                            hum.RigType = Enum.HumanoidRigType.R15
                        end
                    end
                    task.wait()
                    for i = 1, 4 do
                        blobKickAction(MyBlob, HRP, "Left", "Default")
                        task.wait(0.05)
                        blobKickAction(MyBlob, HRP, "Left", "Release")
                    end
                    hum.Health = 0
                    for i = 1, 4 do
                        blobKickAction(MyBlob, HRP, "Left", "Default")
                        task.wait(0.05)
                        blobKickAction(MyBlob, HRP, "Left", "Release")
                    end
                    myHRP.CFrame = savedPos
                end

                MyBlob = BlobmanBetaFeature.getBlobman()
                if MyBlob then
                    MyBlob.VehicleSeat.CFrame = safePos
                    for _, p in ipairs(MyBlob:GetDescendants()) do
                        if p:IsA("BasePart") then
                            p.AssemblyLinearVelocity = Vector3.zero
                            p.AssemblyAngularVelocity = Vector3.zero
                        end
                    end
                end
                task.wait(0.3)
            end
        end)
    end
end})

local loopKickAllSec = LoopTab:Section({Text = "Blobman Kick All", Side = "Right"})
loopKickAllSec:Toggle({Text = "Kick All", Flag = "KickAll", Default = false, Callback = function(v)
    Settings.BlobmanBeta.kickAllActive = v
    if v then
        task.spawn(function()
            local blob = BlobmanBetaFeature.getBlobman()
                or BlobmanBetaFeature.findAnyBlobman()
                or BlobmanBetaFeature.spawnBlobman()
            if not blob or not blob:FindFirstChild("VehicleSeat") then
                warn("No blobman") Settings.BlobmanBeta.kickAllActive = false return
            end

            local myChar = LocalPlayer.Character
            local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
            local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
            if not myHRP or not myHum then Settings.BlobmanBeta.kickAllActive = false return end

            local seat = blob.VehicleSeat
            if not myHum.Sit or myHum.SeatPart ~= seat then
                if seat.Occupant and seat.Occupant ~= myHum then
                    pcall(function() seat.Occupant.Jump = true end)
                    task.wait(0.1)
                end
                local sitStart = tick()
                while tick() - sitStart < 0.5 do
                    if not blob or not blob.Parent then break end
                    myHRP.CFrame = seat.CFrame + Vector3.new(0, 2, 0)
                    task.wait(0.03)
                    seat:Sit(myHum)
                    task.wait(0.05)
                    if myHum.Sit and myHum.SeatPart == seat then break end
                end
            end

            while Settings.BlobmanBeta.kickAllActive do
                if not BlobmanBetaFeature.isSittingOnBlobman() then
                    local s = blob and blob:FindFirstChild("VehicleSeat")
                    if not s then task.wait(0.1) continue end
                    local r = BlobmanBetaFeature.getLocalRoot()
                    local h = BlobmanBetaFeature.getLocalHum()
                    if r and h then
                        if s.Occupant and s.Occupant ~= h then
                            pcall(function() s.Occupant.Jump = true end)
                            task.wait(0.1)
                        end
                        r.CFrame = s.CFrame + Vector3.new(0, 2, 0)
                        task.wait(0.05)
                        s:Sit(h)
                        task.wait(0.1)
                    end
                    if not BlobmanBetaFeature.isSittingOnBlobman() then
                        task.wait(0.1)
                        continue
                    end
                end
                local targets = {}
                for _, plr in Players:GetPlayers() do
                    if plr == LocalPlayer then continue end
                    if not BlobmanBetaFeature.isValidTarget(plr) then continue end
                    local char = plr.Character
                    if not char then continue end
                    local root = char:FindFirstChild("HumanoidRootPart")
                    if not root then continue end
                    table.insert(targets, {plr = plr, root = root})
                end
                local blobPos = blob.VehicleSeat.Position
                table.sort(targets, function(a, b)
                    return (a.root.Position - blobPos).Magnitude < (b.root.Position - blobPos).Magnitude
                end)
                for _, t in ipairs(targets) do
                    if not Settings.BlobmanBeta.kickAllActive then break end
                    if not BlobmanBetaFeature.isSittingOnBlobman() then
                        local seat = blob and blob:FindFirstChild("VehicleSeat")
                        if not seat then break end
                        local myRoot = BlobmanBetaFeature.getLocalRoot()
                        local hum = BlobmanBetaFeature.getLocalHum()
                        if myRoot and hum then
                            myRoot.CFrame = seat.CFrame + Vector3.new(0, 2, 0)
                            task.wait(0.05)
                            seat:Sit(hum)
                            task.wait(0.1)
                        end
                        if not BlobmanBetaFeature.isSittingOnBlobman() then break end
                    end
                    local myRoot = BlobmanBetaFeature.getLocalRoot()
                    if myRoot and t.root then
                        if (t.root.Position - myRoot.Position).Magnitude > 500000 then continue end
                        myRoot.CFrame = t.root.CFrame
                        task.wait(0.03)
                        BlobmanBetaFeature.blobKick(blob, t.root, Settings.BlobmanBeta.currentSide)
                        task.wait(0.03)
                        BlobmanBetaFeature.ungrab(myRoot)
                        task.wait(0.03)
                        myRoot.CFrame = blob.VehicleSeat.CFrame + Vector3.new(0, 2, 0)
                        task.wait(0.03)
                        local hum = BlobmanBetaFeature.getLocalHum()
                        if hum and blob:FindFirstChild("VehicleSeat") then
                            blob.VehicleSeat:Sit(hum)
                            task.wait(0.05)
                        end
                    end
                end
                task.wait(0.05)
            end
        end)
    end
end})

loopKickAllSec:Toggle({Text = "Kick All V2", Flag = "KickAllV2Loop", Default = false, Callback = function(v)
    Settings.BlobmanBeta.kickAllV2Active = v
    if v then
        task.spawn(function()
            local myChar = LocalPlayer.Character
            local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
            local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
            if not myHRP or not myHum then Settings.BlobmanBeta.kickAllV2Active = false return end

            local blob = BlobmanBetaFeature.getBlobman()
                or BlobmanBetaFeature.findAnyBlobman()
                or BlobmanBetaFeature.spawnBlobman()
            if not blob or not blob:FindFirstChild("VehicleSeat") then
                Settings.BlobmanBeta.kickAllV2Active = false return
            end

            local seat = blob.VehicleSeat
            if not myHum.Sit or myHum.SeatPart ~= seat then
                if seat.Occupant and seat.Occupant ~= myHum then
                    pcall(function() seat.Occupant.Jump = true end)
                    task.wait(0.1)
                end
                local sitStart = tick()
                while tick() - sitStart < 0.5 do
                    if not blob or not blob.Parent then break end
                    myHRP.CFrame = seat.CFrame + Vector3.new(0, 2, 0)
                    pcall(function() seat:Sit(myHum) end)
                    if myHum.Sit and myHum.SeatPart == seat then break end
                    task.wait(0.03)
                end
            end
            if not (myHum.Sit and myHum.SeatPart and myHum.SeatPart.Parent and myHum.SeatPart.Parent.Name == "CreatureBlobman") then
                Settings.BlobmanBeta.kickAllV2Active = false return
            end

            local MyBlob = myHum.SeatPart.Parent
            local scr = MyBlob:FindFirstChild("BlobmanSeatAndOwnerScript") or MyBlob:FindFirstChild("BlobmanSeatAndOwnerScript[old]")
            local CreatureGrab = scr and scr:FindFirstChild("CreatureGrab")
            local CreatureRelease = scr and scr:FindFirstChild("CreatureRelease")

            local allPlayers = {}
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and not isProtectedPlayer(p.Name) then
                    if Settings.BlobmanBeta.ignoreFriends or Settings.Loop.WhitelistFriends then
                        local isFriend = false
                        pcall(function() isFriend = LocalPlayer:IsFriendsWith(p.UserId) end)
                        if isFriend then continue end
                    end
                    local tChar = p.Character
                    local tRoot = tChar and tChar:FindFirstChild("HumanoidRootPart")
                    local tHum = tChar and tChar:FindFirstChildOfClass("Humanoid")
                    if tRoot and tHum and tHum.Health > 0 then
                        table.insert(allPlayers, p)
                    end
                end
            end
            if #allPlayers == 0 then Settings.BlobmanBeta.kickAllV2Active = false return end

            for _, targetPlayer in ipairs(allPlayers) do
                local targetRoot = targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                if targetRoot then
                    myHRP.CFrame = targetRoot.CFrame
                    task.wait(0.02)
                    for i = 1, 3 do
                        pcall(function()
                            CreatureGrab:FireServer(MyBlob.LeftDetector, targetRoot, MyBlob.LeftDetector.LeftWeld)
                            CreatureRelease:FireServer(MyBlob.LeftDetector.LeftWeld)
                        end)
                        if i < 3 then task.wait(0.08) end
                    end
                end
            end

            myHRP.CFrame = CFrame.new(0, 100, 0)
            task.wait(0.1)
            for _, part in ipairs(MyBlob:GetDescendants()) do
                if part:IsA("BasePart") then pcall(function() part.Anchored = true end) end
            end
            task.wait(0.1)

            local radius = 15
            for i, targetPlayer in ipairs(allPlayers) do
                local targetRoot = targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                if targetRoot then
                    local angle = math.rad((i - 1) * (360 / #allPlayers))
                    local x = radius * math.cos(angle)
                    local z = radius * math.sin(angle)
                    targetRoot.CFrame = CFrame.new(x, 110, z)
                end
            end
            task.wait(0.1)

            for _ = 1, 2 do
                for _, targetPlayer in ipairs(allPlayers) do
                    local targetRoot = targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if targetRoot then
                        pcall(function()
                            setNetworkOwnerEvent:FireServer(targetRoot, CFrame.new(targetRoot.Position))
                            destroyGrabLineEvent:FireServer(targetRoot)
                        end)
                    end
                end
                task.wait(0.1)
            end
            task.wait(0.3)

            local LeftDetector = MyBlob:FindFirstChild("LeftDetector")
            local RightDetector = MyBlob:FindFirstChild("RightDetector")
            for _, targetPlayer in ipairs(allPlayers) do
                local targetRoot = targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                if targetRoot then
                    pcall(function()
                        CreatureGrab:FireServer(LeftDetector, targetRoot, LeftDetector.LeftWeld)
                    end)
                    if RightDetector then
                        pcall(function()
                            CreatureGrab:FireServer(RightDetector, targetRoot, RightDetector.RightWeld)
                        end)
                    end
                end
            end

            for _, part in ipairs(MyBlob:GetDescendants()) do
                if part:IsA("BasePart") then pcall(function() part.Anchored = false end) end
            end

            Settings.BlobmanBeta.kickAllV2Active = false
        end)
    end
end})

local loopAuraSec = LoopTab:Section({Text = "Blobman Kick Aura", Side = "Left"})
loopAuraSec:Toggle({Text = "Kick Aura", Flag = "KickAura", Default = false, Callback = function(v)
    Settings.BlobmanBeta.kickAuraActive = v
    if v then
        Settings.BlobmanBeta.auraKickedPlayers = {}
        local auraSide = "Left"
        task.spawn(function()
            while Settings.BlobmanBeta.kickAuraActive do
                if not BlobmanBetaFeature.isSittingOnBlobman() then
                    local blob = BlobmanBetaFeature.getBlobman()
                        or BlobmanBetaFeature.findAnyBlobman()
                        or BlobmanBetaFeature.spawnBlobman()
                    if not blob then task.wait(0.1) continue end
                    BlobmanBetaFeature.ensureSitBlobman()
                    task.wait(0.05)
                    continue
                end
                local blob = BlobmanBetaFeature.getBlobman()
                if not blob then task.wait(0.1) continue end
                local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if not myRoot then task.wait(0.1) continue end
                local currentTime = tick()
                for playerId, kickTime in pairs(Settings.BlobmanBeta.auraKickedPlayers) do
                    if currentTime - kickTime >= 1.5 then
                        Settings.BlobmanBeta.auraKickedPlayers[playerId] = nil
                    end
                end
                local nearbyPlayers = {}
                for _, plr in Players:GetPlayers() do
                    if plr == LocalPlayer then continue end
                    if Settings.BlobmanBeta.auraKickedPlayers[plr.UserId] then continue end
                    if not BlobmanBetaFeature.isValidTarget(plr, myRoot) then continue end
                    local char = plr.Character
                    local root = char and char:FindFirstChild("HumanoidRootPart")
                    if not root then continue end
                    local dist = (root.Position - myRoot.Position).Magnitude
                    if dist < 50 then
                        table.insert(nearbyPlayers, {plr = plr, root = root, dist = dist})
                    end
                end
                table.sort(nearbyPlayers, function(a, b) return a.dist < b.dist end)
                if #nearbyPlayers > 0 then
                    local target = nearbyPlayers[1]
                    local targetHum = target.root.Parent:FindFirstChildOfClass("Humanoid")
                    if BlobmanBetaFeature.isSittingOnBlobman() then
                        myRoot.AssemblyLinearVelocity = Vector3.zero
                        BlobmanBetaFeature.blobGrab(blob, myRoot, auraSide)
                        task.wait(0.03)
                        BlobmanBetaFeature.SetNetworkOwner(target.root)
                        task.wait(0.03)
                        target.root.CFrame = target.root.CFrame + Vector3.new(0, Settings.BlobmanBeta.FloatAmount, 0)
                        task.wait(0.03)
                        BlobmanBetaFeature.ungrab(target.root)
                        BlobmanBetaFeature.blobGrab(blob, target.root, auraSide)
                        task.wait(0.03)
                        BlobmanBetaFeature.blobDrop(blob, target.root, auraSide)
                        task.wait(0.03)
                        BlobmanBetaFeature.ungrab(target.root)
                        local healthAfter = targetHum and targetHum.Health or 0
                        if healthAfter <= 0 then
                            Settings.BlobmanBeta.auraKickedPlayers[target.plr.UserId] = nil
                        else
                            Settings.BlobmanBeta.auraKickedPlayers[target.plr.UserId] = tick()
                        end
                        auraSide = (auraSide == "Left") and "Right" or "Left"
                    end
                end
                task.wait(0.05)
            end
            Settings.BlobmanBeta.auraKickedPlayers = {}
        end)
    end
end})



local barrierNoclipConn = nil

local function setBarrierNoclip()
    if not State.barrierNoclip then return end
    local Plots = Workspace:FindFirstChild("Plots")
    if not Plots then return end
    for i = 1, 5 do
        local plot = Plots:FindFirstChild("Plot" .. i)
        if plot and plot:FindFirstChild("Barrier") then
            for _, barrier in ipairs(plot.Barrier:GetChildren()) do
                if barrier:IsA("BasePart") then
                    barrier.CanCollide = false
                end
            end
        end
    end
end

miscOtherSec:Toggle({Text = "PCLD Visual", Flag = "PCLDVisual", Default = false, Callback = function(value)
    Settings.Misc.pcldVisual = value
    if value then
        State.pcldParts = {}
        for _, part in ipairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") and part.Name == "PlayerCharacterLocationDetector" then
                table.insert(State.pcldParts, part)
            end
        end
        workspace.DescendantAdded:Connect(function(part)
            if Settings.Misc.pcldVisual and part:IsA("BasePart") and part.Name == "PlayerCharacterLocationDetector" then
                table.insert(State.pcldParts, part)
            end
        end)
        State.pcldTime = 0
        State.pcldConn = RunService.Heartbeat:Connect(function(dt)
            if not Settings.Misc.pcldVisual then return end
            State.pcldTime = State.pcldTime + dt
            if State.pcldTime < 0.5 then return end
            State.pcldTime = 0
            for i = #State.pcldParts, 1, -1 do
                local part = State.pcldParts[i]
                if not part.Parent then
                    table.remove(State.pcldParts, i)
                else
                    local pos = part.Position
                    if pos.X == 0 and pos.Y == 0 and pos.Z == 0 then
                        part.Transparency = 1
                    else
                        part.Transparency = 0.5
                        part.Color = Color3.fromRGB(106, 104, 104)
                    end
                end
            end
        end)
    else
        if State.pcldConn then State.pcldConn:Disconnect() State.pcldConn = nil end
        if State.pcldParts then
            for _, part in ipairs(State.pcldParts) do
                if part and part.Parent then part.Transparency = 1 end
            end
            State.pcldParts = nil
        end
    end
end})




local function reconnect()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildWhichIsA("Humanoid") or character:WaitForChild("Humanoid")
    local hrp = character:WaitForChild("HumanoidRootPart")
    character:WaitForChild("Head")
    State.IsCharacterInRagdoll = false

    local canBurn = hrp:WaitForChild("FirePlayerPart", 5)
    if canBurn then
        local canBurnValue = canBurn:WaitForChild("CanBurn", 5)
        if canBurnValue then
            canBurnValue.Changed:Connect(function(v)
                if v and apagarfogo then
                    while canBurnValue.Value do
                        if firetouchinterest then
                            firetouchinterest(hrp.FirePlayerPart, apagarfogo, 0)
                            task.wait()
                            firetouchinterest(hrp.FirePlayerPart, apagarfogo, 1)
                        else
                            apagarfogo.CFrame = hrp.FirePlayerPart.CFrame * CFrame.new(math.random(-1,1), math.random(-1,1), math.random(-1,1))
                            task.wait()
                            apagarfogo.Position = Vector3.new(0, -100, 0)
                        end
                    end
                end
            end)
        end
    end

    humanoid.Changed:Connect(function(prop)
        if prop == "Sit" and humanoid.Sit == true then
            if humanoid.SeatPart == nil and Settings.Anti.AntiGrab then
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
                humanoid.Sit = false
            end
        end
    end)

    if Settings.Anti.AntiKickKunai then
        task.delay(0.8, function()
            if Settings.Anti.AntiKickKunai then AntiFeature.attachKunai(true) end
        end)
    end
    if Settings.Anti.AntiExplosion and character then
        AntiFeature.setupAntiExplosion(character)
    end
end

LocalPlayer.CharacterAdded:Connect(reconnect)
task.spawn(reconnect)
AntiFeature.setupAntiGrabV1()

local function autoSitOnRespawn(char)
    local isAnyActive = Settings.BlobmanBeta.loopKillActive
        or Settings.BlobmanBeta.kickActive
        or Settings.BlobmanBeta.kickV2Active
        or Settings.BlobmanBeta.kickV4Active
        or Settings.BlobmanBeta.driftKickActive
        or Settings.BlobmanBeta.kickAllV2Active
        or Settings.BlobmanBeta.kickAuraActive
    if not isAnyActive then return end
    char:WaitForChild("Humanoid")
    char:WaitForChild("HumanoidRootPart")
    task.wait(4)
    for _ = 1, 30 do
        if not isAnyActive then return end
        if BlobmanBetaFeature.isSittingOnBlobman() then return end
        pcall(function() BlobmanBetaFeature.forceSitBlobman() end)
        task.wait(1)
        if BlobmanBetaFeature.isSittingOnBlobman() then return end
    end
end
if State.connections.autoSitOnRespawn then State.connections.autoSitOnRespawn:Disconnect() end
State.connections.autoSitOnRespawn = LocalPlayer.CharacterAdded:Connect(autoSitOnRespawn)
end




local AuraTab = Window:Tab({Text = "Aura"})
do

local auraSetSec = AuraTab:Section({Text = "Aura Settings"})
auraSetSec:Slider({Text = "Aura Radius", Flag = "AuraRadius", Minimum = 1, Maximum = 30, Default = 20, ValueName = "studs", Callback = function(v)
    Settings.Aura.auraRadius = v
end})
auraSetSec:Toggle({Text = "Friend Whitelist", Flag = "AuraFriendWhitelist", Default = false, Callback = function(v)
    Settings.Aura.auraFriendWhitelist = v
end})

local auraAtkSec = AuraTab:Section({Text = "Auras", Side = "Right"})

local function auraGetRoot()
    local c = LocalPlayer.Character
    return c and (c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("Torso"))
end

local function auraIsFriend(player)
    if not Settings.Aura.auraFriendWhitelist then return false end
    return pcall(function() return LocalPlayer:IsFriendsWith(player.UserId) end) and LocalPlayer:IsFriendsWith(player.UserId)
end

local function auraSetNetworkOwner(part)
    pcall(function() ReplicatedStorage.GrabEvents.SetNetworkOwner:FireServer(part, auraGetRoot().CFrame) end)
end

local function auraBodyVelocity(part, vel, lifetime)
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.one * math.huge
    bv.Velocity = vel
    bv.Parent = part
    Debris:AddItem(bv, lifetime or 1)
end

local function auraGetPlayersInRange()
    local root = auraGetRoot()
    if not root then return {} end
    local list = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and not auraIsFriend(player) and not isProtectedPlayer(player.Name) and player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart") or player.Character:FindFirstChild("Torso")
            if hrp and (hrp.Position - root.Position).Magnitude <= Settings.Aura.auraRadius then
                table.insert(list, player)
            end
        end
    end
    return list
end


local runningSkyAura = false
auraAtkSec:Toggle({Text = "Sky Aura", Flag = "SkyAura", Default = false, Callback = function(enabled)
    runningSkyAura = enabled
    if enabled then task.spawn(function()
        while runningSkyAura do
            local root = auraGetRoot()
            if root then
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and not auraIsFriend(player) and not isProtectedPlayer(player.Name) and player.Character then
                        pcall(function()
                            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                            if hrp and (hrp.Position - root.Position).Magnitude <= Settings.Aura.auraRadius then
                                auraSetNetworkOwner(hrp)
                                local bv = Instance.new("BodyVelocity", hrp)
                                bv.Velocity = Vector3.new(0, 300, 0)
                                bv.MaxForce = Vector3.one * math.huge
                                Debris:AddItem(bv, 0.2)
                            end
                        end)
                    end
                end
            end
            task.wait()
        end
    end) end
end})


local runningFlingAura = false
auraAtkSec:Toggle({Text = "Fling Aura", Flag = "FlingAura", Default = false, Callback = function(enabled)
    runningFlingAura = enabled
    if enabled then task.spawn(function()
        while runningFlingAura do
            local root = auraGetRoot()
            if root then
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and not auraIsFriend(player) and not isProtectedPlayer(player.Name) and player.Character then
                        pcall(function()
                            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                            if hrp and (hrp.Position - root.Position).Magnitude <= Settings.Aura.auraRadius then
                                auraSetNetworkOwner(hrp)
                                local bv = Instance.new("BodyVelocity", hrp)
                                bv.Velocity = Vector3.new(math.random(-1,1) * 5e10, 5e15, math.random(-1,1) * 5e10)
                                bv.MaxForce = Vector3.one * math.huge
                                Debris:AddItem(bv, 0.2)
                            end
                        end)
                    end
                end
            end
            task.wait()
        end
    end) end
end})


local runningVoidAura = false
auraAtkSec:Toggle({Text = "Void Aura", Flag = "VoidAura", Default = false, Callback = function(enabled)
    runningVoidAura = enabled
    if enabled then task.spawn(function()
        while runningVoidAura do
            local root = auraGetRoot()
            if root then
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and not auraIsFriend(player) and not isProtectedPlayer(player.Name) and player.Character then
                        pcall(function()
                            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                            if hrp and (hrp.Position - root.Position).Magnitude <= Settings.Aura.auraRadius then
                                auraSetNetworkOwner(hrp)
                                local bv = Instance.new("BodyVelocity", hrp)
                                bv.Velocity = Vector3.new(0, -5e10, 0)
                                bv.MaxForce = Vector3.one * math.huge
                                Debris:AddItem(bv, 0.2)
                            end
                        end)
                    end
                end
            end
            task.wait()
        end
    end) end
end})


local runningSpinAura = false
local spinAuraTask = nil
auraAtkSec:Toggle({Text = "Spin Aura", Flag = "SpinAura", Default = false, Callback = function(enabled)
    runningSpinAura = enabled
    if enabled then
        spinAuraTask = task.spawn(function()
            local spinAngle = 0
            while runningSpinAura do
                pcall(function()
                    local root = auraGetRoot()
                    if not root then return end
                    local spinRadius = Settings.Aura.auraRadius * 0.8
                    spinAngle = spinAngle + 0.05
                    if spinAngle >= 6.28 then spinAngle = 0 end
                    for _, player in pairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer and not auraIsFriend(player) and not isProtectedPlayer(player.Name) and player.Character then
                            local targetChar = player.Character
                            local humanoid = targetChar:FindFirstChildOfClass("Humanoid")
                            local torso = targetChar:FindFirstChild("Torso") or targetChar:FindFirstChild("UpperTorso") or targetChar:FindFirstChild("HumanoidRootPart")
                            if torso and humanoid and humanoid.Health > 0 then
                                local dist = (Vector3.new(torso.Position.X, 0, torso.Position.Z) - Vector3.new(root.Position.X, 0, root.Position.Z)).Magnitude
                                if dist <= spinRadius then
                                    local circleRadius = 10
                                    local targetPosition = root.Position + Vector3.new(math.cos(spinAngle) * circleRadius, 5, math.sin(spinAngle) * circleRadius)
                                    auraSetNetworkOwner(torso)
                                    local bv = torso:FindFirstChild("SpinAuraBV") or Instance.new("BodyVelocity")
                                    bv.Name = "SpinAuraBV"
                                    local diff = targetPosition - torso.Position
                                    local vel = diff * 25
                                    bv.Velocity = vel
                                    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                                    bv.P = 10000
                                    bv.Parent = torso
                                    local bg = torso:FindFirstChild("SpinAuraBG") or Instance.new("BodyGyro")
                                    bg.Name = "SpinAuraBG"
                                    bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                                    bg.P = 10000
                                    bg.D = 500
                                    bg.CFrame = CFrame.new(torso.Position, targetPosition)
                                    bg.Parent = torso
                                    humanoid.PlatformStand = true
                                elseif player.Character then
                                    local t = player.Character:FindFirstChild("Torso") or player.Character:FindFirstChild("UpperTorso")
                                    if t then
                                        local bv = t:FindFirstChild("SpinAuraBV")
                                        local bg = t:FindFirstChild("SpinAuraBG")
                                        if bv then bv:Destroy() end
                                        if bg then bg:Destroy() end
                                    end
                                end
                            end
                        end
                    end
                end)
                task.wait(0.02)
            end
        end)
    else
        if spinAuraTask then task.cancel(spinAuraTask) spinAuraTask = nil end
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                local torso = player.Character:FindFirstChild("Torso") or player.Character:FindFirstChild("UpperTorso")
                if humanoid then humanoid.PlatformStand = false end
                if torso then
                    local bv = torso:FindFirstChild("SpinAuraBV")
                    local bg = torso:FindFirstChild("SpinAuraBG")
                    if bv then bv:Destroy() end
                    if bg then bg:Destroy() end
                end
            end
        end
    end
end})


local traxAuraEnabled = false
local traxAuraTask = nil
local traxAuraTarget = nil
auraAtkSec:Toggle({Text = "Trax Aura", Flag = "TraxAura", Default = false, Callback = function(v)
    traxAuraEnabled = v
    if v then
        traxAuraTarget = nil
        traxAuraTask = task.spawn(function()
            local oscillation = 0
            while traxAuraEnabled do
                pcall(function()
                    local root = auraGetRoot()
                    if not root then return end
                    if traxAuraTarget and traxAuraTarget.Character then
                        local torso = traxAuraTarget.Character:FindFirstChild("Torso") or traxAuraTarget.Character:FindFirstChild("UpperTorso") or traxAuraTarget.Character:FindFirstChild("HumanoidRootPart")
                        local humanoid = traxAuraTarget.Character:FindFirstChildOfClass("Humanoid")
                        if torso and humanoid and (torso.Position - root.Position).Magnitude <= Settings.Aura.auraRadius then
                            local lookVector = root.CFrame.LookVector
                            local lowerFrontPos = root.Position + (lookVector * 3) + Vector3.new(0, -1.4, 0)
                            oscillation = oscillation + 0.3
                            local moveOffset = math.sin(oscillation) * 2
                            local currentDistance = 2 + moveOffset
                            local targetPosition = lowerFrontPos + (lookVector * currentDistance)
                            pcall(function() ReplicatedStorage.GrabEvents.SetNetworkOwner:FireServer(torso, CFrame.new(targetPosition)) end)
                            local bv = torso:FindFirstChild("TraxAuraBV") or Instance.new("BodyVelocity")
                            bv.Name = "TraxAuraBV"
                            local diff = targetPosition - torso.Position
                            local vel = diff * 25
                            bv.Velocity = vel
                            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                            bv.P = 10000
                            bv.Parent = torso
                            local bg = torso:FindFirstChild("TraxAuraBG") or Instance.new("BodyGyro")
                            bg.Name = "TraxAuraBG"
                            bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                            bg.P = 10000
                            bg.D = 500
                            bg.CFrame = CFrame.new(torso.Position, lowerFrontPos) * CFrame.Angles(math.rad(90), 0, 0)
                            bg.Parent = torso
                            humanoid.PlatformStand = true
                        else
                            if traxAuraTarget and traxAuraTarget.Character then
                                local t = traxAuraTarget.Character:FindFirstChild("Torso") or traxAuraTarget.Character:FindFirstChild("UpperTorso")
                                if t then
                                    local bv = t:FindFirstChild("TraxAuraBV")
                                    local bg = t:FindFirstChild("TraxAuraBG")
                                    if bv then bv:Destroy() end
                                    if bg then bg:Destroy() end
                                end
                            end
                            traxAuraTarget = nil
                        end
                    elseif not traxAuraTarget then
                        for _, player in pairs(Players:GetPlayers()) do
                            if player ~= LocalPlayer and not auraIsFriend(player) and not isProtectedPlayer(player.Name) and player.Character then
                                local torso = player.Character:FindFirstChild("Torso") or player.Character:FindFirstChild("UpperTorso")
                                if torso and (torso.Position - root.Position).Magnitude <= Settings.Aura.auraRadius then
                                    traxAuraTarget = player
                                    oscillation = 0
                                    break
                                end
                            end
                        end
                    end
                end)
                task.wait(0.03)
            end
        end)
    else
        if traxAuraTask then task.cancel(traxAuraTask) traxAuraTask = nil end
        traxAuraTarget = nil
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                local torso = player.Character:FindFirstChild("Torso") or player.Character:FindFirstChild("UpperTorso")
                if humanoid then humanoid.PlatformStand = false end
                if torso then
                    local bv = torso:FindFirstChild("TraxAuraBV")
                    local bg = torso:FindFirstChild("TraxAuraBG")
                    if bv then bv:Destroy() end
                    if bg then bg:Destroy() end
                end
            end
        end
    end
end})



local runningFreezeAura = false
auraAtkSec:Toggle({Text = "Freeze Aura", Flag = "FreezeAura", Default = false, Callback = function(enabled)
    runningFreezeAura = enabled
    if enabled then task.spawn(function()
        while runningFreezeAura do
            local root = auraGetRoot()
            if root then
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and not auraIsFriend(player) and not isProtectedPlayer(player.Name) and player.Character then
                        pcall(function()
                            local torso = player.Character:FindFirstChild("Torso") or player.Character:FindFirstChild("HumanoidRootPart")
                            if torso and (torso.Position - root.Position).Magnitude <= Settings.Aura.auraRadius then
                                auraSetNetworkOwner(torso)
                                local bp = Instance.new("BodyPosition", torso)
                                bp.Position = torso.Position
                                bp.MaxForce = Vector3.one * math.huge
                                bp.P = 1e6
                                Debris:AddItem(bp, 0.2)
                            end
                        end)
                    end
                end
            end
            task.wait()
        end
    end) end
end})


local runningSpinPlayersAura = false
auraAtkSec:Toggle({Text = "Spin Players Aura", Flag = "SpinPlayersAura", Default = false, Callback = function(enabled)
    runningSpinPlayersAura = enabled
    if enabled then task.spawn(function()
        while runningSpinPlayersAura do
            local root = auraGetRoot()
            if root then
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and not auraIsFriend(player) and not isProtectedPlayer(player.Name) and player.Character then
                        pcall(function()
                            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                            if hrp and (hrp.Position - root.Position).Magnitude <= Settings.Aura.auraRadius then
                                local bav = Instance.new("BodyAngularVelocity", hrp)
                                bav.AngularVelocity = Vector3.new(0, 80, 0)
                                bav.MaxTorque = Vector3.one * math.huge
                                Debris:AddItem(bav, 0.2)
                                local bv = Instance.new("BodyVelocity", hrp)
                                bv.Velocity = Vector3.new(0, -50, 0)
                                bv.MaxForce = Vector3.one * math.huge
                                Debris:AddItem(bv, 0.2)
                            end
                        end)
                    end
                end
            end
            task.wait()
        end
    end) end
end})


local runningBringAura = false
auraAtkSec:Toggle({Text = "Bring Aura", Flag = "BringAura", Default = false, Callback = function(enabled)
    runningBringAura = enabled
    if enabled then task.spawn(function()
        while runningBringAura do
            local root = auraGetRoot()
            if root then
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and not auraIsFriend(player) and not isProtectedPlayer(player.Name) and player.Character then
                        pcall(function()
                            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                            if hrp and (hrp.Position - root.Position).Magnitude <= Settings.Aura.auraRadius then
                                auraSetNetworkOwner(hrp)
                                hrp.CFrame = root.CFrame + root.CFrame.LookVector * 5
                            end
                        end)
                    end
                end
            end
            task.wait()
        end
    end) end
end})


clickAuraEnabled = false
local clickAuraAffectedPlayers = {}
local clickAuraTask = nil
auraAtkSec:Toggle({Text = "Click Aura", Flag = "ClickAura", Default = false, Callback = function(v)
    clickAuraEnabled = v
    if v then
        clickAuraAffectedPlayers = {}
        clickAuraTask = task.spawn(function()
            while clickAuraEnabled do
                pcall(function()
                    local root = auraGetRoot()
                    if not root then return end
                    for _, player in pairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer and not auraIsFriend(player) and not isProtectedPlayer(player.Name) and player.Character then
                            local targetChar = player.Character
                            local torso = targetChar:FindFirstChild("Torso") or targetChar:FindFirstChild("UpperTorso") or targetChar:FindFirstChild("HumanoidRootPart")
                            local head = targetChar:FindFirstChild("Head")
                            local hrp = targetChar:FindFirstChild("HumanoidRootPart")
                            if torso and head and hrp then
                                local distance = (torso.Position - root.Position).Magnitude
                                if distance <= Settings.Aura.auraRadius then
                                    pcall(function() ReplicatedStorage.GrabEvents.SetNetworkOwner:FireServer(torso, hrp.CFrame) end)
                                    if not torso:FindFirstChild("ClickAuraBV") then
                                        local bv = Instance.new("BodyVelocity")
                                        bv.Name = "ClickAuraBV"
                                        bv.Velocity = Vector3.new(0, 0, 0)
                                        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                                        bv.Parent = torso
                                        local bg = Instance.new("BodyGyro")
                                        bg.Name = "ClickAuraBG"
                                        bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                                        bg.P = 10000
                                        bg.D = 500
                                        bg.CFrame = CFrame.new(torso.Position, torso.Position + Vector3.new(0, 0, 1))
                                        bg.Parent = torso
                                    end
                                    clickAuraAffectedPlayers[player] = true
                                elseif clickAuraAffectedPlayers[player] then
                                    local bv = torso:FindFirstChild("ClickAuraBV")
                                    local bg = torso:FindFirstChild("ClickAuraBG")
                                    if bv then bv:Destroy() end
                                    if bg then bg:Destroy() end
                                    clickAuraAffectedPlayers[player] = nil
                                end
                            end
                        end
                    end
                end)
                task.wait(0.05)
            end
        end)
    else
        if clickAuraTask then task.cancel(clickAuraTask) clickAuraTask = nil end
        clickAuraAffectedPlayers = {}
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local torso = player.Character:FindFirstChild("Torso") or player.Character:FindFirstChild("UpperTorso")
                if torso then
                    local bv = torso:FindFirstChild("ClickAuraBV")
                    local bg = torso:FindFirstChild("ClickAuraBG")
                    if bv then bv:Destroy() end
                    if bg then bg:Destroy() end
                end
            end
        end
    end
end})


local runningDestroyAntiKickAura = false
local destroyAuraCancelId = 0
auraAtkSec:Toggle({Text = "Anti Anti Kick Aura", Flag = "DestroyAntiKickAura", Default = false, Callback = function(enabled)
    if not enabled then
        runningDestroyAntiKickAura = false
        destroyAuraCancelId = destroyAuraCancelId + 1
        if State.antiKickAuraTask then task.cancel(State.antiKickAuraTask) State.antiKickAuraTask = nil end
        return
    end
    runningDestroyAntiKickAura = true
    local myCancelId = destroyAuraCancelId
    State.antiKickAuraTask = task.spawn(function()
        local GE = ReplicatedStorage:WaitForChild("GrabEvents")
        local setNE = GE:WaitForChild("SetNetworkOwner")
        local createGL = GE:WaitForChild("CreateGrabLine")
        local destroyGL = GE:WaitForChild("DestroyGrabLine")
        local auraFrame = 0

        while runningDestroyAntiKickAura and destroyAuraCancelId == myCancelId do
            local root = auraGetRoot()
            if not root then task.wait(0.2) continue end
            local myPos = root.Position
            local auraRadius = Settings.Aura.auraRadius
            local myChar = LocalPlayer.Character

            for _, obj in ipairs(Workspace:GetPartBoundsInRadius(myPos, auraRadius)) do
                if not runningDestroyAntiKickAura or destroyAuraCancelId ~= myCancelId then return end
                if not obj:IsA("BasePart") then continue end
                if obj.Name ~= "StickyPart" then continue end
                if myChar and myChar:IsAncestorOf(obj) then continue end

                if auraFrame % 3 == 0 then
                    pcall(function() setNE:FireServer(obj, obj.CFrame) end)
                elseif auraFrame % 3 == 1 then
                    pcall(function() createGL:FireServer(obj, Vector3.zero, obj.Position, false) end)
                else
                    pcall(function() destroyGL:FireServer(obj) end)
                end
            end

            auraFrame = auraFrame + 1
            task.wait()
        end
    end)
end})


local runningAntiBananaAura = false
local antiBananaAuraCancelId = 0
auraAtkSec:Toggle({Text = "Anti Banana Aura", Flag = "AntiBananaAura", Default = false, Callback = function(enabled)
    if not enabled then
        runningAntiBananaAura = false
        antiBananaAuraCancelId = antiBananaAuraCancelId + 1
        return
    end
    runningAntiBananaAura = true
    local myCancelId = antiBananaAuraCancelId
    task.spawn(function()
        local GE = ReplicatedStorage:WaitForChild("GrabEvents")
        local setNE = GE:WaitForChild("SetNetworkOwner")
        local createGL = GE:WaitForChild("CreateGrabLine")
        local destroyGL = GE:WaitForChild("DestroyGrabLine")
        local auraFrame = 0

        while runningAntiBananaAura and antiBananaAuraCancelId == myCancelId do
            local root = auraGetRoot()
            if not root then task.wait(0.2) continue end
            local myPos = root.Position
            local auraRadius = Settings.Aura.auraRadius
            local myChar = LocalPlayer.Character

            for _, obj in ipairs(Workspace:GetPartBoundsInRadius(myPos, auraRadius)) do
                if not runningAntiBananaAura or antiBananaAuraCancelId ~= myCancelId then return end
                if not obj:IsA("BasePart") then continue end
                if obj.Name ~= "HitboxPart" then continue end
                if myChar and myChar:IsAncestorOf(obj) then continue end

                if auraFrame % 3 == 0 then
                    pcall(function() setNE:FireServer(obj, obj.CFrame) end)
                elseif auraFrame % 3 == 1 then
                    pcall(function() createGL:FireServer(obj, Vector3.zero, obj.Position, false) end)
                else
                    pcall(function() destroyGL:FireServer(obj) end)
                end

                pcall(function()
                    local direction = (obj.Position - myPos).Unit
                    local bv = Instance.new("BodyVelocity")
                    bv.Velocity = direction * 5000 + Vector3.new(0, 2000, 0)
                    bv.MaxForce = Vector3.one * math.huge
                    bv.Parent = obj
                    Debris:AddItem(bv, 0.3)
                end)
            end

            auraFrame = auraFrame + 1
            task.wait()
        end
    end)
end})


local auraForceSec = AuraTab:Section({Text = "Settings Auras"})


local repelAuraEnabled = false
auraForceSec:Toggle({Text = "Repel Aura", Flag = "RepelAura", Default = false, Callback = function(enabled)
    repelAuraEnabled = enabled
    if enabled then task.spawn(function()
        while repelAuraEnabled do
            local root = auraGetRoot()
            if root then
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and not auraIsFriend(player) and not isProtectedPlayer(player.Name) and player.Character then
                        pcall(function()
                            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                            if hrp and (hrp.Position - root.Position).Magnitude <= Settings.Aura.auraRadius then
                                auraSetNetworkOwner(hrp)
                                local direction = (hrp.Position - root.Position).Unit
                                local bv = Instance.new("BodyVelocity", hrp)
                                bv.Velocity = direction * Settings.Aura.repelAuraForce
                                bv.MaxForce = Vector3.one * math.huge
                                Debris:AddItem(bv, 0.2)
                            end
                        end)
                    end
                end
            end
            task.wait()
        end
    end) end
end})
auraForceSec:Slider({Text = "Repel Force", Flag = "RepelForce", Minimum = 50, Maximum = 500, Default = 100, ValueName = "force", Callback = function(v)
    Settings.Aura.repelAuraForce = v
end})


local magnetAuraEnabled = false
auraForceSec:Toggle({Text = "Magnet Aura", Flag = "MagnetAura", Default = false, Callback = function(enabled)
    magnetAuraEnabled = enabled
    if enabled then task.spawn(function()
        while magnetAuraEnabled do
            local root = auraGetRoot()
            if root then
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and not auraIsFriend(player) and not isProtectedPlayer(player.Name) and player.Character then
                        local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                        if hrp and (hrp.Position - root.Position).Magnitude <= Settings.Aura.magnetRange then
                            pcall(function()
                                auraSetNetworkOwner(hrp)
                                local direction = (root.Position - hrp.Position).Unit
                                auraBodyVelocity(hrp, direction * 50, 0.2)
                            end)
                        end
                    end
                end
            end
            task.wait()
        end
    end) end
    end
})
auraForceSec:Slider({Text = "Magnet Range", Flag = "MagnetRange", Minimum = 20, Maximum = 200, Default = 50, ValueName = "studs", Callback = function(v)
    Settings.Aura.magnetRange = v
end})


local antiWDAuraEnabled = false
auraAtkSec:Toggle({Text = "Anti WD Aura", Flag = "AntiWDAura", Default = false, Callback = function(enabled)
    antiWDAuraEnabled = enabled
    if enabled then task.spawn(function()
        local GE = ReplicatedStorage:WaitForChild("GrabEvents")
        local SetNetworkOwner = GE:WaitForChild("SetNetworkOwner")
        local CreateGrabLine = GE:WaitForChild("CreateGrabLine")
        local DestroyGrabLine = GE:WaitForChild("DestroyGrabLine")
        local auraFrame = 0
        while antiWDAuraEnabled do
            local root = auraGetRoot()
            if root then
                for _, part in ipairs(Workspace:GetPartBoundsInRadius(root.Position, Settings.Aura.auraRadius)) do
                    if part:IsA("BasePart") then
                        local parent = part.Parent
                        if parent and parent.Name == "SprayCanWD" and not part:IsDescendantOf(Workspace:FindFirstChild(LocalPlayer.Name .. "SpawnedInToys")) then
                            local dir = (part.Position - root.Position)
                            if dir.Magnitude > 0 then dir = dir.Unit else dir = Vector3.new(0,1,0) end
                            if auraFrame % 3 == 0 then
                                pcall(function() SetNetworkOwner:FireServer(part, root.CFrame) end)
                            elseif auraFrame % 3 == 1 then
                                pcall(function() CreateGrabLine:FireServer(part, Vector3.zero, part.Position, false) end)
                            else
                                pcall(function() DestroyGrabLine:FireServer(part) end)
                            end
                            pcall(function() part.AssemblyLinearVelocity = dir * Settings.Aura.repelAuraForce + Vector3.new(0, 50, 0) end)
                        end
                    end
                end
            end
            auraFrame = auraFrame + 1
            task.wait(0.1)
        end
    end) end
end})


local antiPalletFlingAuraEnabled = false
auraAtkSec:Toggle({Text = "Anti Pallet Fling Aura", Flag = "AntiPalletFlingAura", Default = false, Callback = function(enabled)
    antiPalletFlingAuraEnabled = enabled
    if enabled then task.spawn(function()
        local GE = ReplicatedStorage:WaitForChild("GrabEvents")
        local SetNetworkOwner = GE:WaitForChild("SetNetworkOwner")
        local CreateGrabLine = GE:WaitForChild("CreateGrabLine")
        local DestroyGrabLine = GE:WaitForChild("DestroyGrabLine")
        local auraFrame = 0
        while antiPalletFlingAuraEnabled do
            local root = auraGetRoot()
            if root then
                for _, part in ipairs(Workspace:GetPartBoundsInRadius(root.Position, Settings.Aura.auraRadius)) do
                    if part:IsA("BasePart") then
                        local parent = part.Parent
                        if parent and parent.Name == "PalletLightBrown" and not part:IsDescendantOf(Workspace:FindFirstChild(LocalPlayer.Name .. "SpawnedInToys")) then
                            local dir = (part.Position - root.Position)
                            if dir.Magnitude > 0 then dir = dir.Unit else dir = Vector3.new(0,1,0) end
                            if auraFrame % 3 == 0 then
                                pcall(function() SetNetworkOwner:FireServer(part, root.CFrame) end)
                            elseif auraFrame % 3 == 1 then
                                pcall(function() CreateGrabLine:FireServer(part, Vector3.zero, part.Position, false) end)
                            else
                                pcall(function() DestroyGrabLine:FireServer(part) end)
                            end
                            pcall(function() part.AssemblyLinearVelocity = dir * Settings.Aura.repelAuraForce + Vector3.new(0, 50, 0) end)
                        end
                    end
                end
            end
            auraFrame = auraFrame + 1
            task.wait(0.1)
        end
    end) end
end})



end




local PlayerTab = Window:Tab({Text = "Player"})
local playerMovementSec = PlayerTab:Section({Text = "Movement", Side = "Left"})
local playerJumpSec = PlayerTab:Section({Text = "Jump", Side = "Left"})

local playerConnections = {}

local function playerGetChar() return LocalPlayer.Character end
local function playerGetHumanoid()
    local c = playerGetChar()
    return c and c:FindFirstChildOfClass("Humanoid")
end
local function playerGetRoot()
    local c = playerGetChar()
    return c and c:FindFirstChild("HumanoidRootPart")
end

local defaultJumpPower = nil
local defaultJumpHeight = nil

local function playerSaveDefaultJump()
    local hum = playerGetHumanoid()
    if hum and defaultJumpPower == nil then
        defaultJumpPower = hum.JumpPower
        defaultJumpHeight = hum.JumpHeight
    end
end


playerMovementSec:Toggle({Text = "Walkspeed", Flag = "PlayerWalkspeed", Default = false, Callback = function(v)
    Settings.Player.walkspeed = v
    if playerConnections.WS then playerConnections.WS:Disconnect() end
    if v then
        playerConnections.WS = RunService.Stepped:Connect(function()
            local root = playerGetRoot()
            local hum = playerGetHumanoid()
            if root and hum then
                local velY = root.AssemblyLinearVelocity.Y
                root.CFrame = root.CFrame + hum.MoveDirection * (16 * Settings.Player.walkspeedValue / 100)
                root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, velY, root.AssemblyLinearVelocity.Z)
            end
        end)
    end
end})
playerMovementSec:Slider({Text = "Speed Multiplier", Flag = "PlayerSpeedMulti", Minimum = 1, Maximum = 20, Default = 1, ValueName = "x", Callback = function(v)
    Settings.Player.walkspeedValue = v
end})


playerMovementSec:Toggle({Text = "Noclip", Flag = "PlayerNoclip", Default = false, Callback = function(v)
    Settings.Player.noclip = v
    if playerConnections.NC then playerConnections.NC:Disconnect() end
    if v then
        playerConnections.NC = RunService.Stepped:Connect(function()
            local char = playerGetChar()
            if char then
                for _, p in pairs(char:GetDescendants()) do
                    if p:IsA("BasePart") then p.CanCollide = false end
                end
            end
        end)
    end
end})


playerJumpSec:Toggle({Text = "Infinite Jump", Flag = "PlayerInfJump", Default = false, Callback = function(v)
    Settings.Player.infiniteJump = v
    if playerConnections.IJ then playerConnections.IJ:Disconnect() end
    if v then
        playerConnections.IJ = UserInputService.JumpRequest:Connect(function()
            local hum = playerGetHumanoid()
            if hum then
                hum:ChangeState(Enum.HumanoidStateType.Freefall)
                task.wait()
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end
end})


playerJumpSec:Toggle({Text = "Jump Power", Flag = "PlayerJumpPower", Default = false, Callback = function(v)
    Settings.Player.jumpPower = v
    local hum = playerGetHumanoid()
    if hum then
        playerSaveDefaultJump()
        if v then
            if hum.UseJumpPower == false then
                hum.JumpHeight = math.clamp(Settings.Player.jumpPowerValue / 10, 7.2, 50)
            else
                hum.JumpPower = Settings.Player.jumpPowerValue
            end
        else
            if hum.UseJumpPower == false then
                hum.JumpHeight = defaultJumpHeight or 7.2
            else
                hum.JumpPower = defaultJumpPower or 50
            end
        end
    end
end})
playerJumpSec:Slider({Text = "Jump Power Value", Flag = "PlayerJumpPowerVal", Minimum = 20, Maximum = 200, Default = 50, ValueName = "power", Callback = function(v)
    Settings.Player.jumpPowerValue = v
    if Settings.Player.jumpPower then
        local hum = playerGetHumanoid()
        if hum then
            if hum.UseJumpPower == false then
                hum.JumpHeight = math.clamp(v / 10, 7.2, 50)
            else
                hum.JumpPower = v
            end
        end
    end
end})


playerJumpSec:Toggle({Text = "Auto wall-climb", Flag = "PlayerWallClimb", Default = false, Callback = function(v)
    Settings.Player.wallClimb = v
    if playerConnections.WC then playerConnections.WC:Disconnect() end
    if v then
        playerConnections.WC = task.spawn(function()
            while Settings.Player.wallClimb do
                local hum = playerGetHumanoid()
                local root = playerGetRoot()
                local char = playerGetChar()
                if hum and root and char then
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        local rayOrigin = root.Position
                        local rayDir = root.CFrame.LookVector * 2
                        local rayParams = RaycastParams.new()
                        rayParams.FilterDescendantsInstances = {char}
                        rayParams.FilterType = Enum.RaycastFilterType.Exclude
                        local result = Workspace:Raycast(rayOrigin, rayDir, rayParams)
                        if result and result.Instance and result.Instance.CanCollide then
                            hum:ChangeState(Enum.HumanoidStateType.Jumping)
                        end
                    end
                end
                task.wait()
            end
        end)
    end
end})


local playerGravitySec = PlayerTab:Section({Text = "Gravity", Side = "Right"})
playerGravitySec:Slider({Text = "Gravity", Flag = "PlayerGravityValue", Minimum = -15, Maximum = 1000, Default = 100, ValueName = "", Callback = function(v)
    Settings.Player.gravityValue = v
end})
playerGravitySec:Toggle({Text = "Apply Gravity", Flag = "PlayerApplyGravity", Default = false, Callback = function(v)
    Settings.Player.applyGravity = v
    if v then
        if playerConnections.GR then task.cancel(playerConnections.GR) end
        playerConnections.GR = task.spawn(function()
            while Settings.Player.applyGravity do
                Workspace.Gravity = Settings.Player.gravityValue
                task.wait()
            end
        end)
    else
        Workspace.Gravity = 100
    end
end})
local playerFlySec = PlayerTab:Section({Text = "Fly", Side = "Right"})
local playerTeleSec = PlayerTab:Section({Text = "Teleport", Side = "Right"})




local flyActive = false
local flyBV, flyBG, flyConn
local flyCurrentVelocity = Vector3.zero
local flyAltConn, flyCharAddedConn

function flyStart()
    if flyActive then return end
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    flyActive = true

    flyBG = Instance.new("BodyGyro")
    flyBG.P = 20000 flyBG.D = 500
    flyBG.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
    flyBG.CFrame = hrp.CFrame
    flyBG.Parent = hrp

    flyBV = Instance.new("BodyVelocity")
    flyBV.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    flyBV.Velocity = Vector3.zero
    flyBV.Parent = hrp

    flyConn = RunService.Heartbeat:Connect(function(dt)
        if not flyActive then flyConn:Disconnect() flyConn = nil return end
        local cam = Workspace.CurrentCamera
        local hum2 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if not cam or not hum2 then return end
        local md = hum2.MoveDirection
        local tv = Vector3.zero
        if md.Magnitude > 0.01 then
            local cl = cam.CFrame.LookVector
            local cr = cam.CFrame.RightVector
            local cfh = Vector3.new(cl.X, 0, cl.Z).Unit
            local crh = Vector3.new(cr.X, 0, cr.Z).Unit
            local fa = md:Dot(cfh)
            local ra = md:Dot(crh)
            local sp = Settings.Player.flySpeed
            tv = (cfh * fa + crh * ra) * sp + Vector3.new(0, cl.Y * fa * sp, 0)
        end
        flyCurrentVelocity = flyCurrentVelocity:Lerp(tv, math.clamp(dt * (tv.Magnitude > flyCurrentVelocity.Magnitude and 8 or 6), 0, 1))
        if flyBV then flyBV.Velocity = flyCurrentVelocity end
        if flyBG then flyBG.CFrame = cam.CFrame end
    end)
end

function flyStop()
    flyActive = false
    flyCurrentVelocity = Vector3.zero
    if flyBG then flyBG:Destroy() flyBG = nil end
    if flyBV then flyBV:Destroy() flyBV = nil end
    if flyConn then flyConn:Disconnect() flyConn = nil end
end

playerFlySec:Toggle({Text = "Fly Enabled", Flag = "PlayerFly", Default = false, Callback = function(v)
    Settings.Player.flyEnabled = v
    if not v and flyActive then
        flyStop()
    end
end})
playerFlySec:Keybind({Text = "Fly Key", Flag = "PlayerFlyKey", Mode = "Toggle", Callback = function()
    if not Settings.Player.flyEnabled then return end
    if flyActive then
        Settings.Player.fly = false
        flyStop()
    else
        Settings.Player.fly = true
        flyStart()
    end
end})
playerFlySec:Slider({Text = "Fly Speed", Flag = "PlayerFlySpeed", Minimum = 10, Maximum = 800, Default = 415, ValueName = "studs", Callback = function(v)
    Settings.Player.flySpeed = v
end})

flyCharAddedConn = LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    if flyActive then flyStop() end
end)




playerTeleSec:Toggle({Text = "Click TP", Flag = "PlayerClickTP", Default = false, Callback = function(v)
    Settings.Player.clickTP = v
end})
playerTeleSec:Keybind({Text = "TP Key", Flag = "PlayerClickTPKey", Mode = "Hold", Callback = function(holding)
    if not Settings.Player.clickTP then return end
    if holding then
        local root = playerGetRoot()
        local mouse = LocalPlayer:GetMouse()
        if root and mouse and mouse.Hit then
            root.CFrame = mouse.Hit + Vector3.new(0, 3, 0)
        end
    end
end})

local playerSpinSec = PlayerTab:Section({Text = "Spinbot", Side = "Right"})
local spinbotActive = false
local spinbotConn = nil
local spinbotOrigAutoRotate = nil
local spinbotAngle = 0
playerSpinSec:Toggle({Text = "Spinbot", Flag = "PlayerSpinbot", Default = false, Callback = function(v)
    spinbotActive = v
    if v then
        Settings.Player.spinbotSpeed = Settings.Player.spinbotSpeed or 10000
        spinbotAngle = 0
        local hum = playerGetHumanoid()
        if hum then
            spinbotOrigAutoRotate = hum.AutoRotate
            hum.AutoRotate = false
        end
        spinbotConn = RunService.RenderStepped:Connect(function(dt)
            if not spinbotActive then return end
            local root = playerGetRoot()
            local hum = playerGetHumanoid()
            if root and hum then
                hum.AutoRotate = false
                local velY = root.AssemblyLinearVelocity.Y
                spinbotAngle = spinbotAngle + math.rad(Settings.Player.spinbotSpeed) * dt
                if spinbotAngle > math.pi * 2 then spinbotAngle = spinbotAngle - math.pi * 2 end
                local pos = root.Position
                root.CFrame = CFrame.new(pos) * CFrame.Angles(0, spinbotAngle, 0)
                root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, velY, root.AssemblyLinearVelocity.Z)
            end
        end)
    else
        if spinbotConn then spinbotConn:Disconnect(); spinbotConn = nil end
        spinbotAngle = 0
        local hum = playerGetHumanoid()
        if hum and spinbotOrigAutoRotate ~= nil then
            hum.AutoRotate = spinbotOrigAutoRotate
            spinbotOrigAutoRotate = nil
        end
    end
end})
playerSpinSec:Slider({Text = "Spin Speed", Flag = "PlayerSpinSpeed", Minimum = 1, Maximum = 10000, Default = 10000, ValueName = "speed", Callback = function(v)
    Settings.Player.spinbotSpeed = v
end})




do
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ToolInventory"
    screenGui.Parent = PlayerGui
    screenGui.ResetOnSpawn = false

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 0, 0, 44)
    mainFrame.Position = UDim2.new(0.5, 0, 1, -30)
    mainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
    mainFrame.BackgroundTransparency = 0.7
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Visible = false
    mainFrame.Parent = screenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = mainFrame

    local toolList = Instance.new("Frame")
    toolList.Name = "ToolList"
    toolList.Size = UDim2.new(1, -12, 1, -12)
    toolList.Position = UDim2.new(0, 6, 0, 6)
    toolList.BackgroundTransparency = 1
    toolList.Parent = mainFrame

    local gridLayout = Instance.new("UIGridLayout")
    gridLayout.Parent = toolList
    gridLayout.CellSize = UDim2.new(0, 28, 0, 28)
    gridLayout.CellPadding = UDim2.new(0, 8, 0, 8)
    gridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    gridLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    gridLayout.FillDirectionMaxCells = 10

    local scoToolSlots = {}
    local scoMAX_SLOTS = 10

    local function scoUpdateFrameSize(toolCount)
        if toolCount == 0 or not Settings.Misc.toyList then
            mainFrame.Visible = false
            return
        end
        mainFrame.Visible = true
        local iconSize = 28
        local padding = 8
        local margins = 12
        local displayCount = math.min(toolCount, scoMAX_SLOTS)
        local maxWidth = 400
        local itemsPerRow = math.floor((maxWidth - margins) / (iconSize + padding))
        if itemsPerRow < 1 then itemsPerRow = 1 end
        local rows = math.ceil(displayCount / itemsPerRow)
        local totalWidth
        if rows == 1 then
            totalWidth = (displayCount * iconSize) + ((displayCount - 1) * padding) + margins
        else
            totalWidth = (itemsPerRow * iconSize) + ((itemsPerRow - 1) * padding) + margins
            if totalWidth > maxWidth then totalWidth = maxWidth end
        end
        local totalHeight = (rows * iconSize) + ((rows - 1) * padding) + margins
        gridLayout.CellSize = UDim2.new(0, iconSize, 0, iconSize)
        gridLayout.CellPadding = UDim2.new(0, padding, 0, padding)
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TweenService:Create(mainFrame, tweenInfo, {
            Size = UDim2.new(0, totalWidth, 0, totalHeight),
            Position = UDim2.new(0.5, -totalWidth/2, 1, -(totalHeight + 6))
        }):Play()
    end

    local function scoIsToolEquipped(toolName)
        local character = LocalPlayer.Character
        if character then
            local equipped = character:FindFirstChild(toolName)
            if equipped and equipped:IsA("Tool") then return true end
        end
        return false
    end

    local function scoUpdateHighlight()
        for _, button in pairs(toolList:GetChildren()) do
            if button:IsA("ImageButton") then
                local isEquipped = scoIsToolEquipped(button.Name)
                if isEquipped then
                    button.BackgroundColor3 = Color3.new(0.6, 0.6, 0.6)
                    button.BackgroundTransparency = 0.2
                    button.BorderSizePixel = 2
                    button.BorderColor3 = Color3.new(1, 1, 1)
                else
                    button.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
                    button.BackgroundTransparency = 0.5
                    button.BorderSizePixel = 2
                    button.BorderColor3 = Color3.new(0.2, 0.2, 0.2)
                end
            end
        end
    end

    local function scoToggleToolBySlot(slotNumber)
        if slotNumber < 1 or slotNumber > scoMAX_SLOTS then return end
        local tool = scoToolSlots[slotNumber]
        if not tool then return end
        local character = LocalPlayer.Character
        local backpack = LocalPlayer.Backpack
        if not character or not backpack then return end
        local equipped = character:FindFirstChild(tool.Name)
        if equipped then
            equipped.Parent = backpack
            scoUpdateHighlight()
            return
        end
        local target = backpack:FindFirstChild(tool.Name)
        if target then
            target.Parent = character
            scoUpdateHighlight()
        end
    end

    local function scoCreateToolButton(tool, slotNumber)
        local button = Instance.new("ImageButton")
        button.Name = tool.Name
        button.Size = UDim2.new(0, 28, 0, 28)
        button.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
        button.BackgroundTransparency = 0.5
        button.BorderSizePixel = 2
        button.BorderColor3 = Color3.new(0.2, 0.2, 0.2)
        button.AutoButtonColor = false

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 4)
        btnCorner.Parent = button

        local icon = Instance.new("ImageLabel")
        icon.Name = "Icon"
        icon.Size = UDim2.new(0, 20, 0, 20)
        icon.Position = UDim2.new(0.5, -10, 0.25, 0)
        icon.BackgroundTransparency = 1
        if tool:FindFirstChild("Handle") then
            local handle = tool.Handle
            if handle:IsA("BasePart") and handle:FindFirstChild("Texture") then
                icon.Image = handle.Texture or "rbxassetid://13115827754"
            else
                icon.Image = "rbxassetid://13115827754"
            end
        else
            icon.Image = "rbxassetid://13115827754"
        end
        icon.Parent = button

        local slotLabel = Instance.new("TextLabel")
        slotLabel.Name = "SlotLabel"
        slotLabel.Size = UDim2.new(0, 10, 0, 10)
        slotLabel.Position = UDim2.new(0, 2, 0, 2)
        slotLabel.BackgroundTransparency = 1
        slotLabel.Text = tostring(slotNumber)
        slotLabel.TextColor3 = Color3.new(1, 1, 1)
        slotLabel.TextScaled = true
        slotLabel.Font = Enum.Font.GothamBold
        slotLabel.TextXAlignment = Enum.TextXAlignment.Left
        slotLabel.TextYAlignment = Enum.TextYAlignment.Top
        slotLabel.Parent = button

        local label = Instance.new("TextLabel")
        label.Name = "Label"
        label.Size = UDim2.new(1, 0, 0, 10)
        label.Position = UDim2.new(0, 0, 0.65, 0)
        label.BackgroundTransparency = 1
        label.Text = tool.Name
        label.TextColor3 = Color3.new(1, 1, 1)
        label.TextScaled = true
        label.Font = Enum.Font.GothamBold
        label.Parent = button

        button.MouseEnter:Connect(function()
            local isEq = scoIsToolEquipped(button.Name)
            local ti = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            if isEq then
                TweenService:Create(button, ti, { Size = UDim2.new(0, 32, 0, 32), BackgroundTransparency = 0.1 }):Play()
            else
                TweenService:Create(button, ti, { Size = UDim2.new(0, 32, 0, 32), BackgroundTransparency = 0.2 }):Play()
            end
        end)

        button.MouseLeave:Connect(function()
            local isEq = scoIsToolEquipped(button.Name)
            local ti = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            if isEq then
                TweenService:Create(button, ti, { Size = UDim2.new(0, 28, 0, 28), BackgroundTransparency = 0.2 }):Play()
            else
                TweenService:Create(button, ti, { Size = UDim2.new(0, 28, 0, 28), BackgroundTransparency = 0.5 }):Play()
            end
        end)

        button.MouseButton1Down:Connect(function()
            local ti = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            TweenService:Create(button, ti, { Size = UDim2.new(0, 24, 0, 24), BackgroundTransparency = 0.3 }):Play()
        end)

        button.MouseButton1Up:Connect(function()
            local ti = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            TweenService:Create(button, ti, { Size = UDim2.new(0, 28, 0, 28), BackgroundTransparency = 0.2 }):Play()
        end)

        button.MouseButton1Click:Connect(function()
            scoToggleToolBySlot(slotNumber)
        end)

        return button
    end

    local function scoUpdateInventory()
        for _, child in pairs(toolList:GetChildren()) do
            if child:IsA("ImageButton") then child:Destroy() end
        end
        scoToolSlots = {}
        local tools = {}
        local character = LocalPlayer.Character
        local backpack = LocalPlayer.Backpack
        if backpack then
            for _, child in pairs(backpack:GetChildren()) do
                if child:IsA("Tool") then table.insert(tools, child) end
            end
        end
        if character then
            for _, child in pairs(character:GetChildren()) do
                if child:IsA("Tool") then
                    local exists = false
                    for _, tool in pairs(tools) do
                        if tool.Name == child.Name then exists = true break end
                    end
                    if not exists then table.insert(tools, child) end
                end
            end
        end
        local slotNumber = 1
        for _, tool in pairs(tools) do
            if slotNumber <= scoMAX_SLOTS then
                scoToolSlots[slotNumber] = tool
                local button = scoCreateToolButton(tool, slotNumber)
                button.Parent = toolList
                slotNumber = slotNumber + 1
            end
        end
        scoUpdateFrameSize(#scoToolSlots)
        scoUpdateHighlight()
    end

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        local gui = PlayerGui:FindFirstChild("ToolInventory")
        if not gui then return end
        local mf = gui:FindFirstChild("MainFrame")
        if not mf or not mf.Visible then return end
        local keyMap = {
            [Enum.KeyCode.One] = 1, [Enum.KeyCode.Two] = 2, [Enum.KeyCode.Three] = 3,
            [Enum.KeyCode.Four] = 4, [Enum.KeyCode.Five] = 5, [Enum.KeyCode.Six] = 6,
            [Enum.KeyCode.Seven] = 7, [Enum.KeyCode.Eight] = 8, [Enum.KeyCode.Nine] = 9,
            [Enum.KeyCode.Zero] = 10
        }
        local slotNumber = keyMap[input.KeyCode]
        if slotNumber then scoToggleToolBySlot(slotNumber) end
    end)

    local function scoSetupCharacter(char)
        if char then
            char.ChildAdded:Connect(scoUpdateInventory)
            char.ChildRemoved:Connect(scoUpdateInventory)
            scoUpdateInventory()
        end
    end

    LocalPlayer.CharacterAdded:Connect(scoSetupCharacter)
    LocalPlayer.Backpack.ChildAdded:Connect(scoUpdateInventory)
    LocalPlayer.Backpack.ChildRemoved:Connect(scoUpdateInventory)

    if LocalPlayer.Character then
        scoSetupCharacter(LocalPlayer.Character)
    else
        LocalPlayer.CharacterAdded:Connect(scoSetupCharacter)
    end
    scoUpdateInventory()
    Settings.Misc.refreshToolList = scoUpdateInventory

    RunService.Heartbeat:Connect(function()
        scoUpdateHighlight()
    end)
end




do
    local droActive = false
    local droConnections = {}

    local function droCreateTool()
        local t = Instance.new("Tool")
        t.Name = "Jerk Off"
        t.RequiresHandle = false
        t.Parent = LocalPlayer.Backpack
        return t
    end

    local function droPlayAnim(id, t1, t2, id2)
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hum then return end

        local a = Instance.new("Animation")
        a.AnimationId = "rbxassetid://" .. id
        local tr = hum:LoadAnimation(a)

        droConnections[id2] = RunService.RenderStepped:Connect(function()
            if droActive then
                if tr.TimePosition >= t2 or tr.IsPlaying == false then
                    tr:Play()
                    tr.TimePosition = t1
                end
            else
                tr:Stop()
            end
        end)

        tr:Play()
        tr.TimePosition = t1
    end

    local function droStart()
        droActive = true
        droPlayAnim("72042024", 0.5, 0.9, 1)
        droPlayAnim("168268306", 1, 1.001, 2)
    end

    local function droStop()
        droActive = false
        for i, v in pairs(droConnections) do
            v:Disconnect()
        end
        droConnections = {}
    end

    LocalPlayer.CharacterAdded:Connect(function()
        local old = LocalPlayer.Backpack:FindFirstChild("Jerk Off")
        if old then old:Destroy() end
        local nt = droCreateTool()
        nt.Equipped:Connect(droStart)
        nt.Unequipped:Connect(droStop)
    end)

    local st = droCreateTool()
    st.Equipped:Connect(droStart)
    st.Unequipped:Connect(droStop)
end




do
    local TelekinesisFeature = {}
    TelekinesisFeature.activeItems = {}
    TelekinesisFeature.spawnConn = nil
    TelekinesisFeature.auraConn = nil
        local GE = ReplicatedStorage:WaitForChild("GrabEvents")
        local SetNetworkOwner = GE:WaitForChild("SetNetworkOwner")

    function TelekinesisFeature.getDrivePart(model)
        local main = model:FindFirstChild("Main")
        if main then return main end
        local sp = model:FindFirstChild("SoundPart")
        if sp then return sp end
        return model:FindFirstChildWhichIsA("BasePart")
    end

    function TelekinesisFeature.preparePart(model)
        local drivePart = TelekinesisFeature.getDrivePart(model)
        if not drivePart then return false end
        local myChar = LocalPlayer.Character
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if not myRoot then return false end

        local savedCFrame = myRoot.CFrame

        myRoot.CFrame = drivePart.CFrame * CFrame.new(0, 3, 0)
        task.wait(0.15)

        for _, part in ipairs(model:GetDescendants()) do
            if part:IsA("BasePart") and part.Parent then
                pcall(function() SetNetworkOwner:FireServer(part, Vector3.zero) end)
            end
        end

        task.wait(0.2)
        myRoot.CFrame = savedCFrame
        return true
    end

    function TelekinesisFeature.getNearbyGrabPart(model)
        local dp = TelekinesisFeature.getDrivePart(model)
        if not dp or not dp.Parent then return nil, nil end
        local halfSize = dp.Size / 2
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                local plrFolder = Workspace:FindFirstChild(plr.Name)
                if plrFolder then
                    local gpFolder = plrFolder:FindFirstChild("GrabParts")
                    if gpFolder then
                        for _, gp in ipairs(gpFolder:GetChildren()) do
                            if gp:IsA("BasePart") and gp.Name == "GrabPart" and gp.Parent then
                                local rel = dp.CFrame:PointToObjectSpace(gp.Position)
                                if math.abs(rel.X) <= halfSize.X + 1
                                    and math.abs(rel.Y) <= halfSize.Y + 1
                                    and math.abs(rel.Z) <= halfSize.Z + 1 then
                                    return gp, plr
                                end
                            end
                        end
                    end
                end
            end
        end
        return nil, nil
    end

    function TelekinesisFeature.startOrbit(model, skipPrepare)
        if TelekinesisFeature.activeItems[model] then return end
        local grabPart = TelekinesisFeature.getNearbyGrabPart(model)
        if grabPart then return end
        if not skipPrepare then
            local ok = TelekinesisFeature.preparePart(model)
            if not ok then return end
        end
        local drivePart = TelekinesisFeature.getDrivePart(model)
        if drivePart then
            if drivePart.Anchored then
                drivePart.Anchored = false
            end

            local bp = drivePart:FindFirstChildOfClass("BodyPosition")
            if not bp then
                bp = Instance.new("BodyPosition")
                bp.MaxForce = Vector3.new(5e18, 5e18, 5e18)
                bp.D = 1000
                bp.P = 50000
                bp.Parent = drivePart
            end

            local bg = drivePart:FindFirstChildOfClass("BodyGyro")
            if not bg then
                bg = Instance.new("BodyGyro")
                bg.MaxTorque = Vector3.new(5e18, 5e18, 5e18)
                bg.D = 1000
                bg.P = 50000
                bg.Parent = drivePart
            end

            TelekinesisFeature.activeItems[model] = {
                drivePart = drivePart,
                bp = bp,
                bg = bg,
            }
        else
            TelekinesisFeature.activeItems[model] = {drivePart = nil, bp = nil, bg = nil}
        end
    end

    function TelekinesisFeature.stopOrbit(model)
        local data = TelekinesisFeature.activeItems[model]
        TelekinesisFeature.activeItems[model] = nil
        for _, part in ipairs(model:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
        local dp = data and data.drivePart
        if dp and dp.Parent then
            pcall(function()
                dp.Anchored = false
                dp.AssemblyLinearVelocity = Vector3.zero
                dp.AssemblyAngularVelocity = Vector3.zero
            end)
        end
        if data and data.bg then pcall(function() data.bg:Destroy() end) end
    end

    function TelekinesisFeature.stopAll()
        for model, data in pairs(TelekinesisFeature.activeItems) do
            if model and model.Parent then
                for _, part in ipairs(model:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
                local dp = data and data.drivePart
                if dp and dp.Parent then
                    pcall(function()
                        dp.Anchored = false
                        dp.AssemblyLinearVelocity = Vector3.zero
                        dp.AssemblyAngularVelocity = Vector3.zero
                    end)
                end
                if data.bp then pcall(function() data.bp:Destroy() end) end
                if data.bg then pcall(function() data.bg:Destroy() end) end
            end
        end
        TelekinesisFeature.activeItems = {}
        if TelekinesisFeature.spawnConn then TelekinesisFeature.spawnConn:Disconnect() TelekinesisFeature.spawnConn = nil end
        if TelekinesisFeature.auraConn then task.cancel(TelekinesisFeature.auraConn) TelekinesisFeature.auraConn = nil end
    end

    function TelekinesisFeature.spawnToy(toyName)
        local myChar = LocalPlayer.Character
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if not myRoot then return end
        local SpawnedInToys = Workspace:FindFirstChild(LocalPlayer.Name .. "SpawnedInToys")
        if not SpawnedInToys then return end
        local connection
        connection = SpawnedInToys.ChildAdded:Connect(function(child)
            if child.Name == toyName then
                connection:Disconnect()
                task.wait(0.3)
                TelekinesisFeature.startOrbit(child)
            end
        end)
        local spawnCFrame = myRoot.CFrame * CFrame.new(0, 0, -5)
        pcall(function() SpawnToyRF:InvokeServer(toyName, spawnCFrame, Vector3.new(0, 0, 0)) end)
        task.delay(5, function() pcall(function() connection:Disconnect() end) end)
    end

    function TelekinesisFeature.runAura()
        if TelekinesisFeature.auraConn then return end
        TelekinesisFeature.auraConn = task.spawn(function()
            local angle = 0
            local lastTime = tick()
            local scanTick = 0
            local savedCF = nil
            while Settings.Telekinesis.Enabled do
                task.wait(1e-10)
                local now = tick()
                local dt = math.max(now - lastTime, 0.001)
                lastTime = now

                if now - scanTick > 0.1 then
                    scanTick = now
                end

                local myChar = LocalPlayer.Character
                local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
                if not myRoot then continue end

                local centerPart = Settings.Telekinesis.CustomMainPart
                if centerPart and centerPart.Parent then
                    myRoot = centerPart
                end

                local radius = Settings.Telekinesis.Radius
                local height = Settings.Telekinesis.Height
                local speed = Settings.Telekinesis.Speed

                angle = angle + math.rad(speed * 20) * dt
                if angle > math.pi * 2 then angle = angle - math.pi * 2 end

                local itemList = {}
                for model, data in pairs(TelekinesisFeature.activeItems) do
                    if model and model.Parent then
                        local grabPart = TelekinesisFeature.getNearbyGrabPart(model)
                        if grabPart then
                            TelekinesisFeature.stopOrbit(model)
                        else
                            if not data.stuckCount then data.stuckCount = 0 end
                            table.insert(itemList, {model = model, drivePart = data.drivePart, bp = data.bp, bg = data.bg, stuckCount = data.stuckCount})
                        end
                    else
                        TelekinesisFeature.activeItems[model] = nil
                    end
                end

                local count = #itemList
                local step = (math.pi * 2) / math.max(count, 1)

                local centerPos = myRoot.Position + Vector3.new(0, height, 0)

                for i, item in ipairs(itemList) do
                    local itemAngle = angle + (step * (i - 1))
                    local style = Settings.Telekinesis.Style
                    local targetPos
                    local customTangent = nil

                    if Settings.Telekinesis.crazyRadius then
                        local s = i * 1337.1
                        local a1 = now * (15 + i * 4.3) + s
                        local a2 = now * (19 + i * 3.1) + s * 2.3
                        local a3 = now * (23 + i * 5.7) + s * 0.7
                        local mapR = 2400
                        local cx = (math.sin(a1) * 0.6 + math.cos(a2) * 0.4) * mapR
                        local cz = (math.cos(a3) * 0.5 + math.sin(a2) * 0.5) * mapR
                        targetPos = centerPos + Vector3.new(cx, 0, cz)
                    elseif style == "Circle" then
                        targetPos = centerPos + Vector3.new(
                            math.cos(itemAngle) * radius,
                            0,
                            math.sin(itemAngle) * radius
                        )
                    elseif style == "Circle Up Down" then
                        targetPos = centerPos + Vector3.new(
                            math.cos(itemAngle) * radius,
                            math.sin(itemAngle * 2) * height,
                            math.sin(itemAngle) * radius
                        )
                    elseif style == "Square" then
                        local t = (itemAngle % (math.pi * 2)) / (math.pi * 2) * 4
                        local sx, sz
                        if t < 1 then sx, sz = -1 + t * 2, -1
                        elseif t < 2 then sx, sz = 1, -1 + (t - 1) * 2
                        elseif t < 3 then sx, sz = 1 - (t - 2) * 2, 1
                        else sx, sz = -1, 1 - (t - 3) * 2
                        end
                        targetPos = centerPos + Vector3.new(sx * radius, 0, sz * radius)
                    elseif style == "Heart" then
                        local sx = radius / 14
                        local sy = height / 8
                        local ht = itemAngle
                        local hx = 16 * math.sin(ht) ^ 3
                        local hy = 13 * math.cos(ht) - 5 * math.cos(2 * ht) - 2 * math.cos(3 * ht) - math.cos(4 * ht)
                        local heartRight = Vector3.new(1, 0, 0)
                        local heartUp = Vector3.new(0, 1, 0)
                        targetPos = centerPos + heartRight * hx * sx + heartUp * hy * sy
                        local dxdt = 48 * math.sin(ht) ^ 2 * math.cos(ht)
                        local dydt = -13 * math.sin(ht) + 10 * math.sin(2 * ht) + 6 * math.sin(3 * ht) + math.sin(4 * ht)
                        local hmag = math.sqrt(dxdt * dxdt + dydt * dydt)
                        if hmag > 0.001 then
                            customTangent = ((heartRight * dxdt + heartUp * dydt) / hmag)
                        else
                            customTangent = Vector3.new(1, 0, 0)
                        end
                    elseif style == "Tornado" then
                        local itemCount = math.max(count, 1)
                        local itemFrac = (i - 1) / itemCount
                        local tornadoR = radius * (0.3 + itemFrac * 0.7)
                        local tornadoY = itemFrac * height * 2 - height
                        local baseSpin = angle + itemFrac * math.pi * 4
                        local seed = i * 1337.1
                        local randAngle = math.noise(seed, 0, 0) * math.pi * 2
                        local randR = (math.noise(0, seed, 0) * 0.5 + 0.5) * tornadoR * 0.4
                        local tornadoSpin = baseSpin + randAngle
                        local finalR = tornadoR + randR
                        targetPos = centerPos + Vector3.new(
                            math.cos(tornadoSpin) * finalR,
                            tornadoY + math.noise(seed, seed, 0) * height * 0.15,
                            math.sin(tornadoSpin) * finalR
                        )
                        local tangX = -math.sin(tornadoSpin) * finalR * speed
                        local tangZ = math.cos(tornadoSpin) * finalR * speed
                        local tangY = height * 2 * 0.15 * speed / (math.pi * 2)
                        local tmag = math.sqrt(tangX * tangX + tangY * tangY + tangZ * tangZ)
                        if tmag > 0.001 then
                            customTangent = Vector3.new(tangX, tangY, tangZ) / tmag
                        end
                    elseif style == "Galactic" then
                        local arms = 4
                        local armIdx = (i - 1) % arms
                        local armPhase = armIdx * (math.pi * 2 / arms)
                        local objectsPerArm = math.max(1, math.floor(count / arms))
                        local posInArm = math.floor((i - 1) / arms)
                        local armFrac = objectsPerArm > 1 and (posInArm / (objectsPerArm - 1)) or 0.5
                        local galR = radius * (0.08 + armFrac * 0.92)
                        local spiralTight = 2.5
                        local galAngle = armPhase + armFrac * spiralTight + itemAngle * 0.3
                        local galY = math.sin(armFrac * math.pi * 2 + itemAngle * 0.2) * height * 0.25
                        targetPos = centerPos + Vector3.new(
                            math.cos(galAngle) * galR,
                            galY,
                            math.sin(galAngle) * galR
                        )
                    elseif style == "Wave" then
                        local waveX = ((i - 1) / math.max(1, count - 1) - 0.5) * radius * 2
                        local waveY = math.sin(waveX / radius * math.pi * 2 + itemAngle * 2) * height
                        local waveZ = math.cos(waveX / radius * math.pi * 2 + itemAngle * 2) * height * 0.5
                        targetPos = centerPos + Vector3.new(waveX, waveY, waveZ)
                    elseif style == "Infinity" then
                        local ix = radius * math.sin(itemAngle)
                        local iz = radius * math.sin(itemAngle) * math.cos(itemAngle)
                        targetPos = centerPos + Vector3.new(ix, 0, iz)
                    elseif style == "Christmas Tree" then
                        local normPos = (i - 1) / math.max(count, 1)
                        local treeH = Settings.Telekinesis.TreeHeight
                        local layerRadius = radius * (1 - normPos)
                        local layerHeight = treeH * normPos
                        local layerAngle = math.rad((angle * 360 + i * 30) % 360)
                        targetPos = centerPos + Vector3.new(
                            math.cos(layerAngle) * layerRadius,
                            layerHeight,
                            math.sin(layerAngle) * layerRadius
                        )
                    elseif style == "Wings" then
                        local half = math.ceil(count / 2)
                        local isLeft = i <= half
                        local side = isLeft and -1 or 1
                        local wingIdx = isLeft and (half - i + 1) or (i - half)
                        local lookVec = myRoot.CFrame.LookVector
                        local rightVec = myRoot.CFrame.RightVector
                        local backVec = -lookVec
                        local normPos = wingIdx / math.max(half, 1)
                        local minDist = 3
                        local spread = math.max(minDist, radius * normPos + minDist)
                        local yOffset = height * normPos * 0.5
                        local backOffset = radius * 0.1 * (1 - normPos * 0.3)
                        local flapY = math.sin(tick() * speed) * height * normPos
                        targetPos = myRoot.Position
                            + rightVec * side * spread
                            + backVec * backOffset
                            + Vector3.new(0, yOffset + flapY, 0)
                    elseif style == "Spiral" then
                        local spiralAngle = angle + step * (i - 1)
                        local baseY = math.sin(now * 40 + i * 2.3) * height * 3
                        local sharpY = math.sin(now * 90 + i * 5.7) * height * 1.5
                        local jitterY = baseY + sharpY
                        targetPos = centerPos + Vector3.new(
                            math.cos(spiralAngle) * radius,
                            jitterY,
                            math.sin(spiralAngle) * radius
                        )
                    else
                        targetPos = centerPos + Vector3.new(
                            math.cos(itemAngle) * radius,
                            0,
                            math.sin(itemAngle) * radius
                        )
                    end

                        if not item.drivePart or not item.drivePart.Parent then
                            item.drivePart = item.model:FindFirstChild("SoundPart")
                                or item.model:FindFirstChildWhichIsA("BasePart")
                        end
                        local drivePart = item.drivePart
                        if drivePart and drivePart.Parent then
                        local nearbyGrabPart = TelekinesisFeature.getNearbyGrabPart(item.model)

                        if nearbyGrabPart then
                            if not item.regrabRunning then                                item.regrabRunning = true
                                task.spawn(function()
                                    local dp = drivePart
                                    local mdl = item.model
                                    if not dp or not dp.Parent then item.regrabRunning = false return end
                                    local savedMyCF = myRoot.CFrame
                                    myRoot.CFrame = dp.CFrame
                                    task.wait(0.05)
                                    for _, part in ipairs(mdl:GetDescendants()) do
                                        if part:IsA("BasePart") then
                                            for i = 1, 5 do
                                                pcall(function() SetNetworkOwner:FireServer(part, myRoot.CFrame) end)
                                                task.wait(0.02)
                                            end
                                        end
                                    end
                                    pcall(function() CreateGrabLine:FireServer(dp, Vector3.zero, dp.Position, false) end)
                                    task.wait(0.02)
                                    pcall(function() DestroyGrabLine:FireServer(dp) end)
                                    task.wait(0.05)
                                    for _, part in ipairs(mdl:GetDescendants()) do
                                        if part:IsA("BasePart") then
                                            part.CanCollide = false
                                            part.Anchored = false
                                        end
                                    end
                                    local bp = dp:FindFirstChildOfClass("BodyPosition")
                                    if not bp then
                                        bp = Instance.new("BodyPosition")
            bp.MaxForce = Vector3.new(5e18, 5e18, 5e18)
                                        bp.D = 1000
                                        bp.P = 50000
                                        bp.Parent = dp
                                    end
                                    item.bp = bp
                                    local bg = dp:FindFirstChildOfClass("BodyGyro")
                                    if not bg then
                                        bg = Instance.new("BodyGyro")
                                        bg.MaxTorque = Vector3.new(5e18, 5e18, 5e18)
                                        bg.D = 1000
                                        bg.P = 50000
                                        bg.Parent = dp
                                    end
                                    item.bg = bg
                                    myRoot.CFrame = savedMyCF
                                    item.regrabRunning = false
                                end)
                            end
                        else
                            for _, part in ipairs(item.model:GetDescendants()) do
                                if part:IsA("BasePart") then
                                    part.CanCollide = false
                                end
                            end
                            if drivePart.Anchored then drivePart.Anchored = false end
                            local bp = drivePart:FindFirstChildOfClass("BodyPosition")
                            if not bp then
                                bp = Instance.new("BodyPosition")
                                bp.MaxForce = Vector3.new(5e18, 5e18, 5e18)
                                bp.D = 1000
                                bp.P = 50000
                                bp.Parent = drivePart
                            end
                            item.bp = bp
                            local bg = drivePart:FindFirstChildOfClass("BodyGyro")
                            if not bg then
                                bg = Instance.new("BodyGyro")
                                bg.MaxTorque = Vector3.new(5e18, 5e18, 5e18)
                                bg.D = 1000
                                bg.P = 50000
                                bg.Parent = drivePart
                            end
                            item.bg = bg
                            pcall(function()
                                bp.Position = targetPos
                                if Settings.Telekinesis.lookAtMe then
                                    local dirXZ = (myRoot.Position - drivePart.Position) * Vector3.new(1, 0, 1)
                                    if dirXZ.Magnitude > 0.01 then
                                        bg.CFrame = CFrame.new(drivePart.Position, drivePart.Position + dirXZ.Unit)
                                    end
                                else
                                    local targetRot = CFrame.Angles(
                                        math.rad(Settings.Telekinesis.RotX),
                                        math.rad(Settings.Telekinesis.RotY),
                                        math.rad(Settings.Telekinesis.RotZ)
                                    )
                                    bg.CFrame = CFrame.new(drivePart.Position) * targetRot
                                end
                            end)
                        end
                    end
                end
            end
        end)
    end

    function TelekinesisFeature.startSpawnedWatcher()
        if TelekinesisFeature.spawnConn then return end
        local SpawnedInToys = Workspace:FindFirstChild(LocalPlayer.Name .. "SpawnedInToys")
        if not SpawnedInToys then return end
        TelekinesisFeature.spawnConn = SpawnedInToys.ChildAdded:Connect(function(child)
            if not Settings.Telekinesis.Enabled then return end
            if not Settings.Telekinesis.TargetSpawned then return end
            local myChar = LocalPlayer.Character
            local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if not myRoot then return end
            local dp = TelekinesisFeature.getDrivePart(child)
            if not dp then return end
            local savedCF = myRoot.CFrame
            myRoot.CFrame = dp.CFrame
            task.wait(0.1)
            pcall(function() SetNetworkOwner:FireServer(dp, myRoot.CFrame) end)
            pcall(function() CreateGrabLine:FireServer(dp, Vector3.zero, dp.Position, false) end)
            pcall(function() DestroyGrabLine:FireServer(dp) end)
            task.wait(0.05)
            TelekinesisFeature.startOrbit(child, true)
            task.wait(0.05)
            myRoot.CFrame = savedCF
        end)
    end

    function TelekinesisFeature.stopSpawnedWatcher()
        if TelekinesisFeature.spawnConn then TelekinesisFeature.spawnConn:Disconnect() TelekinesisFeature.spawnConn = nil end
    end

    function TelekinesisFeature.scanPlotItems()
        local plotItems = Workspace:FindFirstChild("PlotItems")
        if not plotItems then return end
        for i = 1, 5 do
            local plotFolder = plotItems:FindFirstChild("Plot" .. i)
            if plotFolder then
                for _, model in ipairs(plotFolder:GetDescendants()) do
                    if model:IsA("Model") and not TelekinesisFeature.activeItems[model] then
                        local dp = TelekinesisFeature.getDrivePart(model)
                        if dp then
                            TelekinesisFeature.startOrbit(model, true)
                        end
                    end
                end
            end
        end
    end

    function TelekinesisFeature.scanSpawnedToys()
        local SpawnedInToys = Workspace:FindFirstChild(LocalPlayer.Name .. "SpawnedInToys")
        if not SpawnedInToys then return end
        local myChar = LocalPlayer.Character
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if not myRoot then return end
        for _, child in ipairs(SpawnedInToys:GetChildren()) do
            if not TelekinesisFeature.activeItems[child] then
                local dp = TelekinesisFeature.getDrivePart(child)
                if dp then
                    local savedCF = myRoot.CFrame
                    myRoot.CFrame = dp.CFrame
                    task.wait(0.1)
                    pcall(function() SetNetworkOwner:FireServer(dp, myRoot.CFrame) end)
                    pcall(function() CreateGrabLine:FireServer(dp, Vector3.zero, dp.Position, false) end)
                    pcall(function() SetNetworkOwner:FireServer(dp, myRoot.CFrame) end)
                    pcall(function() DestroyGrabLine:FireServer(dp) end)
                    task.wait(0.1)
                    myRoot.CFrame = savedCF
                    TelekinesisFeature.startOrbit(child, true)
                end
            end
        end
    end

    TelekinesisFeature.palletExploreConn = nil

    function TelekinesisFeature.startPalletExplore()
        if TelekinesisFeature.palletExploreConn then return end
        local function getGrabbedPart()
            local grabParts = Workspace:FindFirstChild("GrabParts")
            if not grabParts then return nil end
            for _, gp in ipairs(grabParts:GetChildren()) do
                if gp.Name == "GrabPart" then
                    local weld = gp:FindFirstChildOfClass("WeldConstraint")
                        or gp:FindFirstChildOfClass("Weld")
                        or gp:FindFirstChildOfClass("ManualWeld")
                    if weld then
                        local p0 = weld.Part0
                        local p1 = weld.Part1
                        if p1 and p1 ~= gp then return p1 end
                        if p0 and p0 ~= gp then return p0 end
                    end
                end
            end
            return nil
        end
        local dp = getGrabbedPart()
        if not dp then return end
        local targetModel = dp.Parent
        if not targetModel then return end

        local highlight = Instance.new("Highlight")
        highlight.FillColor = Color3.fromRGB(0, 170, 255)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.Parent = targetModel

        local rad = math.rad
        local function makeRot(rx, ry, rz)
            return CFrame.Angles(rad(rx), rad(ry), rad(rz))
        end

        local waypoints = {
            {pos = Vector3.new(-316.27703857421875, 56.2031364440918, -179.00755310058594), rot = makeRot(0.017999999225139618, 27.718000411987305, 0.019999999552965164), waitTime = 5},
            {pos = Vector3.new(-401.4556884765625, 28.313364028930664, -130.06117248535156), rot = makeRot(-179.7570037841797, -71.60399627685547, 179.79600524902344), waitTime = 3},
            {pos = Vector3.new(-452.55908203125, 24.746112823486328, 42.982810974121094), rot = makeRot(-0.2460000067949295, -70.1259994506836, -0.46000000834465027), waitTime = 3},
            {pos = Vector3.new(-299.23150634765625, 95.85819244384766, 217.03387451171875), rot = makeRot(0.003000000026077032, 13.48900032043457, 0.017999999225139618), waitTime = 5},
            {pos = Vector3.new(-213.0196990966797, 80.20887756347656, 396.256591796875), rot = makeRot(0.04600000008940697, -0.17499999701976776, 0.0020000000949949026), waitTime = 7},
            {pos = Vector3.new(-59.78620910644531, 156.22940063476562, 368.65545654296875), rot = makeRot(-179.89199829101562, 6.166999816894531, -179.98699951171875), waitTime = 3},
            {pos = Vector3.new(185.5255889892578, 16.997987747192383, 396.1617736816406), rot = makeRot(0.21199999749660492, 55.944000244140625, -0.12300000339746475), waitTime = 3},
            {pos = Vector3.new(223.5327911376953, 179.19735717773438, 174.54293823242188), rot = makeRot(-0.10100000351667404, 78.58100128173828, 0.17399999499320984), waitTime = 5},
            {pos = Vector3.new(-97.45641326904297, 86.93302154541016, -178.3148956298828), rot = makeRot(177.04600524902344, -32.340999603271484, 176.04100036621094), waitTime = 3},
            {pos = Vector3.new(-196.11106872558594, 82.6692123413086, -285.0792236328125), rot = makeRot(-179.74899291992188, -45.652000427246094, -179.89500427246094), waitTime = 3},
            {pos = Vector3.new(-102.37547302246094, 85.39105987548828, -210.48292541503906), rot = makeRot(-11.321999549865723, 89.36499786376953, 11.734999656677246), waitTime = 4},
            {pos = Vector3.new(451.05316162109375, 103.48825073242188, -260.166259765625), rot = makeRot(-179.8719940185547, 39.3489990234375, -179.68800354003906), waitTime = 3},
            {pos = Vector3.new(440.869140625, 153.43955993652344, -86.38394165039062), rot = makeRot(-179.30499267578125, 85.6520004272461, 179.7209930419922), waitTime = 3},
            {pos = Vector3.new(196.41908264160156, 32.962947845458984, 150.6081085205078), rot = makeRot(-0.0020000000949949026, -46.44499969482422, 0.00800000037997961), waitTime = 4},
            {pos = Vector3.new(-191.9010772705078, 26.14925765991211, -5.109410762786865), rot = makeRot(-168.9219970703125, 89.90899658203125, 168.8679962158203), waitTime = 6},
            {pos = Vector3.new(-503.68096923828125, 253.42152404785156, 382.37152099609375), rot = makeRot(179.99099731445312, -21.702999114990234, -179.93899536132812), waitTime = 4},
        }

        TelekinesisFeature.palletExploreConn = task.spawn(function()
            local maxSpeed = 80
            local arriveRadius = 1.5
            local accelDist = 5
            local decelDist = 10
            local holdSpringK = 20
            local waypointIdx = 1
            local segTotalDist = (waypoints[1].pos - dp.Position).Magnitude
            local segStartRot = dp.CFrame - dp.Position

            while Settings.Telekinesis.palletExplore do
                if not dp or not dp.Parent then break end

                local wp = waypoints[waypointIdx]
                if not wp then
                    waypointIdx = 1
                    wp = waypoints[waypointIdx]
                    segTotalDist = (wp.pos - dp.Position).Magnitude
                    segStartRot = dp.CFrame - dp.Position
                end

                local diff = wp.pos - dp.Position
                local dist = diff.Magnitude

                if dist < arriveRadius then
                    if wp.waitTime <= 0 then
                        waypointIdx = waypointIdx + 1
                        segStartRot = dp.CFrame - dp.Position
                        if waypointIdx <= #waypoints then
                            segTotalDist = (waypoints[waypointIdx].pos - dp.Position).Magnitude
                        end
                        continue
                    end

                    local elapsed = 0
                    local holdRotStart = dp.CFrame - dp.Position
                    local holdRotTime = 0.3
                    local prevVel = dp.AssemblyLinearVelocity
                    while elapsed < wp.waitTime do
                        if not Settings.Telekinesis.palletExplore then break end
                        if not dp or not dp.Parent then break end

                        local posErr = wp.pos - dp.Position
                        local springVel = posErr * holdSpringK
                        local blendIn = math.clamp(elapsed / 0.3, 0, 1)
                        dp.AssemblyLinearVelocity = prevVel:Lerp(springVel, blendIn)
                        prevVel = dp.AssemblyLinearVelocity

                        local rotBlend = math.clamp(elapsed / holdRotTime, 0, 1)
                        local smoothBlend = rotBlend * rotBlend * (3 - 2 * rotBlend)
                        dp.CFrame = CFrame.new(dp.Position) * holdRotStart:Lerp(wp.rot, smoothBlend)
                        dp.AssemblyAngularVelocity = Vector3.zero
                        dp.RotVelocity = Vector3.zero

                        local dt = RunService.Heartbeat:Wait()
                        elapsed = elapsed + dt
                    end

                    waypointIdx = waypointIdx + 1
                    segStartRot = wp.rot
                    if waypointIdx <= #waypoints then
                        segTotalDist = (waypoints[waypointIdx].pos - dp.Position).Magnitude
                    end
                else
                    local traveledDist = math.clamp(segTotalDist - dist, 0, segTotalDist)
                    local accelPhase = math.clamp(traveledDist / accelDist, 0, 1)
                    local decelPhase = math.clamp(dist / decelDist, 0, 1)
                    local speedMult = math.min(accelPhase, decelPhase)
                    speedMult = math.clamp(speedMult, 0.05, 1)
                    speedMult = speedMult * speedMult * (3 - 2 * speedMult)

                    local progress = math.clamp(traveledDist / math.max(segTotalDist, 1), 0, 1)
                    local smoothProgress = progress * progress * (3 - 2 * progress)
                    local interpRot = segStartRot:Lerp(wp.rot, smoothProgress)

                    dp.AssemblyLinearVelocity = diff.Unit * maxSpeed * speedMult
                    dp.CFrame = CFrame.new(dp.Position) * interpRot
                    dp.AssemblyAngularVelocity = Vector3.zero
                    dp.RotVelocity = Vector3.zero

                    RunService.Heartbeat:Wait()
                end
            end

            if dp and dp.Parent then
                dp.AssemblyLinearVelocity = Vector3.zero
                dp.AssemblyAngularVelocity = Vector3.zero
                dp.RotVelocity = Vector3.zero
            end
            if highlight and highlight.Parent then highlight:Destroy() end
            TelekinesisFeature.palletExploreConn = nil
        end)
    end

    function TelekinesisFeature.stopPalletExplore()
        Settings.Telekinesis.palletExplore = false
        TelekinesisFeature.palletExploreConn = nil
    end

    Settings.Telekinesis._feature = TelekinesisFeature

    local tkSec = TelekinesisTab:Section({Text = "Telekinesis"})

    tkSec:Toggle({Text = "Enabled", Flag = "TelekinesisEnabled", Default = false, Callback = function(v)
        Settings.Telekinesis.Enabled = v
        if v then
            TelekinesisFeature.runAura()
        else
            TelekinesisFeature.stopAll()
        end
    end})

    tkSec:Toggle({Text = "Grab Toys Fly", Flag = "GrabToysFly", Default = false, Callback = function(v)
        Settings.Telekinesis.grabToysFly = v
    end})

    local treeHeightFrame = nil

    tkSec:Dropdown({Text = "Style", Flag = "TelekinesisStyle", List = {"Circle", "Circle Up Down", "Square", "Heart", "Tornado", "Infinity", "Christmas Tree", "Wings"}, Callback = function(v)
        Settings.Telekinesis.Style = v
        if treeHeightFrame then
            treeHeightFrame.Visible = (v == "Christmas Tree")
        end
    end})

    tkSec:Slider({Text = "Radius", Flag = "TelekinesisRadius", Minimum = 1, Maximum = 100, Default = 15, ValueName = "", Callback = function(v)
        Settings.Telekinesis.Radius = v
    end})

    tkSec:Slider({Text = "Height", Flag = "TelekinesisHeight", Minimum = 1, Maximum = 100, Default = 5, ValueName = "", Callback = function(v)
        Settings.Telekinesis.Height = v
    end})

    tkSec:Slider({Text = "Tree Height", Flag = "TelekinesisTreeHeight", Minimum = 1, Maximum = 100, Default = 20, ValueName = "", Callback = function(v)
        Settings.Telekinesis.TreeHeight = v
    end})

    task.delay(0.5, function()
        pcall(function()
            local function findTreeHeightFrame(parent)
                for _, child in ipairs(parent:GetDescendants()) do
                    if child:IsA("TextLabel") and child.Text == "Tree Height" then
                        local frame = child
                        while frame and frame.Parent do
                            if frame:IsA("Frame") and frame.Parent and frame.Parent:IsA("Frame") then
                                return frame
                            end
                            frame = frame.Parent
                        end
                        return child.Parent
                    end
                end
                return nil
            end
            local gui = CoreGui:FindFirstChild("Library") or CoreGui:FindFirstChildWhichIsA("ScreenGui")
            if not gui then
                gui = PlayerGui:FindFirstChildWhichIsA("ScreenGui")
            end
            if gui then
                treeHeightFrame = findTreeHeightFrame(gui)
                if treeHeightFrame then
                    treeHeightFrame.Visible = (Settings.Telekinesis.Style == "Christmas Tree")
                end
            end
        end)
    end)

    tkSec:Slider({Text = "Speed", Flag = "TelekinesisSpeed", Minimum = 1, Maximum = 50, Default = 2, ValueName = "", Callback = function(v)
        Settings.Telekinesis.Speed = v
    end})

    tkSec:Toggle({Text = "CrazyRadius", Flag = "TelekinesisCrazyRadius", Default = false, Callback = function(v)
        Settings.Telekinesis.crazyRadius = v
    end})

    tkSec:Slider({Text = "Rotation X", Flag = "TelekinesisRotX", Minimum = -180, Maximum = 180, Default = 0, ValueName = "Â°", Callback = function(v)
        Settings.Telekinesis.RotX = v
    end})

    tkSec:Slider({Text = "Rotation Y", Flag = "TelekinesisRotY", Minimum = -180, Maximum = 180, Default = 0, ValueName = "Â°", Callback = function(v)
        Settings.Telekinesis.RotY = v
    end})

    tkSec:Slider({Text = "Rotation Z", Flag = "TelekinesisRotZ", Minimum = -180, Maximum = 180, Default = 0, ValueName = "Â°", Callback = function(v)
        Settings.Telekinesis.RotZ = v
    end})

    tkSec:Toggle({Text = "Look At Me", Flag = "TelekinesisLookAtMe", Default = false, Callback = function(v)
        Settings.Telekinesis.lookAtMe = v
    end})

    tkSec:Keybind({Text = "Set Main Part", Flag = "TkSetMainPart", Callback = function()
        local mouse = LocalPlayer:GetMouse()
        local target = mouse.Target
        if target and target:IsA("BasePart") then
            Settings.Telekinesis.CustomMainPart = target
        end
    end})

    tkSec:Keybind({Text = "Reset Main Part", Flag = "TkResetMainPart", Callback = function()
        Settings.Telekinesis.CustomMainPart = nil
    end})

    
    
    
    ;(function()
    local tkFreezeSec = TelekinesisTab:Section({Text = "Freeze Objects", Side = "Right"})
    local frozenParts = {}
    local mainPart = nil
    local savedRelCFs = {}
    local freezeConn = nil
    local freezeRotateEnabled = false
    local freezeRotateSpeed = 1
    local freezeRotateAngle = 0
    local lockedRotations = {}

    local function getGrabbedPart()
        local grabParts = Workspace:FindFirstChild("GrabParts")
        if not grabParts then return nil end
        for _, gp in ipairs(grabParts:GetChildren()) do
            if gp.Name == "GrabPart" then
                local weld = gp:FindFirstChildOfClass("WeldConstraint")
                    or gp:FindFirstChildOfClass("Weld")
                    or gp:FindFirstChildOfClass("ManualWeld")
                if weld then
                    local p0 = weld.Part0
                    local p1 = weld.Part1
                    if p1 and p1 ~= gp then return p1 end
                    if p0 and p0 ~= gp then return p0 end
                end
            end
        end
        return nil
    end

    local function getGrabTargetFromGP(gp)
        if not gp then return nil end
        local weld = gp:FindFirstChildOfClass("WeldConstraint")
            or gp:FindFirstChildOfClass("Weld")
            or gp:FindFirstChildOfClass("ManualWeld")
        if not weld then return nil end
        local p0 = weld.Part0
        local p1 = weld.Part1
        if p1 and p1 ~= gp then return p1 end
        if p0 and p0 ~= gp then return p0 end
        return nil
    end

    local function ensureBodyMovers(part, data)
        if not data.bp or data.bp.Parent ~= part then
            data.bp = part:FindFirstChildOfClass("BodyPosition") or Instance.new("BodyPosition")
            data.bp.MaxForce = Vector3.new(5e18, 5e18, 5e18)
            data.bp.D = 1000
            data.bp.P = 50000
            data.bp.Parent = part
        end
        if not data.bg or data.bg.Parent ~= part then
            data.bg = part:FindFirstChildOfClass("BodyGyro") or Instance.new("BodyGyro")
            data.bg.MaxTorque = Vector3.new(5e18, 5e18, 5e18)
            data.bg.D = 1000
            data.bg.P = 50000
            data.bg.Parent = part
        end
    end

    local function applyMovers(part, targetCF)
        local data = frozenParts[part]
        if not data then return end
        ensureBodyMovers(part, data)
        data.bp.Position = targetCF.Position
        data.bg.CFrame = CFrame.new(part.Position) * targetCF.Rotation
    end

    local function startFreezeLoop()
        if freezeConn then
            freezeConn:Disconnect()
            freezeConn = nil
        end
        local lastTime = tick()
        freezeConn = RunService.RenderStepped:Connect(function()
            local now = tick()
            local dt = math.max(now - lastTime, 0.001)
            lastTime = now

            if not next(frozenParts) then
                freezeConn:Disconnect()
                freezeConn = nil
                return
            end

            if freezeRotateEnabled and mainPart and mainPart.Parent then
                freezeRotateAngle = freezeRotateAngle + freezeRotateSpeed * 0.5 * dt
            end

            local toRemove = {}
            local myChar = LocalPlayer.Character
            local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
            local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
            local seatPart = myHum and myHum.SeatPart

            local rotMaxSpeed = 100
            local rotSpringK = 25

            for part, data in pairs(frozenParts) do
                if not part or not part.Parent then
                    table.insert(toRemove, part)
                elseif mainPart and mainPart.Parent then
                    local rel = savedRelCFs[part]
                    if not rel then
                        rel = mainPart.CFrame:ToObjectSpace(part.CFrame)
                        savedRelCFs[part] = rel
                    end
                    local rotatedRel = CFrame.Angles(0, freezeRotateAngle, 0) * rel
                    local targetCF = mainPart.CFrame:ToWorldSpace(rotatedRel)

                    if freezeRotateEnabled then
                        if data.bp then data.bp.MaxForce = Vector3.zero end
                        if data.bg then
                            data.bg.MaxTorque = Vector3.new(5e18, 5e18, 5e18)
                            if Settings.Telekinesis.freezeLookAtMain then
                                data.bg.CFrame = targetCF.Rotation
                            else
                                data.bg.CFrame = lockedRotations[part] or part.CFrame.Rotation
                            end
                        end

                        local diff = targetCF.Position - part.Position
                        local dist = diff.Magnitude
                        local speedMult = math.clamp(dist / 3, 0.05, 1)
                        speedMult = speedMult * speedMult * (3 - 2 * speedMult)

                        part.AssemblyLinearVelocity = diff.Unit * rotMaxSpeed * speedMult
                        part.AssemblyAngularVelocity = Vector3.zero
                        part.RotVelocity = Vector3.zero
                    else
                        ensureBodyMovers(part, data)
                        data.bp.MaxForce = Vector3.new(5e18, 5e18, 5e18)
                        data.bg.MaxTorque = Vector3.new(5e18, 5e18, 5e18)
                        data.bp.Position = targetCF.Position
                        data.bg.CFrame = CFrame.new(part.Position) * targetCF.Rotation
                    end
                elseif data.savedCF then
                    ensureBodyMovers(part, data)
                    data.bp.MaxForce = Vector3.new(5e18, 5e18, 5e18)
                    data.bg.MaxTorque = Vector3.new(5e18, 5e18, 5e18)
                    data.bp.Position = data.savedCF.Position
                    data.bg.CFrame = CFrame.new(part.Position) * data.savedCF.Rotation
                end
            end

            if freezeRotateEnabled and myRoot and myHum and seatPart and frozenParts[seatPart] then
                local partData = frozenParts[seatPart]
                local partRel = savedRelCFs[seatPart]
                if partRel and mainPart and mainPart.Parent then
                    local rotatedRel = CFrame.Angles(0, freezeRotateAngle, 0) * partRel
                    local partTarget = mainPart.CFrame:ToWorldSpace(rotatedRel)
                    local playerRel = partData._playerRel
                    if not playerRel then
                        playerRel = seatPart.CFrame:ToObjectSpace(myRoot.CFrame)
                        partData._playerRel = playerRel
                    end
                    local targetCF = partTarget:ToWorldSpace(playerRel)

                    local diff = targetCF.Position - myRoot.Position
                    local dist = diff.Magnitude
                    local speedMult = math.clamp(dist / 3, 0.05, 1)
                    speedMult = speedMult * speedMult * (3 - 2 * speedMult)

                    myRoot.AssemblyLinearVelocity = diff.Unit * rotMaxSpeed * speedMult
                    myRoot.AssemblyAngularVelocity = Vector3.zero
                    myRoot.RotVelocity = Vector3.zero
                end
            end

            for _, part in ipairs(toRemove) do
                local data = frozenParts[part]
                if data then
                    if data.bp and data.bp.Parent then data.bp:Destroy() end
                    if data.bg and data.bg.Parent then data.bg:Destroy() end
                end
                frozenParts[part] = nil
                savedRelCFs[part] = nil
            end
        end)
    end

    local freezeHighlights = {}
    local function updateFreezeHighlights()
        if not Settings.Telekinesis.freezeHighlight then return end
        for part, h in pairs(freezeHighlights) do
            if not part or not part.Parent then
                if h and h.Parent then h:Destroy() end
                freezeHighlights[part] = nil
            end
        end
        local function addHighlight(part, color)
            if not part or not part.Parent then return end
            if freezeHighlights[part] then
                freezeHighlights[part].FillColor = color
                return
            end
            local h = Instance.new("Highlight")
            h.Name = "_FreezeHL"
            h.FillColor = color
            h.FillTransparency = 0.5
            h.OutlineColor = Color3.fromRGB(255, 255, 255)
            h.OutlineTransparency = 0
            h.Parent = part.Parent
            freezeHighlights[part] = h
        end
        if mainPart and mainPart.Parent then
            addHighlight(mainPart, Color3.fromRGB(255, 255, 255))
        end
        for part, _ in pairs(frozenParts) do
            if part ~= mainPart then
                addHighlight(part, Color3.fromRGB(128, 128, 128))
            end
        end
    end
    local function clearFreezeHighlights()
        for part, h in pairs(freezeHighlights) do
            if h and h.Parent then h:Destroy() end
        end
        freezeHighlights = {}
    end

    local function addFreeze(part)
        if not part or not part.Parent or frozenParts[part] then return end
        local savedCF = part.CFrame
        local bp = part:FindFirstChildOfClass("BodyPosition") or Instance.new("BodyPosition")
        bp.MaxForce = Vector3.new(5e18, 5e18, 5e18)
        bp.D = 1000
        bp.P = 50000
        bp.Position = savedCF.Position
        bp.Parent = part
        local bg = part:FindFirstChildOfClass("BodyGyro") or Instance.new("BodyGyro")
        bg.MaxTorque = Vector3.new(5e18, 5e18, 5e18)
        bg.D = 1000
        bg.P = 50000
        bg.CFrame = savedCF.Rotation
        bg.Parent = part
        frozenParts[part] = {bp = bp, bg = bg, savedCF = savedCF}
        if mainPart and mainPart.Parent and part ~= mainPart then
            savedRelCFs[part] = mainPart.CFrame:ToObjectSpace(part.CFrame)
        end
    end

    local function applyFreeze(part)
        addFreeze(part)
        startFreezeLoop()
        if Settings.Telekinesis.freezeHighlight then updateFreezeHighlights() end
    end

    local function removeFreeze(part)
        local data = frozenParts[part]
        if data then
            if data.bp and data.bp.Parent then data.bp:Destroy() end
            if data.bg and data.bg.Parent then data.bg:Destroy() end
            frozenParts[part] = nil
            savedRelCFs[part] = nil
        end
        local h = freezeHighlights[part]
        if h and h.Parent then h:Destroy() end
        freezeHighlights[part] = nil
    end

    local function clearAllFreezes()
        if freezeConn then freezeConn:Disconnect() freezeConn = nil end
        for part, _ in pairs(frozenParts) do
            removeFreeze(part)
        end
        frozenParts = {}
        savedRelCFs = {}
        mainPart = nil
        clearFreezeHighlights()
    end

    tkFreezeSec:Keybind({Text = "Freeze Hold Object", Flag = "FreezeHoldObject", Callback = function()
        local part = getGrabbedPart()
        applyFreeze(part)
    end})

    tkFreezeSec:Keybind({Text = "Reset Freeze Grabs", Flag = "ResetFreezeGrabs", Callback = function()
        clearAllFreezes()
    end})

    tkFreezeSec:Keybind({Text = "Set Main Part", Flag = "FreezeSetMainPart", Callback = function()
        local part = nil
        local grabbed = getGrabbedPart()
        if grabbed and grabbed.Parent then
            part = grabbed
        end
        if not part then
            local mouse = LocalPlayer:GetMouse()
            local target = mouse and mouse.Target
            if target and target:IsA("BasePart") and frozenParts[target] then
                part = target
            end
        end
        if not part then
            for k in pairs(frozenParts) do
                if k and k.Parent then part = k break end
            end
        end
        if not part or not part.Parent then return end

        mainPart = part
        mainPartSavedCF = mainPart.CFrame
        if frozenParts[part] then
            local data = frozenParts[part]
            if data.bp and data.bp.Parent then data.bp:Destroy() end
            if data.bg and data.bg.Parent then data.bg:Destroy() end
            frozenParts[part] = nil
        end
        savedRelCFs[part] = nil
        mainPart.Anchored = false

        local grabParts = Workspace:FindFirstChild("GrabParts")
        if grabParts then
            for _, gp in ipairs(grabParts:GetChildren()) do
                if gp.Name == "GrabPart" then
                    local other = getGrabTargetFromGP(gp)
                    if other and other ~= mainPart and other.Parent and not frozenParts[other] then
                        addFreeze(other)
                    end
                end
            end
        end

        local mainCF = mainPart.CFrame
        savedRelCFs = {}
        for otherPart in pairs(frozenParts) do
            if otherPart ~= mainPart and otherPart and otherPart.Parent then
                savedRelCFs[otherPart] = mainCF:ToObjectSpace(otherPart.CFrame)
            end
        end

        if Settings.Telekinesis.freezeHighlight then updateFreezeHighlights() end
        startFreezeLoop()
    end})

    tkFreezeSec:Keybind({Text = "Reset Main Part", Flag = "FreezeResetMainPart", Callback = function()
        if mainPart then
            local h = freezeHighlights[mainPart]
            if h and h.Parent then h:Destroy() end
            freezeHighlights[mainPart] = nil
        end
        mainPart = nil
        mainPartSavedCF = nil
        savedRelCFs = {}
        if Settings.Telekinesis.freezeHighlight then updateFreezeHighlights() end
    end})

    local autoRecoverConn = nil
    local autoRecoverCooldown = 0
    local mainPartSavedCF = nil
    tkFreezeSec:Toggle({Text = "Auto Recover", Flag = "FreezeAutoRecover", Default = false, Callback = function(v)
        Settings.Telekinesis.freezeAutoRecover = v
        if v then
            autoRecoverCooldown = 0
            autoRecoverConn = RunService.Heartbeat:Connect(function(dt)
                autoRecoverCooldown = autoRecoverCooldown - dt
                if autoRecoverCooldown > 0 then return end
                if not next(frozenParts) and not mainPart then return end
                local myChar = LocalPlayer.Character
                local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
                if not myRoot then return end

                local driftThreshold = 5
                local grabThreshold = 10

                local function doRecover(held)
                    autoRecoverCooldown = 0.5
                    local savedCF = myRoot.CFrame
                    myRoot.CFrame = held.CFrame
                    task.delay(0.1, function()
                        pcall(function() setNetworkOwnerEvent:FireServer(held, myRoot.CFrame) end)
                        task.delay(0.1, function()
                            local r = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                            if r then r.CFrame = savedCF end
                        end)
                    end)
                end

                local myFolder = Workspace:FindFirstChild(LocalPlayer.Name)
                local myGrabParts = myFolder and myFolder:FindFirstChild("GrabParts")
                local function isMyGrabbing(part)
                    if not myGrabParts then return false end
                    for _, gp in ipairs(myGrabParts:GetChildren()) do
                        if gp.Name == "GrabPart" and gp.Parent and (gp.Position - part.Position).Magnitude < grabThreshold then
                            return true
                        end
                    end
                    return false
                end

                for part, data in pairs(frozenParts) do
                    if not part or not part.Parent then continue end
                    if isMyGrabbing(part) then continue end
                    local expectedPos = nil
                    if mainPart and mainPart.Parent and savedRelCFs[part] then
                        local rotatedRel = CFrame.Angles(0, freezeRotateAngle, 0) * savedRelCFs[part]
                        expectedPos = mainPart.CFrame:ToWorldSpace(rotatedRel).Position
                    elseif data.savedCF then
                        expectedPos = data.savedCF.Position
                    end
                    if expectedPos and (part.Position - expectedPos).Magnitude > driftThreshold then
                        doRecover(part)
                        return
                    end
                end

                if mainPart and mainPart.Parent and mainPartSavedCF then
                    if not isMyGrabbing(mainPart) and (mainPart.Position - mainPartSavedCF.Position).Magnitude > driftThreshold then
                        doRecover(mainPart)
                        return
                    end
                end

                for _, player in ipairs(Players:GetPlayers()) do
                    if player == LocalPlayer then continue end
                    local pFolder = Workspace:FindFirstChild(player.Name)
                    if not pFolder then continue end
                    local folder = pFolder:FindFirstChild("GrabParts")
                    if not folder then continue end
                    for _, gp in ipairs(folder:GetChildren()) do
                        if gp.Name ~= "GrabPart" then continue end
                        if not gp.Parent then continue end
                        local gpPos = gp.Position
                        for held, _ in pairs(frozenParts) do
                            if held and held.Parent and (gpPos - held.Position).Magnitude < grabThreshold then
                                doRecover(held)
                                return
                            end
                        end
                        if mainPart and mainPart.Parent and (gpPos - mainPart.Position).Magnitude < grabThreshold then
                            doRecover(mainPart)
                            return
                        end
                    end
                end
            end)
        else
            if autoRecoverConn then autoRecoverConn:Disconnect() autoRecoverConn = nil end
            mainPartSavedCF = nil
        end
    end})

    tkFreezeSec:Toggle({Text = "Highlight", Flag = "FreezeHighlight", Default = false, Callback = function(v)
        Settings.Telekinesis.freezeHighlight = v
        if v then
            updateFreezeHighlights()
        else
            clearFreezeHighlights()
        end
    end})

    tkFreezeSec:Toggle({Text = "Look At Main Part", Flag = "FreezeLookAtMain", Default = true, Callback = function(v)
        Settings.Telekinesis.freezeLookAtMain = v
        if not v then
            lockedRotations = {}
            for part, _ in pairs(frozenParts) do
                lockedRotations[part] = part.CFrame.Rotation
            end
            if mainPart and mainPart.Parent then
                lockedRotations[mainPart] = mainPart.CFrame.Rotation
            end
        end
    end})

    tkFreezeSec:Toggle({Text = "Rotate", Flag = "FreezeRotate", Default = false, Callback = function(v)
        freezeRotateEnabled = v
        if not v then
            for part, rel in pairs(savedRelCFs) do
                savedRelCFs[part] = CFrame.Angles(0, freezeRotateAngle, 0) * rel
            end
            freezeRotateAngle = 0
            for _, part in pairs(frozenParts) do
                part._playerRel = nil
            end
        end
    end})

    tkFreezeSec:Slider({Text = "Rotate Speed", Flag = "FreezeRotateSpeed", Minimum = 0.1, Maximum = 10, Default = 1, ValueName = "x", Callback = function(v)
        freezeRotateSpeed = v
    end})
    end)()

    
    
    
    end
    ;(function()
    local tkControlSec = TelekinesisTab:Section({Text = "Control", Side = "Right"})

    local controlState = {
        active = false,
        model = nil,
        soundPart = nil,
        anchor = nil,
        drivePart = nil,
        bodyPos = nil,
        bodyGyro = nil,
        charBodyPos = nil,
        savedWalkSpeed = 16,
        savedJumpPower = 50,
        savedJumpHeight = 7.2,
        savedParts = {},
        savedHumanoid = nil,
        charOffset = -12,
        conns = {},
        camYaw = 0,
        camPitch = 0,
        camDist = 25,
        anotherCamera = false,
        setOwnerConn = nil,
    }

    local function stopControl()
        controlState.active = false
        local sp = controlState.soundPart
        local spPos = sp and sp.Parent and sp.Position
        for _, c in ipairs(controlState.conns) do
            if typeof(c) == "RBXScriptConnection" then
                pcall(function() c:Disconnect() end)
            elseif type(c) == "thread" then
                pcall(function() task.cancel(c) end)
            end
        end
        controlState.conns = {}
        if controlState.setOwnerConn then
            controlState.setOwnerConn:Disconnect()
            controlState.setOwnerConn = nil
        end
        local ch = LocalPlayer.Character
        local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
        local hm = ch and ch:FindFirstChildOfClass("Humanoid")
        LocalPlayer.CameraMinZoomDistance = 0.5
        LocalPlayer.CameraMaxZoomDistance = 128
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        local cam = Workspace.CurrentCamera
        cam.CameraType = Enum.CameraType.Custom
        if hm then cam.CameraSubject = hm end
        if hrp and spPos then
            hrp.CFrame = CFrame.new(spPos.X, spPos.Y + 5, spPos.Z)
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
        end
        if ch then
            for _, p in ipairs(ch:GetDescendants()) do
                if p:IsA("BasePart") then
                    for _, m in ipairs(p:GetChildren()) do
                        if m:IsA("BodyPosition") or m:IsA("BodyVelocity") or m:IsA("BodyGyro") or m:IsA("BodyForce") or m:IsA("BodyThrust") then
                            m:Destroy()
                        end
                    end
                end
            end
        end
        if controlState.bodyPos and controlState.bodyPos.Parent then
            controlState.bodyPos:Destroy()
        end
        if controlState.bodyGyro and controlState.bodyGyro.Parent then
            controlState.bodyGyro:Destroy()
        end
        if controlState.charBodyPos and controlState.charBodyPos.Parent then
            controlState.charBodyPos:Destroy()
        end
        for p, data in pairs(controlState.savedParts) do
            if p and p.Parent then
                p.CanCollide = data.CanCollide
                p.Anchored = data.Anchored
                p.AssemblyLinearVelocity = data.AssemblyLinearVelocity
                p.AssemblyAngularVelocity = data.AssemblyAngularVelocity
            end
        end
        controlState.savedParts = {}
        if controlState.anchor then
            controlState.anchor.CanCollide = false
            controlState.anchor.Anchored = true
            controlState.anchor:Destroy()
            controlState.anchor = nil
        end
        controlState.bodyPos = nil
        controlState.bodyGyro = nil
        controlState.charBodyPos = nil
        controlState.drivePart = nil
        controlState.model = nil
        controlState.soundPart = nil
        controlState.camYaw = 0
        controlState.camPitch = 0
        controlState.camDist = 25
        if hm and controlState.savedHumanoid then
            hm.WalkSpeed = controlState.savedHumanoid.WalkSpeed
            hm.JumpPower = controlState.savedHumanoid.JumpPower
            hm.JumpHeight = controlState.savedHumanoid.JumpHeight
            hm.PlatformStand = controlState.savedHumanoid.PlatformStand
            hm:ChangeState(Enum.HumanoidStateType.Running)
        end
        controlState.savedHumanoid = nil
    end

    local function startControl()
        local cam = Workspace.CurrentCamera
        local rayOrigin = cam.CFrame.Position
        local rayDir = cam.CFrame.LookVector * 1000
        local rp = RaycastParams.new()
        rp.FilterType = Enum.RaycastFilterType.Exclude
        local ch = LocalPlayer.Character
        if ch then rp.FilterDescendantsInstances = {ch} end
        local result = Workspace:Raycast(rayOrigin, rayDir, rp)
        if not result or not result.Instance then
            warn("[Control] Not looking at any Part")
            return false
        end
        local hitPart = result.Instance
        local model = hitPart:FindFirstAncestorOfClass("Model")
        if not model or model == Workspace then
            warn("[Control] Hit part has no model ancestor")
            return false
        end
        local soundPart = model:FindFirstChild("SoundPart", true)
        local drivePart = soundPart
        local charOffset = -12
        if not drivePart then
            drivePart = model:FindFirstChild("HumanoidRootPart", true)
            charOffset = -12
        end
        if not drivePart then
            warn("[Control] No SoundPart or HumanoidRootPart found")
            return false
        end
        local myChar = LocalPlayer.Character
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
        local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
        if not myRoot or not myHum then
            warn("[Control] No character")
            return false
        end

        controlState.model = model
        controlState.soundPart = drivePart
        controlState.charOffset = charOffset

        controlState.savedParts = {}
        for _, p in ipairs(myChar:GetDescendants()) do
            if p:IsA("BasePart") then
                controlState.savedParts[p] = {
                    CanCollide = p.CanCollide,
                    Anchored = p.Anchored,
                    CFrame = p.CFrame,
                    AssemblyLinearVelocity = p.AssemblyLinearVelocity,
                    AssemblyAngularVelocity = p.AssemblyAngularVelocity,
                }
            end
        end
        controlState.savedHumanoid = nil
        if myHum then
            controlState.savedHumanoid = {
                WalkSpeed = myHum.WalkSpeed,
                JumpPower = myHum.JumpPower,
                JumpHeight = myHum.JumpHeight,
                PlatformStand = myHum.PlatformStand,
            }
        end

        myRoot.CFrame = CFrame.new(drivePart.Position.X, drivePart.Position.Y + charOffset, drivePart.Position.Z)
        myRoot.AssemblyLinearVelocity = Vector3.zero
        myRoot.AssemblyAngularVelocity = Vector3.zero

        local charBp = Instance.new("BodyPosition")
        charBp.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        charBp.D = 500
        charBp.P = 1e5
        charBp.Position = Vector3.new(drivePart.Position.X, drivePart.Position.Y + charOffset, drivePart.Position.Z)
        charBp.Parent = myRoot
        controlState.charBodyPos = charBp

        controlState.savedWalkSpeed = myHum.WalkSpeed
        controlState.savedJumpPower = myHum.JumpPower
        controlState.savedJumpHeight = myHum.JumpHeight
        myHum.WalkSpeed = 0
        myHum.JumpPower = 0
        myHum.JumpHeight = 0

        local anchor = Instance.new("Part")
        anchor.Name = "ControlCameraAnchor"
        anchor.Size = Vector3.new(1, 1, 1)
        anchor.Transparency = 1
        anchor.CanCollide = false
        anchor.Anchored = true
        anchor.CFrame = CFrame.new(drivePart.Position)
        anchor.Parent = Workspace
        controlState.anchor = anchor

        cam.CameraSubject = anchor
        cam.CameraType = Enum.CameraType.Scriptable
        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
        controlState.camYaw = 0
        controlState.camPitch = 0
        controlState.camDist = 25

        controlState.active = true

        task.wait(0.1)

        for _, part in ipairs(model:GetDescendants()) do
            if part:IsA("BasePart") then
                pcall(function() setNetworkOwnerEvent:FireServer(part, part.CFrame) end)
                pcall(function() setNetworkOwnerEvent:FireServer(part, part.CFrame) end)
            end
        end

        local dp = drivePart
        if dp.Anchored then dp.Anchored = false end

        local bp = dp:FindFirstChildOfClass("BodyPosition")
        if not bp then
            bp = Instance.new("BodyPosition")
            bp.MaxForce = Vector3.new(5e18, 0, 5e18)
            bp.D = 500
            bp.P = 10000
            bp.Position = dp.Position
            bp.Parent = dp
        end
        controlState.bodyPos = bp

        local bg = dp:FindFirstChildOfClass("BodyGyro")
        if not bg then
            bg = Instance.new("BodyGyro")
            bg.MaxTorque = Vector3.new(5e18, 0, 5e18)
            bg.D = 500
            bg.P = 10000
            bg.CFrame = dp.CFrame
            bg.Parent = dp
        end
        controlState.bodyGyro = bg

        for _, part in ipairs(model:GetDescendants()) do
            if part:IsA("BasePart") then
                part.AssemblyLinearVelocity = Vector3.zero
                part.AssemblyAngularVelocity = Vector3.zero
                part.Anchored = false
            end
        end
        controlState.drivePart = dp

        controlState.setOwnerConn = RunService.Heartbeat:Connect(function()
            if not controlState.active then return end
            local sp = controlState.soundPart
            if sp and sp.Parent then
                pcall(function() setNetworkOwnerEvent:FireServer(sp, sp.CFrame) end)
            end
        end)

        table.insert(controlState.conns, UserInputService.InputChanged:Connect(function(input)
            if not controlState.active then return end
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                local d = input.Delta
                if d then
                    controlState.camYaw = controlState.camYaw - d.X * 0.006
                    controlState.camPitch = math.clamp(controlState.camPitch + d.Y * 0.006, -math.pi / 2 + math.rad(10), math.pi / 2 - math.rad(10))
                end
            end
            if input.UserInputType == Enum.UserInputType.MouseWheel then
                controlState.camDist = math.clamp(controlState.camDist - input.Position.Z * 3, 8, 80)
            end
        end))

        table.insert(controlState.conns, RunService.Stepped:Connect(function()
            if not controlState.active then return end
            local c = LocalPlayer.Character
            if c then
                for _, p in ipairs(c:GetDescendants()) do
                    if p:IsA("BasePart") then p.CanCollide = false end
                end
            end
        end))

        table.insert(controlState.conns, RunService.Heartbeat:Connect(function()
            if not controlState.active then return end
            local dp5 = controlState.drivePart
            local mdl3 = controlState.model
            if dp5 and dp5.Parent then
                local anchPos = dp5.Position
                if mdl3 then
                    local head2 = mdl3:FindFirstChild("Head", true)
                    if head2 and head2:IsA("BasePart") then
                        anchPos = head2.Position + Vector3.new(0, head2.Size.Y / 2, 0)
                    end
                end
                anchor.CFrame = CFrame.new(anchPos)
            end
        end))

        local keysDown = {}
        table.insert(controlState.conns, UserInputService.InputBegan:Connect(function(input, gpe)
            if gpe or not controlState.active then return end
            keysDown[input.KeyCode] = true
            if input.KeyCode == Enum.KeyCode.Space then
                local dp6 = controlState.drivePart
                if dp6 and dp6.Parent then
                    controlState.isJumping = true
                    dp6.AssemblyLinearVelocity = Vector3.new(0, 17, 0)
                    task.delay(0.3, function()
                        controlState.isJumping = false
                    end)
                end
            end
            if input.KeyCode == Enum.KeyCode.F then
                local cam2 = Workspace.CurrentCamera
                local camPos = cam2.CFrame.Position
                local camLook = cam2.CFrame.LookVector
                local bestPlayer = nil
                local bestScore = math.huge
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character then
                        local hrp2 = p.Character:FindFirstChild("HumanoidRootPart")
                        local hum2 = p.Character:FindFirstChildOfClass("Humanoid")
                        if hrp2 and hum2 and hum2.Health > 0 then
                            local toPlayer = (hrp2.Position - camPos)
                            local dist = toPlayer.Magnitude
                            if dist > 0 and dist < 500 then
                                local dir = toPlayer.Unit
                                local dot = dir:Dot(camLook)
                                local score = (1 - dot) * dist
                                if score < bestScore then
                                    bestScore = score
                                    bestPlayer = p
                                end
                            end
                        end
                    end
                end
                if bestPlayer and bestPlayer.Character then
                    local targetHRP = bestPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if targetHRP then
                        pcall(function() setNetworkOwnerEvent:FireServer(targetHRP, targetHRP.CFrame) end)
                        pcall(function() setNetworkOwnerEvent:FireServer(targetHRP, targetHRP.CFrame) end)
                        local flingDir = (targetHRP.Position - camPos).Unit
                        targetHRP.AssemblyLinearVelocity = -flingDir * 30
                    end
                end
            end
        end))
        table.insert(controlState.conns, UserInputService.InputEnded:Connect(function(input)
            keysDown[input.KeyCode] = nil
        end))

        local lastJumpCheck = 0
        table.insert(controlState.conns, RunService.Heartbeat:Connect(function()
            if not controlState.active then return end
            local now = tick()
            if now - lastJumpCheck < 0.05 then return end
            lastJumpCheck = now
            local c = LocalPlayer.Character
            local hrp = c and c:FindFirstChild("HumanoidRootPart")
            local hum = c and c:FindFirstChildOfClass("Humanoid")
            local dp = controlState.drivePart
            if hrp and hum and dp and dp.Parent then
                local onObject = false
                for _, part in ipairs(controlState.model:GetDescendants()) do
                    if part:IsA("BasePart") then
                        local dist = (hrp.Position - part.Position).Magnitude
                        if dist < (part.Size.Magnitude / 2 + 3) then
                            onObject = true
                            break
                        end
                    end
                end
            end
        end))

        table.insert(controlState.conns, RunService.RenderStepped:Connect(function(dt)
            if not controlState.active then return end
            local cam = Workspace.CurrentCamera
            if cam.CameraType ~= Enum.CameraType.Scriptable then
                cam.CameraType = Enum.CameraType.Scriptable
            end
            if cam.CameraSubject ~= anchor then
                cam.CameraSubject = anchor
            end
            local move = Vector3.zero
            local camCF = cam.CFrame
            local lookFlat = Vector3.new(camCF.LookVector.X, 0, camCF.LookVector.Z)
            local rightFlat = Vector3.new(camCF.RightVector.X, 0, camCF.RightVector.Z)
            if lookFlat.Magnitude > 0.001 then lookFlat = lookFlat.Unit end
            if rightFlat.Magnitude > 0.001 then rightFlat = rightFlat.Unit end
            if keysDown[Enum.KeyCode.W] then move = move + lookFlat end
            if keysDown[Enum.KeyCode.S] then move = move - lookFlat end
            if keysDown[Enum.KeyCode.A] then move = move - rightFlat end
            if keysDown[Enum.KeyCode.D] then move = move + rightFlat end
            if move.Magnitude > 0.001 then
                move = move.Unit
                local speed = 50
                local bp7 = controlState.bodyPos
                if bp7 and bp7.Parent then
                    bp7.Position = bp7.Position + move * speed * dt
                end
            end
            local dp7 = controlState.drivePart
            if dp7 and dp7.Parent then
                local vel = dp7.AssemblyLinearVelocity
                local maxUp = controlState.isJumping and 17 or 3
                dp7.AssemblyLinearVelocity = Vector3.new(0, math.clamp(vel.Y, -200, maxUp), 0)
                dp7.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            end
            local mdl = controlState.model
            local cbp = controlState.charBodyPos
            local dp4 = controlState.drivePart
            if mdl and cbp and cbp.Parent and dp4 and dp4.Parent then
                cbp.Position = Vector3.new(dp4.Position.X, dp4.Position.Y + controlState.charOffset, dp4.Position.Z)
            end
            local c = LocalPlayer.Character
            local hrp = c and c:FindFirstChild("HumanoidRootPart")
            if hrp and cbp and cbp.Parent then
                local lookDir = Vector3.new(math.sin(controlState.camYaw), 0, math.cos(controlState.camYaw))
                hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + lookDir)
            end
            local bp2 = controlState.bodyPos
            local dp2 = controlState.drivePart
            if bp2 and bp2.Parent and dp2 and dp2.Parent then
                local mdl2 = controlState.model
                local spPos = dp2.Position
                if mdl2 then
                    local head = mdl2:FindFirstChild("Head", true)
                    if head and head:IsA("BasePart") then
                        spPos = head.Position + Vector3.new(0, head.Size.Y / 2, 0)
                    end
                end
                local yaw = controlState.camYaw
                local pitch = controlState.camPitch
                local dist = controlState.camDist
                if controlState.anotherCamera then
                    local camPos = spPos + Vector3.new(0, 3, 0)
                    local lookDir = Vector3.new(math.sin(yaw), -math.tan(pitch), math.cos(yaw))
                    Workspace.CurrentCamera.CFrame = CFrame.new(camPos, camPos + lookDir)
                else
                    local camPos = spPos + Vector3.new(
                        math.cos(pitch) * math.sin(yaw) * dist,
                        math.sin(pitch) * dist,
                        math.cos(pitch) * math.cos(yaw) * dist
                    )
                    Workspace.CurrentCamera.CFrame = CFrame.new(camPos, spPos)
                end
                local bg2 = controlState.bodyGyro
                if bg2 and bg2.Parent then
                    local flatLook = Vector3.new(math.sin(yaw), 0, math.cos(yaw))
                    if controlState.anotherCamera then
                        bg2.CFrame = CFrame.new(spPos, spPos + flatLook)
                    else
                        bg2.CFrame = CFrame.new(spPos, spPos + flatLook) * CFrame.Angles(0, math.rad(180), 0)
                    end
                end
            end
        end))

        return true
    end

    local tkControlActive = false

    tkControlSec:Keybind({Text = "Control", Flag = "TelekinesisControl", Mode = "Toggle", Callback = function()
        tkControlActive = not tkControlActive
        if tkControlActive then
            local ok = startControl()
            if not ok then
                tkControlActive = false
            else
                if State.tkControlCharAdded then State.tkControlCharAdded:Disconnect() end
                State.tkControlCharAdded = LocalPlayer.CharacterAdded:Connect(function()
                    if controlState.active then
                        stopControl()
                        tkControlActive = false
                    end
                    if State.tkControlCharAdded then State.tkControlCharAdded:Disconnect() State.tkControlCharAdded = nil end
                end)
            end
        else
            stopControl()
            if State.tkControlCharAdded then State.tkControlCharAdded:Disconnect() State.tkControlCharAdded = nil end
        end
    end})

    tkControlSec:Toggle({Text = "Another Camera", Flag = "AnotherCamera", Default = false, Callback = function(v)
        controlState.anotherCamera = v
    end})

    end)()

-- ============================================================
-- INFINITY LINE v8 | ультра-медленные скорости у нуля
-- ============================================================
-- ЧТО ИЗМЕНИЛОСЬ ПО СРАВНЕНИЮ С v7:
--  * Слайдер скорости теперь с шагом 0.01 (x0.01), максимум 10.
--  * Значения МЕНЬШЕ 1 проходят через квадратичную кривую:
--    0.5 -> 0.25, 0.1 -> 0.01, 0.01 -> 0.0001 (ещё медленнее).
--  * 0 по-прежнему = "скрипта нет" (колесо и клавиши не трогают линию).
--  * Всё остальное из v6/v7 сохранено (анти-тряска, одна точка для
--    обеих рук, BindToRenderStep после камеры, буст с восстановлением).
-- Ремуты НЕ стреляют => античит не задет.
-- ============================================================

Settings.Grab.InfinityLine            = false
Settings.Grab.InfinityLineMax         = 500  -- потолок удлинения (студы)
Settings.Grab.InfinityLineScrollSpeed = 5    -- допускает дробные и 0
Settings.Grab.InfinityLineSmooth      = 14

State.infLine = State.infLine or {
    current = 0, offset = 0,
    holdExt = false, holdRet = false,
    grabModel = nil, primary = nil, secondary = nil,
    saved = {}, smoothLook = nil,
    scrollConn = nil, bound = false,
}
local IL = State.infLine

-- Насколько можно притянуть объект БЛИЖЕ обычной длины
local IL_MIN_PULL = -10

local function ilClampReach(v)
    return math.clamp(v, IL_MIN_PULL, Settings.Grab.InfinityLineMax)
end

-- НОВОЕ (v8): квадратичное замедление значений ниже 1.
-- 0 остаётся 0 (ванилла), 0.1 становится 0.01 и т.д.
local function ilEaseSpeed(s)
    if s <= 0 then return 0 end
    if s < 1 then return s * s end
    return s
end

-- Сканирование рук: активная рука = та, чей DragAttach используется
-- констрейнтом GrabPart; обе руки получают ОДНУ мировую точку.
local function ilScan(model)
    IL.primary, IL.secondary = nil, nil
    if not model then return end
    local gp = model:FindFirstChild("GrabPart")
    local activePart = nil
    if gp then
        for _, c in ipairs(gp:GetChildren()) do
            if c:IsA("AlignPosition") and c.Attachment1 and c.Attachment1.Parent then
                activePart = c.Attachment1.Parent
            end
        end
    end
    local parts = { model:FindFirstChild("DragPart"), model:FindFirstChild("DragPart1") }
    local primaryPart = activePart or parts[1] or parts[2]
    local function grabAttach(dp)
        if not dp then return nil end
        for _, ch in ipairs(dp:GetChildren()) do
            if ch:IsA("Attachment") and ch.Name:sub(1, 10) == "DragAttach" then
                return ch
            end
        end
        return nil
    end
    for _, dp in ipairs(parts) do
        if dp then
            local att = grabAttach(dp)
            if att then
                if dp == primaryPart then
                    IL.primary = { part = dp, attach = att }
                else
                    IL.secondary = { part = dp, attach = att }
                end
            end
        end
    end
    if not IL.primary and IL.secondary then
        IL.primary, IL.secondary = IL.secondary, nil
    end
end

-- Умеренный буст констрейнтов (GrabPart + DragPart): объект быстрее
-- дотягивается до дальней точки => меньше зазор и маятник.
-- Оригиналы сохраняются и восстанавливаются.
local function ilBoost(model)
    if not model then return end
    local targets = {}
    local gp = model:FindFirstChild("GrabPart")
    if gp then table.insert(targets, gp) end
    for _, n in ipairs({"DragPart", "DragPart1"}) do
        local dp = model:FindFirstChild(n)
        if dp then table.insert(targets, dp) end
    end
    for _, obj in ipairs(targets) do
        local ap = obj:FindFirstChildOfClass("AlignPosition")
        if ap and not IL.saved[ap] then
            IL.saved[ap] = { Responsiveness = ap.Responsiveness, MaxVelocity = ap.MaxVelocity }
            ap.Responsiveness = math.min(math.max(ap.Responsiveness * 1.6, 70), 100)
            ap.MaxVelocity    = math.max(ap.MaxVelocity, 350)
        end
        local ao = obj:FindFirstChildOfClass("AlignOrientation")
        if ao and not IL.saved[ao] then
            IL.saved[ao] = { Responsiveness = ao.Responsiveness, MaxAngularVelocity = ao.MaxAngularVelocity }
            ao.Responsiveness     = math.min(math.max(ao.Responsiveness * 1.4, 60), 100)
            ao.MaxAngularVelocity = math.max(ao.MaxAngularVelocity, 120)
        end
    end
end

local function ilRestore()
    for obj, orig in pairs(IL.saved) do
        if obj and obj.Parent then
            pcall(function()
                if orig.Responsiveness     then obj.Responsiveness     = orig.Responsiveness end
                if orig.MaxVelocity        then obj.MaxVelocity        = orig.MaxVelocity end
                if orig.MaxAngularVelocity then obj.MaxAngularVelocity = orig.MaxAngularVelocity end
            end)
        end
    end
    IL.saved = {}
end

-- Основной шаг: рендер-степ СРАЗУ после камеры (минимальная задержка)
local function ilStep(dt)
    if not Settings.Grab.InfinityLine then return end
    dt = math.clamp(dt or 0.016, 0.0001, 0.1)

    local model = Workspace:FindFirstChild("GrabParts")

    -- Захват появился/исчез/сменился -> сброс и перекэш
    if model ~= IL.grabModel then
        ilRestore()
        IL.grabModel   = model
        IL.offset      = 0   -- новый захват = обычная длина
        IL.current     = 0
        IL.smoothLook  = nil
        ilScan(model)
        if model and not IL.primary then
            task.defer(function()
                if IL.grabModel == model then
                    ilScan(model)
                    ilBoost(model)
                end
            end)
        else
            ilBoost(model)
        end
    end

    if not model or not IL.primary then return end

    -- Удержание клавиш Extend/Retract (при скорости 0 не работают => ванилла)
    -- v8: скорость проходит через квадратичное замедление
    local speed = ilEaseSpeed(Settings.Grab.InfinityLineScrollSpeed)
    if speed > 0 then
        local holdRate = speed * 12 * dt
        if IL.holdExt then IL.offset = IL.offset + holdRate end
        if IL.holdRet then IL.offset = IL.offset - holdRate end
        IL.offset = ilClampReach(IL.offset)
    end

    -- Плавная длина
    local target = IL.offset
    local alpha  = 1 - math.exp(-Settings.Grab.InfinityLineSmooth * dt)
    IL.current   = IL.current + (target - IL.current) * alpha
    if math.abs(IL.current - target) < 0.01 then IL.current = target end

    -- Нет удлинения => не трогаем штатный захват
    if IL.current < 0.05 then return end
    -- Не конфликтуем с Inf Zoom
    if Settings.Grab.InfZoom then return end

    local cam  = Workspace.CurrentCamera
    local look = cam.CFrame.LookVector

    -- === АНТИ-ТРЯСКА: сглаживание направления ===
    local myRoot  = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local mySpeed = myRoot and myRoot.AssemblyLinearVelocity.Magnitude or 0
    local dirRate = math.clamp(22 / (1 + IL.current * 0.06), 6, 22)
    if mySpeed > 60 then dirRate = dirRate * 0.45 end
    if not IL.smoothLook then IL.smoothLook = look end
    local aLook = 1 - math.exp(-dirRate * dt)
    IL.smoothLook = IL.smoothLook + (look - IL.smoothLook) * aLook
    IL.smoothLook = (IL.smoothLook.Magnitude > 0.001) and IL.smoothLook.Unit or look

    -- === ОДНА мировая точка для обеих рук => вторая линия не отрывается ===
    local part = IL.primary.part
    if part.Parent and IL.primary.attach.Parent then
        local worldPoint = part.Position + IL.smoothLook * IL.current
        IL.primary.attach.Position = part.CFrame:PointToObjectSpace(worldPoint)
        if IL.secondary and IL.secondary.part.Parent and IL.secondary.attach.Parent then
            IL.secondary.attach.Position = IL.secondary.part.CFrame:PointToObjectSpace(worldPoint)
        end
    end
end

local function ilStart()
    if IL.bound then return end
    IL.bound = true
    RunService:BindToRenderStep("InfinityLineStep", Enum.RenderPriority.Camera.Value + 1, ilStep)
    -- Скролл работает ТОЛЬКО во время захвата и ТОЛЬКО при скорости > 0
    IL.scrollConn = UserInputService.InputChanged:Connect(function(input)
        if not Settings.Grab.InfinityLine then return end
        if input.UserInputType ~= Enum.UserInputType.MouseWheel then return end
        local speed = ilEaseSpeed(Settings.Grab.InfinityLineScrollSpeed)
        if speed <= 0 then return end -- 0 = "скрипта нет", колесо не трогает линию
        if not Workspace:FindFirstChild("GrabParts") then return end
        IL.offset = IL.offset + input.Position.Z * speed
    end)
end

local function ilStop()
    if IL.bound then
        pcall(function() RunService:UnbindFromRenderStep("InfinityLineStep") end)
        IL.bound = false
    end
    if IL.scrollConn then IL.scrollConn:Disconnect() IL.scrollConn = nil end
    ilRestore()
    IL.grabModel = nil
    IL.primary, IL.secondary = nil, nil
    IL.offset, IL.current = 0, 0
    IL.smoothLook = nil
    IL.holdExt, IL.holdRet = false, false
end

-- Страховка от старого бинда после повторного запуска скрипта
pcall(function() RunService:UnbindFromRenderStep("InfinityLineStep") end)
IL.bound = false

-- ============================ UI ============================
local infLineSec = GrabTab:Section({Text = "Infinity Line"})

infLineSec:Toggle({Text = "Infinity Line", Flag = "InfLineToggle", Default = false, Callback = function(v)
    Settings.Grab.InfinityLine = v
    if v then ilStart() else ilStop() end
end})

infLineSec:Slider({Text = "Max Reach (Cap)", Flag = "InfLineMax", Minimum = 50, Maximum = 1000, Default = 500, ValueName = "studs", Callback = function(v)
    Settings.Grab.InfinityLineMax = v
    IL.offset = ilClampReach(IL.offset)
end})

-- v8: шаг 0.01 (x0.01). 0 = ванилла; значения ниже 1 дополнительно
-- замедлены квадратичной кривой (0.1 на слайдере => 0.01 реальной скорости).
infLineSec:Slider({Text = "Scroll Speed (x0.01)", Flag = "InfLineScrollSpeed", Minimum = 0, Maximum = 1000, Default = 500, ValueName = "", Callback = function(v)
    Settings.Grab.InfinityLineScrollSpeed = v / 100
end})

infLineSec:Slider({Text = "Smoothness", Flag = "InfLineSmooth", Minimum = 2, Maximum = 30, Default = 14, ValueName = "lerp", Callback = function(v)
    Settings.Grab.InfinityLineSmooth = v
end})

infLineSec:Keybind({Text = "Extend (Hold)", Flag = "InfLineExtendKey", Mode = "Hold", Callback = function(held)
    IL.holdExt = held
end})

infLineSec:Keybind({Text = "Retract (Hold)", Flag = "InfLineRetractKey", Mode = "Hold", Callback = function(held)
    IL.holdRet = held
end})

-- ============================================================
-- КОНЕЦ БЛОКА INFINITY LINE v8
-- ============================================================

warn("EndorisFTAP Reborn loaded successfully!")
