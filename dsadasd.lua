-- By https://discord.gg/76wNYBeDxR
local Players      = game:GetService("Players")
local UIS          = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RS           = game:GetService("ReplicatedStorage")
local HttpService  = game:GetService("HttpService")
local SoundService = game:GetService("SoundService")

local LP = Players.LocalPlayer
local CONFIG_FILE = "IceHubLaggerOmahad_Config.json"

-- ============ THEME ============
local ICE_BLUE    = Color3.fromRGB(0, 170, 255)
local ICE_CYAN    = Color3.fromRGB(0, 255, 255)
local ICE_DEEP    = Color3.fromRGB(0, 90, 180)
local BG_BLACK    = Color3.fromRGB(6, 8, 12)
local BG_PANEL    = Color3.fromRGB(12, 16, 24)
local BG_INPUT    = Color3.fromRGB(20, 28, 40)
local BG_HOVER    = Color3.fromRGB(30, 42, 60)
local TEXT_WHITE  = Color3.fromRGB(240, 248, 255)
local TEXT_DIM    = Color3.fromRGB(130, 150, 175)
local TEXT_GLOW   = Color3.fromRGB(100, 220, 255)
local STROKE_BLUE = Color3.fromRGB(30, 80, 140)
local CLR_LOW     = Color3.fromRGB(0, 180, 100)
local CLR_MID     = Color3.fromRGB(220, 160, 0)
local CLR_HIGH    = Color3.fromRGB(220, 50, 50)
local CLR_CUSTOM  = Color3.fromRGB(120, 80, 220)

-- ============ SFX (معطّلة — IDs غير صالحة) ============
local function playSfx(name) end

-- ============ TWEEN ============
local function tween(obj, props, t)
    TweenService:Create(obj, TweenInfo.new(t or 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

-- ============ GUI ROOT ============
local gui = Instance.new("ScreenGui")
gui.Name        = "IceHubLaggerOmahad"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.DisplayOrder   = 999
gui.Parent = LP:WaitForChild("PlayerGui")

-- ============ MAIN FRAME ============
local FULL_H = 370
local MINI_H = 48
local WIN_W  = 288

local Main = Instance.new("Frame", gui)
Main.Size            = UDim2.new(0, WIN_W, 0, 0)
Main.Position        = UDim2.new(0.5, -WIN_W/2, 0.5, -FULL_H/2)
Main.BackgroundColor3 = BG_BLACK
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 14)

local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color       = STROKE_BLUE
MainStroke.Thickness   = 1.5
MainStroke.Transparency = 0.1
MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local MainGrad = Instance.new("UIGradient", Main)
MainGrad.Rotation = 135
MainGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 14, 22)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(4,  6,  10)),
}

-- ============ SNOW PARTICLES ============
local Particles = Instance.new("Frame", Main)
Particles.Size = UDim2.new(1, 0, 1, 0)
Particles.BackgroundTransparency = 1
Particles.ZIndex = 0
Particles.ClipsDescendants = true
Instance.new("UICorner", Particles).CornerRadius = UDim.new(0, 14)

local function spawnFlake()
    local dot  = Instance.new("Frame", Particles)
    local size = math.random(1, 3)
    dot.Size = UDim2.new(0, size, 0, size)
    dot.BackgroundColor3 = (math.random(1,2)==1) and ICE_CYAN or TEXT_WHITE
    dot.BackgroundTransparency = math.random(55,90)/100
    dot.BorderSizePixel = 0
    dot.ZIndex = 0
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
    local sx = math.random() * 1.1 - 0.05
    local drift = math.random(-20,20)/100
    local dur   = math.random(5,11)
    dot.Position = UDim2.new(sx, 0, -0.05, 0)
    local fall = TweenService:Create(dot, TweenInfo.new(dur, Enum.EasingStyle.Linear),
        { Position = UDim2.new(sx + drift, 0, 1.05, 0), BackgroundTransparency = 1 })
    fall:Play()
    fall.Completed:Connect(function() dot:Destroy() end)
end

task.spawn(function()
    while Particles.Parent do
        spawnFlake()
        task.wait(math.random(8,22)/100)
    end
end)

-- ============ TOP BAR ============
local TopBar = Instance.new("Frame", Main)
TopBar.Size = UDim2.new(1, 0, 0, MINI_H)
TopBar.BackgroundColor3 = BG_PANEL
TopBar.BackgroundTransparency = 0.3
TopBar.BorderSizePixel = 0
TopBar.ZIndex = 4
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 14)

local TopMask = Instance.new("Frame", TopBar)
TopMask.Size = UDim2.new(1,0,0,14)
TopMask.Position = UDim2.new(0,0,1,-14)
TopMask.BackgroundColor3 = BG_PANEL
TopMask.BackgroundTransparency = 0.3
TopMask.BorderSizePixel = 0
TopMask.ZIndex = 4

local Stripe = Instance.new("Frame", TopBar)
Stripe.Size = UDim2.new(1,-20,0,2)
Stripe.Position = UDim2.new(0,10,1,-2)
Stripe.BorderSizePixel = 0
Stripe.BackgroundColor3 = ICE_BLUE
Stripe.ZIndex = 5
Instance.new("UICorner", Stripe).CornerRadius = UDim.new(1,0)
Instance.new("UIGradient", Stripe).Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0,   ICE_DEEP),
    ColorSequenceKeypoint.new(0.5, ICE_CYAN),
    ColorSequenceKeypoint.new(1,   ICE_DEEP),
}

local Title = Instance.new("TextLabel", TopBar)
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0,12,0,0)
Title.Size     = UDim2.new(1,-90,1,0)
Title.Text     = "NXC HUB  PACKET LAGGER"
Title.Font     = Enum.Font.GothamBlack
Title.TextSize = 11
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextYAlignment = Enum.TextYAlignment.Center
Title.TextColor3 = TEXT_WHITE
Title.ZIndex = 5

local TitleGrad = Instance.new("UIGradient", Title)
TitleGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0,   TEXT_WHITE),
    ColorSequenceKeypoint.new(0.5, TEXT_GLOW),
    ColorSequenceKeypoint.new(1,   TEXT_WHITE),
}
task.spawn(function()
    local t = 0
    while TitleGrad.Parent do
        t = t + 0.03
        TitleGrad.Offset = Vector2.new(math.sin(t)*0.3, 0)
        task.wait(0.03)
    end
end)

-- ============ TOP-RIGHT BUTTONS ============
local MinimizeBtn = Instance.new("TextButton", TopBar)
MinimizeBtn.Size            = UDim2.new(0, 22, 0, 22)
MinimizeBtn.Position        = UDim2.new(1, -30, 0.5, -11)
MinimizeBtn.BackgroundColor3 = BG_INPUT
MinimizeBtn.BorderSizePixel = 0
MinimizeBtn.Text            = "−"
MinimizeBtn.Font            = Enum.Font.GothamBlack
MinimizeBtn.TextSize        = 14
MinimizeBtn.TextColor3      = TEXT_WHITE
MinimizeBtn.AutoButtonColor = false
MinimizeBtn.ZIndex          = 6
Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0, 6)
local MinStroke = Instance.new("UIStroke", MinimizeBtn)
MinStroke.Color = STROKE_BLUE; MinStroke.Thickness = 1; MinStroke.Transparency = 0.4

local EnableBtn = Instance.new("TextButton", TopBar)
EnableBtn.Size            = UDim2.new(0, 40, 0, 22)
EnableBtn.Position        = UDim2.new(1, -76, 0.5, -11)
EnableBtn.BackgroundColor3 = Color3.fromRGB(0, 40, 20)
EnableBtn.BorderSizePixel = 0
EnableBtn.Text            = "ON"
EnableBtn.Font            = Enum.Font.GothamBlack
EnableBtn.TextSize        = 11
EnableBtn.TextColor3      = Color3.fromRGB(0, 220, 100)
EnableBtn.AutoButtonColor = false
EnableBtn.ZIndex          = 6
Instance.new("UICorner", EnableBtn).CornerRadius = UDim.new(0, 6)
local EnStroke = Instance.new("UIStroke", EnableBtn)
EnStroke.Color = Color3.fromRGB(0, 180, 80); EnStroke.Thickness = 1.2; EnStroke.Transparency = 0.2

-- ============ BODY ============
local Body = Instance.new("Frame", Main)
Body.Position = UDim2.new(0,0,0,MINI_H)
Body.Size     = UDim2.new(1,0,1,-MINI_H)
Body.BackgroundTransparency = 1
Body.ZIndex = 3

local Pad = Instance.new("UIPadding", Body)
Pad.PaddingTop    = UDim.new(0,12)
Pad.PaddingBottom = UDim.new(0,12)
Pad.PaddingLeft   = UDim.new(0,14)
Pad.PaddingRight  = UDim.new(0,14)

-- ============ HELPERS ============
local function makeLabel(parent, text, py)
    local l = Instance.new("TextLabel", parent)
    l.BackgroundTransparency = 1
    l.Position = UDim2.new(0,0,0,py)
    l.Size     = UDim2.new(1,0,0,12)
    l.Text     = text
    l.Font     = Enum.Font.GothamBold
    l.TextSize = 9
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.TextColor3 = TEXT_DIM
    l.ZIndex = 4
    return l
end

local function makeDivider(parent, py)
    local d = Instance.new("Frame", parent)
    d.Position = UDim2.new(0,0,0,py)
    d.Size     = UDim2.new(1,0,0,1)
    d.BackgroundColor3 = STROKE_BLUE
    d.BackgroundTransparency = 0.5
    d.BorderSizePixel = 0
    d.ZIndex = 4
    return d
end

-- ============ OMAHAD POWER ============
makeLabel(Body, "OMAHAD POWER", 0)

local IntRow = Instance.new("Frame", Body)
IntRow.Position = UDim2.new(0,0,0,14)
IntRow.Size     = UDim2.new(1,0,0,36)
IntRow.BackgroundTransparency = 1

local function makeArrowBtn(parent, text, xOff)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(0,36,1,0)
    b.Position = UDim2.new(0,xOff,0,0)
    b.BackgroundColor3 = BG_INPUT
    b.BorderSizePixel  = 0
    b.Text     = text
    b.Font     = Enum.Font.GothamBlack
    b.TextSize = 17
    b.TextColor3 = TEXT_WHITE
    b.AutoButtonColor = false
    b.ZIndex = 4
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 9)
    local sk = Instance.new("UIStroke", b)
    sk.Color = STROKE_BLUE; sk.Thickness = 1; sk.Transparency = 0.4
    return b
end

local Minus = makeArrowBtn(IntRow, "−", 0)
local Plus  = makeArrowBtn(IntRow, "+", 224)

local IntBox = Instance.new("TextBox", IntRow)
IntBox.Position = UDim2.new(0,40,0,0)
IntBox.Size     = UDim2.new(0,180,1,0)
IntBox.BackgroundColor3 = BG_INPUT
IntBox.BorderSizePixel  = 0
IntBox.Text     = "10000"
IntBox.PlaceholderText = "omahad power"
IntBox.Font     = Enum.Font.GothamBlack
IntBox.TextSize = 16
IntBox.TextColor3 = TEXT_GLOW
IntBox.PlaceholderColor3 = TEXT_DIM
IntBox.ClearTextOnFocus  = false
IntBox.ZIndex = 4
Instance.new("UICorner", IntBox).CornerRadius = UDim.new(0,9)
local IntStroke = Instance.new("UIStroke", IntBox)
IntStroke.Color = STROKE_BLUE; IntStroke.Thickness = 1; IntStroke.Transparency = 0.3

-- ============ DIVIDER ============
makeDivider(Body, 56)

-- ============ PRESETS ============
makeLabel(Body, "PRESET", 62)

local PRESET_Y = 76
local presetData = {
    { key = "LOW",    color = CLR_LOW,    power = 5000,  speed = 70,  steal = 41 },
    { key = "MID",    color = CLR_MID,    power = 10000, speed = 84,  steal = 51 },
    { key = "HIGH",   color = CLR_HIGH,   power = 25000, speed = 180, steal_lo = 100, steal_hi = 120 },
    { key = "CUSTOM", color = CLR_CUSTOM, power = nil },
}

local PresetFrame = Instance.new("Frame", Body)
PresetFrame.Position = UDim2.new(0,0,0,PRESET_Y)
PresetFrame.Size     = UDim2.new(1,0,0,80)
PresetFrame.BackgroundTransparency = 1

local boxW   = 62
local boxGap = 4
local selectedPreset = nil
local presetBtns = {}

for i, pd in ipairs(presetData) do
    local xPos = (i-1) * (boxW + boxGap)
    local box = Instance.new("TextButton", PresetFrame)
    box.Size     = UDim2.new(0, boxW, 0, 80)
    box.Position = UDim2.new(0, xPos, 0, 0)
    box.BackgroundColor3 = BG_INPUT
    box.BorderSizePixel  = 0
    box.Text     = ""
    box.AutoButtonColor = false
    box.ZIndex   = 4
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 9)
    local sk = Instance.new("UIStroke", box)
    sk.Color = pd.color; sk.Thickness = 1.5; sk.Transparency = 0.5

    local lKey = Instance.new("TextLabel", box)
    lKey.BackgroundTransparency = 1
    lKey.Size     = UDim2.new(1,0,0,20)
    lKey.Position = UDim2.new(0,0,0,5)
    lKey.Text     = pd.key
    lKey.Font     = Enum.Font.GothamBlack
    lKey.TextSize = 10
    lKey.TextColor3 = pd.color
    lKey.TextXAlignment = Enum.TextXAlignment.Center
    lKey.ZIndex = 5

    if pd.key ~= "CUSTOM" then
        local lPow = Instance.new("TextLabel", box)
        lPow.BackgroundTransparency = 1
        lPow.Size     = UDim2.new(1,0,0,13)
        lPow.Position = UDim2.new(0,0,0,27)
        lPow.Text     = tostring(pd.power/1000).."K"
        lPow.Font     = Enum.Font.GothamBold
        lPow.TextSize = 10
        lPow.TextColor3 = TEXT_WHITE
        lPow.TextXAlignment = Enum.TextXAlignment.Center
        lPow.ZIndex = 5

        local lSpd = Instance.new("TextLabel", box)
        lSpd.BackgroundTransparency = 1
        lSpd.Size     = UDim2.new(1,-2,0,12)
        lSpd.Position = UDim2.new(0,1,0,42)
        lSpd.Text     = "spd "..tostring(pd.speed)
        lSpd.Font     = Enum.Font.Gotham
        lSpd.TextSize = 8
        lSpd.TextColor3 = TEXT_DIM
        lSpd.TextXAlignment = Enum.TextXAlignment.Center
        lSpd.ZIndex = 5

        local stealTxt = pd.steal_lo and ("stl "..pd.steal_lo.."-"..pd.steal_hi) or ("stl "..tostring(pd.steal))
        local lStl = Instance.new("TextLabel", box)
        lStl.BackgroundTransparency = 1
        lStl.Size     = UDim2.new(1,-2,0,12)
        lStl.Position = UDim2.new(0,1,0,56)
        lStl.Text     = stealTxt
        lStl.Font     = Enum.Font.Gotham
        lStl.TextSize = 8
        lStl.TextColor3 = TEXT_DIM
        lStl.TextXAlignment = Enum.TextXAlignment.Center
        lStl.ZIndex = 5
    else
        local lHint = Instance.new("TextLabel", box)
        lHint.BackgroundTransparency = 1
        lHint.Size     = UDim2.new(1,0,0,38)
        lHint.Position = UDim2.new(0,0,0,26)
        lHint.Text     = "type\npower\nabove"
        lHint.Font     = Enum.Font.Gotham
        lHint.TextSize = 8
        lHint.TextColor3 = TEXT_DIM
        lHint.TextXAlignment = Enum.TextXAlignment.Center
        lHint.LineHeight = 1.2
        lHint.ZIndex = 5
    end

    presetBtns[i] = { btn = box, stroke = sk, data = pd }
end

-- ============ DIVIDER 2 ============
makeDivider(Body, 162)

-- ============ KEYBIND ============
makeLabel(Body, "TOGGLE KEYBIND", 170)

local KeyBtn = Instance.new("TextButton", Body)
KeyBtn.Position = UDim2.new(0,0,0,184)
KeyBtn.Size     = UDim2.new(1,0,0,32)
KeyBtn.BackgroundColor3 = BG_INPUT
KeyBtn.BorderSizePixel  = 0
KeyBtn.Text     = "G"
KeyBtn.Font     = Enum.Font.GothamBlack
KeyBtn.TextSize = 13
KeyBtn.TextColor3 = TEXT_GLOW
KeyBtn.AutoButtonColor = false
KeyBtn.ZIndex = 4
Instance.new("UICorner", KeyBtn).CornerRadius = UDim.new(0, 9)
local KeyStroke = Instance.new("UIStroke", KeyBtn)
KeyStroke.Color = STROKE_BLUE; KeyStroke.Thickness = 1; KeyStroke.Transparency = 0.3

local listeningForKey = false

-- ============ DIVIDER 3 ============
makeDivider(Body, 224)

-- ============ START BUTTON ============
local StartBtn = Instance.new("TextButton", Body)
StartBtn.Position = UDim2.new(0,0,0,232)
StartBtn.Size     = UDim2.new(1,0,0,46)
StartBtn.BackgroundColor3 = ICE_DEEP
StartBtn.BorderSizePixel  = 0
StartBtn.Text     = "START"
StartBtn.Font     = Enum.Font.GothamBlack
StartBtn.TextSize = 19
StartBtn.TextColor3 = TEXT_WHITE
StartBtn.AutoButtonColor = false
StartBtn.ZIndex = 4
Instance.new("UICorner", StartBtn).CornerRadius = UDim.new(0, 12)
local StartStroke = Instance.new("UIStroke", StartBtn)
StartStroke.Color = ICE_CYAN; StartStroke.Thickness = 1.5; StartStroke.Transparency = 0.2
local StartGrad = Instance.new("UIGradient", StartBtn)
StartGrad.Rotation = 90
StartGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0,120,220)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 60,140)),
}

-- ============ RESET POSITION BAR ============
local ResetBar = Instance.new("Frame", Main)
ResetBar.Size     = UDim2.new(1,0,0,24)
ResetBar.Position = UDim2.new(0,0,1,-24)
ResetBar.BackgroundColor3 = BG_PANEL
ResetBar.BackgroundTransparency = 0.5
ResetBar.BorderSizePixel = 0
ResetBar.ZIndex = 6
Instance.new("UICorner", ResetBar).CornerRadius = UDim.new(0, 10)

local ResetBtn = Instance.new("TextButton", ResetBar)
ResetBtn.Size     = UDim2.new(0, 120, 0, 16)
ResetBtn.Position = UDim2.new(0.5, -60, 0.5, -8)
ResetBtn.BackgroundColor3 = BG_INPUT
ResetBtn.BorderSizePixel  = 0
ResetBtn.Text     = "⟳  Reset Position"
ResetBtn.Font     = Enum.Font.GothamBold
ResetBtn.TextSize = 9
ResetBtn.TextColor3 = TEXT_DIM
ResetBtn.AutoButtonColor = false
ResetBtn.ZIndex = 7
Instance.new("UICorner", ResetBtn).CornerRadius = UDim.new(0, 5)
local ResetStroke = Instance.new("UIStroke", ResetBtn)
ResetStroke.Color = STROKE_BLUE; ResetStroke.Thickness = 1; ResetStroke.Transparency = 0.5

-- ============ STATE ============
local lagging       = false
local lagThread
local enabled       = true
local intensity     = 10000
local toggleKey     = Enum.KeyCode.G
local toggleKeyName = "G"

-- ============ KEY HELPERS ============
local function keyToName(k)
    if not k then return "G" end
    return k.Name
end
local function nameToKey(name)
    if not name then return Enum.KeyCode.G end
    local ok, k = pcall(function() return Enum.KeyCode[name] end)
    if ok and k then return k end
    return Enum.KeyCode.G
end
local function applyKeybind(name)
    toggleKeyName = name or "G"
    toggleKey = nameToKey(toggleKeyName)
    KeyBtn.Text = toggleKeyName
end

-- ============ CLAMP ============
local function clampIntensity(v)
    v = tonumber(v)
    if not v then return intensity end
    return math.clamp(math.floor(v), 1, 100000)
end
local function updateIntensity()
    intensity = clampIntensity(IntBox.Text)
    IntBox.Text = tostring(intensity)
end
local function setIntensity(v, silent)
    intensity = clampIntensity(v)
    IntBox.Text = tostring(intensity)
    if not silent then playSfx("Click") end
end

-- ============ SAVE / LOAD ============
local function saveConfig()
    updateIntensity()
    local cfg = {
        Intensity = intensity,
        Keybind   = toggleKeyName,
        Enabled   = enabled,
        PX_S = Main.Position.X.Scale, PX_O = Main.Position.X.Offset,
        PY_S = Main.Position.Y.Scale, PY_O = Main.Position.Y.Offset,
    }
    if writefile then
        pcall(function()
            writefile(CONFIG_FILE, HttpService:JSONEncode(cfg))
        end)
    end
end

local function loadConfig()
    if not readfile or not isfile then return end
    if not isfile(CONFIG_FILE) then return end
    local ok, cfg = pcall(function()
        return HttpService:JSONDecode(readfile(CONFIG_FILE))
    end)
    if ok and type(cfg) == "table" then
        if tonumber(cfg.Intensity) then
            intensity = clampIntensity(cfg.Intensity)
            IntBox.Text = tostring(intensity)
        end
        if type(cfg.Keybind) == "string" and cfg.Keybind ~= "" then
            applyKeybind(cfg.Keybind)
        end
        if tonumber(cfg.PX_S) and tonumber(cfg.PX_O) then
            Main.Position = UDim2.new(cfg.PX_S, cfg.PX_O, cfg.PY_S, cfg.PY_O)
        end
    end
end

-- ============ EVENT (بدون WaitForChild الانهائي) ============
local Event
do
    local packages = RS:FindFirstChild("Packages")
    if packages then
        local net = packages:FindFirstChild("Net")
        if net then
            Event = net:FindFirstChildOfClass("RemoteEvent")
            if not Event then
                local kids = net:GetChildren()
                if #kids >= 230 then
                    Event = kids[230]
                end
            end
        end
    end
    -- إذا ما لقيناه، ابحث في كل ReplicatedStorage
    if not Event then
        for _, child in ipairs(RS:GetDescendants()) do
            if child:IsA("RemoteEvent") then
                Event = child
                break
            end
        end
    end
end

-- ============ PAINT ============
local function paintRunning()
    tween(StartBtn, {BackgroundColor3 = Color3.fromRGB(0,200,120)}, 0.15)
    StartBtn.Text = "STOP"
    tween(StartStroke, {Transparency = 0}, 0.15)
end
local function paintIdle()
    tween(StartBtn, {BackgroundColor3 = ICE_DEEP}, 0.15)
    StartBtn.Text = "START"
    tween(StartStroke, {Transparency = 0.2}, 0.15)
end
local function paintEnabled()
    EnableBtn.Text       = "ON"
    EnableBtn.TextColor3 = Color3.fromRGB(0, 220, 100)
    EnStroke.Color       = Color3.fromRGB(0, 180, 80)
    tween(EnableBtn, {BackgroundColor3 = Color3.fromRGB(0, 40, 20)}, 0.15)
end
local function paintDisabled()
    EnableBtn.Text       = "OFF"
    EnableBtn.TextColor3 = Color3.fromRGB(220, 60, 60)
    EnStroke.Color       = Color3.fromRGB(180, 40, 40)
    tween(EnableBtn, {BackgroundColor3 = Color3.fromRGB(40, 10, 10)}, 0.15)
end

-- ============ LAGGER CORE ============
local function startLagging()
    if lagging then return end
    if not Event then playSfx("Error"); warn("[IceHub] Event not found"); return end
    updateIntensity()
    lagging = true
    paintRunning()
    playSfx("Start")
    local payload = table.create(intensity, function() end)
    lagThread = task.spawn(function()
        while lagging do
            for _ = 1, 3 do
                pcall(function() Event:FireServer(payload) end)
            end
            task.wait(0.01)
        end
    end)
end

local function stopLagging()
    if not lagging then return end
    lagging = false
    if lagThread then
        pcall(task.cancel, lagThread)
        lagThread = nil
    end
    paintIdle()
    playSfx("Stop")
end

-- ============ PRESET SELECTION ============
local function selectPreset(idx)
    for i, pb in ipairs(presetBtns) do
        if i == idx then
            tween(pb.btn, {BackgroundColor3 = Color3.fromRGB(18, 24, 36)}, 0.12)
            pb.stroke.Transparency = 0
            pb.stroke.Thickness = 2
        else
            tween(pb.btn, {BackgroundColor3 = BG_INPUT}, 0.12)
            pb.stroke.Transparency = 0.5
            pb.stroke.Thickness = 1.5
        end
    end
    local pd = presetBtns[idx].data
    if pd.power then setIntensity(pd.power, true) end
    selectedPreset = idx
    playSfx("Click")
end

for i, pb in ipairs(presetBtns) do
    pb.btn.MouseButton1Click:Connect(function()
        selectPreset(i)
        saveConfig()
    end)
    pb.btn.MouseEnter:Connect(function()
        if selectedPreset ~= i then
            tween(pb.btn, {BackgroundColor3 = BG_HOVER}, 0.1)
        end
        playSfx("Hover")
    end)
    pb.btn.MouseLeave:Connect(function()
        if selectedPreset ~= i then
            tween(pb.btn, {BackgroundColor3 = BG_INPUT}, 0.1)
        end
    end)
end

-- ============ HOVER ============
local function attachHover(b)
    b.MouseEnter:Connect(function()
        tween(b, {BackgroundColor3 = BG_HOVER}, 0.12)
        playSfx("Hover")
    end)
    b.MouseLeave:Connect(function()
        tween(b, {BackgroundColor3 = BG_INPUT}, 0.12)
    end)
end

for _, b in ipairs({Minus, Plus, KeyBtn, ResetBtn}) do attachHover(b) end

MinimizeBtn.MouseEnter:Connect(function()
    tween(MinimizeBtn, {BackgroundColor3 = BG_HOVER}, 0.12)
    playSfx("Hover")
end)
MinimizeBtn.MouseLeave:Connect(function()
    tween(MinimizeBtn, {BackgroundColor3 = BG_INPUT}, 0.12)
end)

StartBtn.MouseEnter:Connect(function()
    tween(StartBtn, {Size = UDim2.new(1,0,0,50)}, 0.12)
    playSfx("Hover")
end)
StartBtn.MouseLeave:Connect(function()
    tween(StartBtn, {Size = UDim2.new(1,0,0,46)}, 0.12)
end)

-- ============ CONNECTIONS ============
IntBox.FocusLost:Connect(function()
    updateIntensity()
    playSfx("Click")
    selectedPreset = nil
    for _, pb in ipairs(presetBtns) do
        tween(pb.btn, {BackgroundColor3 = BG_INPUT}, 0.12)
        pb.stroke.Transparency = 0.5
        pb.stroke.Thickness = 1.5
    end
    saveConfig()
end)

Minus.MouseButton1Click:Connect(function()
    updateIntensity(); setIntensity(intensity - 1000); saveConfig()
end)
Plus.MouseButton1Click:Connect(function()
    updateIntensity(); setIntensity(intensity + 1000); saveConfig()
end)

StartBtn.MouseButton1Click:Connect(function()
    playSfx("Click")
    if lagging then
        stopLagging()
        enabled = false
        paintDisabled()
    else
        enabled = true
        paintEnabled()
        startLagging()
    end
    saveConfig()
end)

EnableBtn.MouseButton1Click:Connect(function()
    playSfx("Toggle")
    if lagging then
        enabled = false
        paintDisabled()
        stopLagging()
    else
        enabled = true
        paintEnabled()
        startLagging()
    end
    saveConfig()
end)

-- ============ KEYBIND ============
KeyBtn.MouseButton1Click:Connect(function()
    if listeningForKey then return end
    listeningForKey = true
    KeyBtn.Text = "press..."
    tween(KeyBtn, {BackgroundColor3 = ICE_DEEP}, 0.15)
    playSfx("Keybind")
end)

UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if listeningForKey then
        if input.UserInputType == Enum.UserInputType.Keyboard then
            listeningForKey = false
            applyKeybind(keyToName(input.KeyCode))
            tween(KeyBtn, {BackgroundColor3 = BG_INPUT}, 0.15)
            playSfx("Keybind")
            saveConfig()
        end
        return
    end
    if input.KeyCode == toggleKey then
        playSfx("Toggle")
        if lagging then
            stopLagging()
            enabled = false
            paintDisabled()
        else
            enabled = true
            paintEnabled()
            startLagging()
        end
    end
end)

-- ============ MINIMIZE ============
local collapsed = false
MinimizeBtn.MouseButton1Click:Connect(function()
    collapsed = not collapsed
    playSfx("Click")
    if collapsed then
        MinimizeBtn.Text = "+"
        Body.Visible     = false
        ResetBar.Visible = false
        tween(Main, {Size = UDim2.new(0, WIN_W, 0, MINI_H)}, 0.25)
    else
        MinimizeBtn.Text = "−"
        tween(Main, {Size = UDim2.new(0, WIN_W, 0, FULL_H)}, 0.3)
        task.delay(0.28, function()
            Body.Visible     = true
            ResetBar.Visible = true
        end)
    end
end)

-- ============ RESET POSITION ============
ResetBtn.MouseButton1Click:Connect(function()
    playSfx("Click")
    tween(Main, {Position = UDim2.new(0.5, -WIN_W/2, 0.5, -FULL_H/2)}, 0.35)
    task.delay(0.4, saveConfig)
end)

-- ============ DRAG ============
local dragging, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging  = true
        dragStart = input.Position
        startPos  = Main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                saveConfig()
            end
        end)
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - dragStart
        Main.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + d.X,
            startPos.Y.Scale, startPos.Y.Offset + d.Y
        )
    end
end)

-- ============ INTRO ANIMATION ============
Main.Size = UDim2.new(0, WIN_W, 0, 0)
Main.BackgroundTransparency = 1
task.defer(loadConfig)
tween(Main, {Size = UDim2.new(0, WIN_W, 0, FULL_H), BackgroundTransparency = 0}, 0.4)
paintIdle()
paintEnabled()
