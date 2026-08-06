-- ============================================================
-- INFINITY LINE v7 | скорость скролла < 1 и 0 (ванилла)
-- ============================================================
-- ЧТО ИЗМЕНИЛОСЬ ПО СРАВНЕНИЮ С v6:
--  * Скорость скролла/клавиш теперь можно ставить МЕНЬШЕ 1 и В 0.
--    Слайдер в шагах x0.1: 50 = 5.0, 5 = 0.5, 0 = 0.
--  * Скорость 0 = "как будто скрипта нет": колесо и клавиши вообще
--    не трогают линию, захват ведёт себя как ванильный.
--  * Всё из v6 сохранено: сглаживание направления (анти-тряска),
--    одна мировая точка для обеих рук, BindToRenderStep после
--    камеры, мягкий буст констрейнтов с восстановлением.
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
	local speed = Settings.Grab.InfinityLineScrollSpeed
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
		local speed = Settings.Grab.InfinityLineScrollSpeed
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

-- НОВОЕ: скорость в шагах x0.1 => доступны 0 и значения меньше 1.
-- 0 = базовый скролл, как будто скрипта нет.
infLineSec:Slider({Text = "Scroll Speed (x0.1)", Flag = "InfLineScrollSpeed", Minimum = 0, Maximum = 500, Default = 50, ValueName = "", Callback = function(v)
	Settings.Grab.InfinityLineScrollSpeed = v / 10
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
-- КОНЕЦ БЛОКА INFINITY LINE v7
-- ============================================================
