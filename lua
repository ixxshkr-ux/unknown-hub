-- Lua | Delta | Unknown Studio | Key System + TrainClick 2x
-- raw: https://raw.githubusercontent.com/ixxshkr-ux/unknown-hub/refs/heads/main/un.lua

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- parent helper — Delta safe
local function getParent()
    if gethui then
        local ok, hui = pcall(gethui)
        if ok and hui then return hui end
    end
    local ok, cg = pcall(function() return game:GetService("CoreGui") end)
    if ok and cg then return cg end
    return LocalPlayer:WaitForChild("PlayerGui")
end
local PARENT = getParent()

local KEY_DURATION = 30 * 60
local VALID_KEYS = {
    "UNKNOWN2025", "CINDERFORGE", "SWORDWAVE1",
    "KURDISTAN9", "NONO2025", "DELTAPRO99",
}
local SAVED_FILE = "UnknownStudio_SavedKey.txt"

local savedKey, savedTime = nil, 0
if isfile and readfile then
    pcall(function()
        if isfile(SAVED_FILE) then
            local c = readfile(SAVED_FILE)
            local k, t = c:match("(.+)|(%d+)")
            savedKey = k
            savedTime = tonumber(t) or 0
        end
    end)
end

pcall(function()
    if PARENT:FindFirstChild("UnknownStudio_GUI") then PARENT.UnknownStudio_GUI:Destroy() end
    if PARENT:FindFirstChild("UnknownStudio_Key") then PARENT.UnknownStudio_Key:Destroy() end
end)

local C1 = Color3.fromRGB(255, 60, 120)
local C2 = Color3.fromRGB(120, 60, 255)
local C3 = Color3.fromRGB(60, 180, 255)
local C4 = Color3.fromRGB(60, 255, 180)
local BG = Color3.fromRGB(8, 8, 14)
local BG2 = Color3.fromRGB(15, 15, 25)

local function applyGradient(parent, c1, c2, rotation)
    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, c1),
        ColorSequenceKeypoint.new(1, c2),
    })
    g.Rotation = rotation or 0
    g.Parent = parent
    return g
end

-- ===== KEY GUI =====
local KeyGui = Instance.new("ScreenGui")
KeyGui.Name = "UnknownStudio_Key"
KeyGui.ResetOnSpawn = false
KeyGui.IgnoreGuiInset = true
KeyGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
KeyGui.DisplayOrder = 10000
KeyGui.Parent = PARENT

local Dim = Instance.new("Frame")
Dim.Size = UDim2.new(1, 0, 1, 0)
Dim.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Dim.BackgroundTransparency = 0.35
Dim.BorderSizePixel = 0
Dim.ZIndex = 1
Dim.Parent = KeyGui

local KeyFrame = Instance.new("Frame")
KeyFrame.AnchorPoint = Vector2.new(0.5, 0.5)
KeyFrame.Size = UDim2.new(0, 380, 0, 520)
KeyFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
KeyFrame.BackgroundColor3 = BG
KeyFrame.BorderSizePixel = 0
KeyFrame.ZIndex = 10
KeyFrame.Parent = KeyGui
Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 16)

local kfGrad = applyGradient(KeyFrame, C2, C1, 45)
kfGrad.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.88),
    NumberSequenceKeypoint.new(1, 0.95),
})

local kfStroke = Instance.new("UIStroke", KeyFrame)
kfStroke.Thickness = 2
kfStroke.Color = C1
applyGradient(kfStroke, C1, C3, 45)

local Accent = Instance.new("Frame")
Accent.Size = UDim2.new(1, 0, 0, 4)
Accent.BorderSizePixel = 0
Accent.ZIndex = 11
Accent.Parent = KeyFrame
Instance.new("UICorner", Accent).CornerRadius = UDim.new(0, 16)
applyGradient(Accent, C1, C3, 0)

local KTitle = Instance.new("TextLabel")
KTitle.Size = UDim2.new(1, -40, 0, 40)
KTitle.Position = UDim2.new(0, 20, 0, 22)
KTitle.BackgroundTransparency = 1
KTitle.Text = "UNKNOWN STUDIO"
KTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
KTitle.TextSize = 24
KTitle.Font = Enum.Font.GothamBlack
KTitle.ZIndex = 11
KTitle.Parent = KeyFrame

local KSub = Instance.new("TextLabel")
KSub.Size = UDim2.new(1, -40, 0, 18)
KSub.Position = UDim2.new(0, 20, 0, 62)
KSub.BackgroundTransparency = 1
KSub.Text = "Enter Key to Continue"
KSub.TextColor3 = Color3.fromRGB(180, 180, 200)
KSub.TextSize = 12
KSub.Font = Enum.Font.Gotham
KSub.ZIndex = 11
KSub.Parent = KeyFrame

local KeyInputFrame = Instance.new("Frame")
KeyInputFrame.Size = UDim2.new(1, -40, 0, 46)
KeyInputFrame.Position = UDim2.new(0, 20, 0, 92)
KeyInputFrame.BackgroundColor3 = BG2
KeyInputFrame.BorderSizePixel = 0
KeyInputFrame.ZIndex = 11
KeyInputFrame.Parent = KeyFrame
Instance.new("UICorner", KeyInputFrame).CornerRadius = UDim.new(0, 10)

local kifStroke = Instance.new("UIStroke", KeyInputFrame)
kifStroke.Thickness = 1.5
kifStroke.Color = C3
kifStroke.Transparency = 0.4

local KeyInput = Instance.new("TextBox")
KeyInput.Size = UDim2.new(1, -20, 1, 0)
KeyInput.Position = UDim2.new(0, 10, 0, 0)
KeyInput.BackgroundTransparency = 1
KeyInput.Text = ""
KeyInput.PlaceholderText = "Paste your key here..."
KeyInput.PlaceholderColor3 = Color3.fromRGB(120, 120, 140)
KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyInput.TextSize = 14
KeyInput.Font = Enum.Font.Gotham
KeyInput.ClearTextOnFocus = false
KeyInput.TextXAlignment = Enum.TextXAlignment.Left
KeyInput.ZIndex = 12
KeyInput.Parent = KeyInputFrame

local SubmitBtn = Instance.new("TextButton")
SubmitBtn.Size = UDim2.new(1, -40, 0, 46)
SubmitBtn.Position = UDim2.new(0, 20, 0, 150)
SubmitBtn.BackgroundColor3 = C1
SubmitBtn.Text = "UNLOCK"
SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SubmitBtn.TextSize = 15
SubmitBtn.Font = Enum.Font.GothamBold
SubmitBtn.ZIndex = 11
SubmitBtn.Parent = KeyFrame
Instance.new("UICorner", SubmitBtn).CornerRadius = UDim.new(0, 10)
applyGradient(SubmitBtn, C1, C2, 0)

local KeyStatus = Instance.new("TextLabel")
KeyStatus.Size = UDim2.new(1, -40, 0, 20)
KeyStatus.Position = UDim2.new(0, 20, 0, 202)
KeyStatus.BackgroundTransparency = 1
KeyStatus.Text = ""
KeyStatus.TextColor3 = Color3.fromRGB(255, 80, 80)
KeyStatus.TextSize = 12
KeyStatus.Font = Enum.Font.Gotham
KeyStatus.ZIndex = 11
KeyStatus.Parent = KeyFrame

local KeysLabel = Instance.new("TextLabel")
KeysLabel.Size = UDim2.new(1, -40, 0, 20)
KeysLabel.Position = UDim2.new(0, 20, 0, 232)
KeysLabel.BackgroundTransparency = 1
KeysLabel.Text = "AVAILABLE KEYS  ·  30 MIN EACH"
KeysLabel.TextColor3 = C3
KeysLabel.TextSize = 11
KeysLabel.Font = Enum.Font.GothamBold
KeysLabel.TextXAlignment = Enum.TextXAlignment.Left
KeysLabel.ZIndex = 11
KeysLabel.Parent = KeyFrame

local KeysList = Instance.new("ScrollingFrame")
KeysList.Size = UDim2.new(1, -40, 0, 220)
KeysList.Position = UDim2.new(0, 20, 0, 258)
KeysList.BackgroundColor3 = Color3.fromRGB(4, 4, 8)
KeysList.BorderSizePixel = 0
KeysList.ScrollBarThickness = 4
KeysList.ScrollBarImageColor3 = C1
KeysList.CanvasSize = UDim2.new(0, 0, 0, 0)
KeysList.AutomaticCanvasSize = Enum.AutomaticSize.Y
KeysList.ZIndex = 11
KeysList.Parent = KeyFrame
Instance.new("UICorner", KeysList).CornerRadius = UDim.new(0, 10)
local kls = Instance.new("UIStroke", KeysList)
kls.Color = C2
kls.Thickness = 1
kls.Transparency = 0.5
local klLayout = Instance.new("UIListLayout", KeysList)
klLayout.Padding = UDim.new(0, 6)
local klPad = Instance.new("UIPadding", KeysList)
klPad.PaddingTop = UDim.new(0, 8)
klPad.PaddingLeft = UDim.new(0, 8)
klPad.PaddingRight = UDim.new(0, 8)
klPad.PaddingBottom = UDim.new(0, 8)

for i, key in ipairs(VALID_KEYS) do
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 34)
    row.BackgroundColor3 = BG2
    row.BorderSizePixel = 0
    row.ZIndex = 12
    row.Parent = KeysList
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)

    local idx = Instance.new("TextLabel")
    idx.Size = UDim2.new(0, 26, 1, 0)
    idx.Position = UDim2.new(0, 6, 0, 0)
    idx.BackgroundTransparency = 1
    idx.Text = "#" .. i
    idx.TextColor3 = C3
    idx.TextSize = 12
    idx.Font = Enum.Font.Code
    idx.ZIndex = 13
    idx.Parent = row

    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(1, -90, 1, 0)
    txt.Position = UDim2.new(0, 34, 0, 0)
    txt.BackgroundTransparency = 1
    txt.Text = key
    txt.TextColor3 = Color3.fromRGB(240, 240, 255)
    txt.TextSize = 13
    txt.Font = Enum.Font.Code
    txt.TextXAlignment = Enum.TextXAlignment.Left
    txt.ZIndex = 13
    txt.Parent = row

    local copyBtn = Instance.new("TextButton")
    copyBtn.Size = UDim2.new(0, 48, 0, 24)
    copyBtn.Position = UDim2.new(1, -54, 0.5, -12)
    copyBtn.BackgroundColor3 = C1
    copyBtn.Text = "USE"
    copyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    copyBtn.TextSize = 11
    copyBtn.Font = Enum.Font.GothamBold
    copyBtn.ZIndex = 13
    copyBtn.Parent = row
    Instance.new("UICorner", copyBtn).CornerRadius = UDim.new(0, 6)
    applyGradient(copyBtn, C1, C2, 0)

    copyBtn.MouseButton1Click:Connect(function()
        KeyInput.Text = key
        KeyStatus.TextColor3 = C3
        KeyStatus.Text = "Key loaded → press UNLOCK"
    end)
end

local function isValidKey(k)
    for _, v in ipairs(VALID_KEYS) do
        if v == k then return true end
    end
    return false
end

local function saveKey(k)
    if writefile then
        pcall(function()
            writefile(SAVED_FILE, k .. "|" .. tostring(os.time()))
        end)
    end
end

local function unlock()
    local info = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    TweenService:Create(KeyFrame, info, {Size = UDim2.new(0, 0, 0, 0)}):Play()
    TweenService:Create(Dim, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
    task.wait(0.45)
    KeyGui:Destroy()
end

SubmitBtn.MouseButton1Click:Connect(function()
    local entered = KeyInput.Text
    if isValidKey(entered) then
        saveKey(entered)
        KeyStatus.TextColor3 = Color3.fromRGB(80, 255, 120)
        KeyStatus.Text = "Key accepted. Loading..."
        task.wait(0.5)
        unlock()
    else
        KeyStatus.TextColor3 = Color3.fromRGB(255, 80, 80)
        KeyStatus.Text = "Invalid key. Try again."
        local orig = KeyFrame.Position
        for i = 1, 6 do
            KeyFrame.Position = orig + UDim2.new(0, (i % 2 == 0 and 8 or -8), 0, 0)
            task.wait(0.04)
        end
        KeyFrame.Position = orig
    end
end)

if savedKey and isValidKey(savedKey) then
    local elapsed = os.time() - savedTime
    if elapsed < KEY_DURATION then
        KeyStatus.TextColor3 = Color3.fromRGB(80, 255, 120)
        KeyStatus.Text = "Saved key valid. Auto-unlocking..."
        task.spawn(function()
            task.wait(0.6)
            unlock()
        end)
    end
end

-- ===== MAIN GUI =====
task.spawn(function()
    while KeyGui.Parent do task.wait(0.2) end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "UnknownStudio_GUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    ScreenGui.DisplayOrder = 9999
    ScreenGui.Parent = PARENT

    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(0, 54, 0, 54)
    ToggleBtn.Position = UDim2.new(0, 20, 0.5, -27)
    ToggleBtn.BackgroundColor3 = BG
    ToggleBtn.Text = "⚔"
    ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleBtn.TextSize = 26
    ToggleBtn.Font = Enum.Font.GothamBlack
    ToggleBtn.ZIndex = 10
    ToggleBtn.Parent = ScreenGui
    Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 16)
    applyGradient(ToggleBtn, C2, C1, 45)
    local ts = Instance.new("UIStroke", ToggleBtn)
    ts.Thickness = 2
    ts.Color = C3

    local MainFrame = Instance.new("Frame")
    MainFrame.AnchorPoint = Vector2.new(0, 0.5)
    MainFrame.Size = UDim2.new(0, 320, 0, 500)
    MainFrame.Position = UDim2.new(0, 90, 0.5, 0)
    MainFrame.BackgroundColor3 = BG
    MainFrame.BorderSizePixel = 0
    MainFrame.Visible = false
    MainFrame.ClipsDescendants = true
    MainFrame.ZIndex = 10
    MainFrame.Parent = ScreenGui
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 16)

    local mfGrad = applyGradient(MainFrame, C2, C1, 135)
    mfGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.9),
        NumberSequenceKeypoint.new(1, 0.95),
    })

    local ms = Instance.new("UIStroke", MainFrame)
    ms.Thickness = 2
    applyGradient(ms, C1, C3, 45)

    local TopAccent = Instance.new("Frame")
    TopAccent.Size = UDim2.new(1, 0, 0, 4)
    TopAccent.BorderSizePixel = 0
    TopAccent.ZIndex = 11
    TopAccent.Parent = MainFrame
    applyGradient(TopAccent, C1, C3, 0)

    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 62)
    Header.BackgroundTransparency = 1
    Header.ZIndex = 11
    Header.Parent = MainFrame

    local StudioLabel = Instance.new("TextLabel")
    StudioLabel.Size = UDim2.new(1, -20, 0, 26)
    StudioLabel.Position = UDim2.new(0, 15, 0, 10)
    StudioLabel.BackgroundTransparency = 1
    StudioLabel.Text = "UNKNOWN STUDIO"
    StudioLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    StudioLabel.TextSize = 20
    StudioLabel.Font = Enum.Font.GothamBlack
    StudioLabel.TextXAlignment = Enum.TextXAlignment.Left
    StudioLabel.ZIndex = 12
    StudioLabel.Parent = Header

    local SubLabel = Instance.new("TextLabel")
    SubLabel.Size = UDim2.new(1, -20, 0, 16)
    SubLabel.Position = UDim2.new(0, 15, 0, 36)
    SubLabel.BackgroundTransparency = 1
    SubLabel.Text = "Swordwave Legend | TrainClick 2x"
    SubLabel.TextColor3 = C3
    SubLabel.TextSize = 11
    SubLabel.Font = Enum.Font.GothamMedium
    SubLabel.TextXAlignment = Enum.TextXAlignment.Left
    SubLabel.ZIndex = 12
    SubLabel.Parent = Header

    local TimerLabel = Instance.new("TextLabel")
    TimerLabel.Size = UDim2.new(0, 100, 0, 18)
    TimerLabel.Position = UDim2.new(1, -110, 0, 24)
    TimerLabel.BackgroundTransparency = 1
    TimerLabel.Text = "30:00"
    TimerLabel.TextColor3 = C4
    TimerLabel.TextSize = 13
    TimerLabel.Font = Enum.Font.Code
    TimerLabel.TextXAlignment = Enum.TextXAlignment.Right
    TimerLabel.ZIndex = 12
    TimerLabel.Parent = Header

    local Divider = Instance.new("Frame")
    Divider.Size = UDim2.new(1, -30, 0, 1)
    Divider.Position = UDim2.new(0, 15, 0, 62)
    Divider.BorderSizePixel = 0
    Divider.BackgroundColor3 = C2
    Divider.BackgroundTransparency = 0.5
    Divider.ZIndex = 11
    Divider.Parent = MainFrame

    local SwordBtn = Instance.new("TextButton")
    SwordBtn.Size = UDim2.new(1, -30, 0, 46)
    SwordBtn.Position = UDim2.new(0, 15, 0, 78)
    SwordBtn.BackgroundColor3 = BG2
    SwordBtn.Text = "+1 Swordwave Legend"
    SwordBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    SwordBtn.TextSize = 14
    SwordBtn.Font = Enum.Font.GothamBold
    SwordBtn.ZIndex = 11
    SwordBtn.Parent = MainFrame
    Instance.new("UICorner", SwordBtn).CornerRadius = UDim.new(0, 10)
    local ss = Instance.new("UIStroke", SwordBtn)
    ss.Thickness = 1.5
    ss.Color = C3
    ss.Transparency = 0.3

    local ActionBtn = Instance.new("TextButton")
    ActionBtn.Size = UDim2.new(1, -30, 0, 54)
    ActionBtn.Position = UDim2.new(0, 15, 0, 134)
    ActionBtn.BackgroundColor3 = C1
    ActionBtn.Text = "⚔  START TRAIN (2x)"
    ActionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ActionBtn.TextSize = 16
    ActionBtn.Font = Enum.Font.GothamBold
    ActionBtn.ZIndex = 11
    ActionBtn.Parent = MainFrame
    Instance.new("UICorner", ActionBtn).CornerRadius = UDim.new(0, 12)
    applyGradient(ActionBtn, C1, C2, 0)

    local ThemeLbl = Instance.new("TextLabel")
    ThemeLbl.Size = UDim2.new(1, -30, 0, 18)
    ThemeLbl.Position = UDim2.new(0, 15, 0, 202)
    ThemeLbl.BackgroundTransparency = 1
    ThemeLbl.Text = "THEME"
    ThemeLbl.TextColor3 = C3
    ThemeLbl.TextSize = 11
    ThemeLbl.Font = Enum.Font.GothamBold
    ThemeLbl.TextXAlignment = Enum.TextXAlignment.Left
    ThemeLbl.ZIndex = 11
    ThemeLbl.Parent = MainFrame

    local ThemeFrame = Instance.new("Frame")
    ThemeFrame.Size = UDim2.new(1, -30, 0, 44)
    ThemeFrame.Position = UDim2.new(0, 15, 0, 224)
    ThemeFrame.BackgroundColor3 = BG2
    ThemeFrame.BorderSizePixel = 0
    ThemeFrame.ZIndex = 11
    ThemeFrame.Parent = MainFrame
    Instance.new("UICorner", ThemeFrame).CornerRadius = UDim.new(0, 10)
    local tl = Instance.new("UIListLayout", ThemeFrame)
    tl.FillDirection = Enum.FillDirection.Horizontal
    tl.Padding = UDim.new(0, 8)
    tl.VerticalAlignment = Enum.VerticalAlignment.Center
    tl.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local LogBox = Instance.new("ScrollingFrame")
    LogBox.Size = UDim2.new(1, -30, 0, 190)
    LogBox.Position = UDim2.new(0, 15, 0, 282)
    LogBox.BackgroundColor3 = Color3.fromRGB(4, 4, 8)
    LogBox.BorderSizePixel = 0
    LogBox.ScrollBarThickness = 4
    LogBox.ScrollBarImageColor3 = C1
    LogBox.CanvasSize = UDim2.new(0, 0, 0, 0)
    LogBox.AutomaticCanvasSize = Enum.AutomaticSize.Y
    LogBox.ZIndex = 11
    LogBox.Parent = MainFrame
    Instance.new("UICorner", LogBox).CornerRadius = UDim.new(0, 10)
    local lbox_stroke = Instance.new("UIStroke", LogBox)
    lbox_stroke.Color = C2
    lbox_stroke.Thickness = 1
    lbox_stroke.Transparency = 0.6
    local lLayout = Instance.new("UIListLayout", LogBox)
    lLayout.Padding = UDim.new(0, 3)
    local lPad = Instance.new("UIPadding", LogBox)
    lPad.PaddingTop = UDim.new(0, 6)
    lPad.PaddingLeft = UDim.new(0, 8)
    lPad.PaddingRight = UDim.new(0, 8)

    local function addLog(t)
        local l = Instance.new("TextLabel")
        l.Size = UDim2.new(1, 0, 0, 16)
        l.BackgroundTransparency = 1
        l.Text = "› " .. t
        l.TextColor3 = Color3.fromRGB(220, 220, 240)
        l.TextSize = 11
        l.Font = Enum.Font.Code
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.ZIndex = 12
        l.Parent = LogBox
    end

    local function drag(f, h)
        local d, s, sp = false, nil, nil
        h.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                d = true; s = i.Position; sp = f.Position
                i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then d = false end end)
            end
        end)
        UserInputService.InputChanged:Connect(function(i)
            if d and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                local dl = i.Position - s
                f.Position = UDim2.new(sp.X.Scale, sp.X.Offset + dl.X, sp.Y.Scale, sp.Y.Offset + dl.Y)
            end
        end)
    end
    drag(MainFrame, Header)
    drag(ToggleBtn, ToggleBtn)

    ToggleBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = not MainFrame.Visible
    end)

    for _, pair in ipairs({
        {C1, C2}, {C3, C2}, {C4, C3},
        {Color3.fromRGB(255, 180, 60), C1},
        {Color3.fromRGB(255, 255, 255), C3},
        {Color3.fromRGB(255, 60, 60), Color3.fromRGB(120, 0, 80)},
    }) do
        local dot = Instance.new("TextButton")
        dot.Size = UDim2.new(0, 28, 0, 28)
        dot.BackgroundColor3 = pair[1]
        dot.Text = ""
        dot.ZIndex = 12
        dot.Parent = ThemeFrame
        Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
        applyGradient(dot, pair[1], pair[2], 45)
        dot.MouseButton1Click:Connect(function()
            applyGradient(ms, pair[1], pair[2], 45)
            applyGradient(ts, pair[1], pair[2], 45)
            applyGradient(ss, pair[1], pair[2], 45)
            applyGradient(ActionBtn, pair[1], pair[2], 0)
            applyGradient(TopAccent, pair[1], pair[2], 0)
        end)
    end

    local keyStart = savedTime > 0 and savedTime or os.time()
    task.spawn(function()
        while true do
            local remaining = KEY_DURATION - (os.time() - keyStart)
            if remaining <= 0 then
                TimerLabel.Text = "EXPIRED"
                TimerLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
                addLog("Key expired. Reload script.")
                MainFrame.Visible = false
                ToggleBtn.Visible = false
                break
            end
            TimerLabel.Text = string.format("%02d:%02d", math.floor(remaining/60), remaining%60)
            task.wait(1)
        end
    end)

    local remotes = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Remotes"):WaitForChild("GameplayRemoteEvents")
    local trainClick = remotes:WaitForChild("TrainClick")

    local running = false
    local thread = nil
    local CLICKS = 2

    local function start()
        if running then return end
        running = true
        ActionBtn.Text = "⛔  STOP (2x)"
        applyGradient(ActionBtn, Color3.fromRGB(255, 60, 60), Color3.fromRGB(120, 0, 60), 0)
        addLog("Loop started — 2x per tick")
        thread = task.spawn(function()
            while true do
                for i = 1, CLICKS do
                    pcall(function() trainClick:FireServer() end)
                end
                task.wait(0.1)
                if not running then break end
            end
        end)
    end

    local function stop()
        if not running then return end
        running = false
        ActionBtn.Text = "⚔  START TRAIN (2x)"
        addLog("Loop stopped.")
        if thread then task.cancel(thread); thread = nil end
    end

    ActionBtn.MouseButton1Click:Connect(function()
        if running then stop() else start() end
    end)

    SwordBtn.MouseButton1Click:Connect(function()
        addLog("Burst +10 fired")
        task.spawn(function()
            for i = 1, 10 do
                pcall(function() trainClick:FireServer() end)
                task.wait(0.1)
            end
            addLog("Burst complete.")
        end)
    end)

    addLog("Unknown Studio loaded.")
end)
