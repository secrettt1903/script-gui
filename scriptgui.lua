--[[
    ┌─────────────────────────────────────────────┐
    │      LONEX SCRIPT GUI   v1.0.0              │
    │      Dark Purple + Light Blue Theme         │
    │      Fully aligned layout                   │
    └─────────────────────────────────────────────┘
--]]

local Players = game:GetService("Players")
local UIS     = game:GetService("UserInputService")
local RS      = game:GetService("RunService")
local Tween   = game:GetService("TweenService")
local Stats   = game:GetService("Stats")
local MPS     = game:GetService("MarketplaceService")

local LP = Players.LocalPlayer
local PG = LP:WaitForChild("PlayerGui")

-- ==================== CONFIG ====================
local CONFIG = {
    Creator     = "Lonex Script",
    Version     = "v1.0.0",
    DiscordName = "Discord",
    DiscordLink = "https://discord.gg/xBUjnC4Ksc",
    YouTubeName = "Lonex Script",
}

do
    local ok, info = pcall(function() return MPS:GetProductInfo(game.PlaceId) end)
    CONFIG.GameName = (ok and info and info.Name) or "Unknown Game"
end

-- ==================== COLORS ====================
local C = {
    Panel   = Color3.fromRGB(24, 14, 44),
    Panel2  = Color3.fromRGB(34, 20, 60),
    Panel3  = Color3.fromRGB(46, 28, 80),
    Sidebar = Color3.fromRGB(20, 12, 38),
    Accent  = Color3.fromRGB(96, 200, 255),
    Accent2 = Color3.fromRGB(160, 110, 255),
    Purple  = Color3.fromRGB(130, 70, 220),
    Text    = Color3.fromRGB(235, 240, 255),
    TextDim = Color3.fromRGB(150, 165, 200),
    Green   = Color3.fromRGB(80, 220, 140),
    Yellow  = Color3.fromRGB(255, 200, 80),
    Red     = Color3.fromRGB(255, 90, 90),
    Discord = Color3.fromRGB(88, 101, 242),
    YouTube = Color3.fromRGB(255, 40, 40),
}

-- ==================== LAYOUT ====================
local L = {
    PanelW    = 640,
    PanelH    = 440,
    HeaderH   = 46,
    FooterH   = 46,
    SidebarW  = 150,
    PadX      = 14,   -- yatay iç boşluk
    Radius    = 14,
}

-- ==================== HELPERS ====================
local function new(class, props)
    local i = Instance.new(class)
    for k, v in pairs(props or {}) do i[k] = v end
    return i
end

local function corner(p, r)
    return new("UICorner", { CornerRadius = UDim.new(0, r or 8), Parent = p })
end

local function stroke(p, th, tr, g1, g2)
    local s = new("UIStroke", {
        Thickness = th or 1.5,
        Transparency = tr or 0,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        LineJoinMode = Enum.LineJoinMode.Round,
        Parent = p,
    })
    if g1 and g2 then
        new("UIGradient", { Color = ColorSequence.new(g1, g2), Parent = s })
    end
    return s
end

local function draggable(frame, handle)
    handle = handle or frame
    local on, dS, sP
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch then
            on, dS, sP = true, i.Position, frame.Position
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if on and (i.UserInputType == Enum.UserInputType.MouseMovement
        or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - dS
            frame.Position = UDim2.new(
                sP.X.Scale, sP.X.Offset + d.X,
                sP.Y.Scale, sP.Y.Offset + d.Y
            )
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch then on = false end
    end)
end

-- ==================== CLEANUP ====================
if PG:FindFirstChild("LonexScript") then
    PG.LonexScript:Destroy()
end

-- ==================== SCREENGUI ====================
local SG = new("ScreenGui", {
    Name = "LonexScript",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    Parent = PG,
})

-- ==================== LN TOGGLE BUTTON ====================
local ToggleBtn = new("TextButton", {
    Parent = SG,
    Size = UDim2.new(0, 54, 0, 54),
    Position = UDim2.new(0, 20, 0, 120),
    BackgroundColor3 = C.Panel,
    Text = "LN",
    TextColor3 = C.Accent,
    Font = Enum.Font.GothamBlack,
    TextSize = 22,
    AutoButtonColor = false,
    BorderSizePixel = 0,
    ZIndex = 10,
})
corner(ToggleBtn, 16)
stroke(ToggleBtn, 2.2, 0, C.Purple, C.Accent)
draggable(ToggleBtn)

-- ==================== MAIN PANEL ====================
local Main = new("Frame", {
    Parent = SG,
    Size = UDim2.new(0, L.PanelW, 0, L.PanelH),
    Position = UDim2.new(0.5, -L.PanelW/2, 0.5, -L.PanelH/2),
    BackgroundColor3 = C.Panel,
    BorderSizePixel = 0,
})
corner(Main, L.Radius)
stroke(Main, 2.2, 0, C.Purple, C.Accent)

-- ==================== HEADER (ÜST BAR) ====================
--   [ Lonex Script ]     [ Oyun İsmi ]     [ v1.0.0 ]
local Header = new("Frame", {
    Parent = Main,
    Size = UDim2.new(1, 0, 0, L.HeaderH),
    BackgroundColor3 = C.Panel2,
    BorderSizePixel = 0,
})
corner(Header, L.Radius)
new("Frame", {  -- alt köşeleri düzleştir
    Parent = Header,
    Size = UDim2.new(1, 0, 0, L.Radius),
    Position = UDim2.new(0, 0, 1, -L.Radius),
    BackgroundColor3 = C.Panel2,
    BorderSizePixel = 0,
})

-- Sol: Yaratıcı
local HeaderLeft = new("TextLabel", {
    Parent = Header,
    BackgroundTransparency = 1,
    Position = UDim2.new(0, L.PadX, 0, 0),
    Size = UDim2.new(0.3, -L.PadX, 1, 0),
    Text = CONFIG.Creator,
    TextColor3 = C.Accent,
    Font = Enum.Font.GothamBold,
    TextSize = 15,
    TextXAlignment = Enum.TextXAlignment.Left,
})

-- Orta: Oyun İsmi
local HeaderCenter = new("TextLabel", {
    Parent = Header,
    BackgroundTransparency = 1,
    Position = UDim2.new(0.3, 0, 0, 0),
    Size = UDim2.new(0.4, 0, 1, 0),
    Text = CONFIG.GameName,
    TextColor3 = C.Text,
    Font = Enum.Font.GothamMedium,
    TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Center,
    TextTruncate = Enum.TextTruncate.AtEnd,
})

-- Sağ: Versiyon
local HeaderRight = new("TextLabel", {
    Parent = Header,
    BackgroundTransparency = 1,
    Position = UDim2.new(0.7, 0, 0, 0),
    Size = UDim2.new(0.3, -L.PadX, 1, 0),
    Text = CONFIG.Version,
    TextColor3 = C.Accent2,
    Font = Enum.Font.GothamBold,
    TextSize = 13,
    TextXAlignment = Enum.TextXAlignment.Right,
})

draggable(Main, Header)

-- ==================== SIDEBAR (KATEGORİLER) ====================
local Sidebar = new("Frame", {
    Parent = Main,
    Position = UDim2.new(0, 0, 0, L.HeaderH),
    Size = UDim2.new(0, L.SidebarW, 1, -L.HeaderH - L.FooterH),
    BackgroundColor3 = C.Sidebar,
    BorderSizePixel = 0,
})
new("UIListLayout", {
    Parent = Sidebar,
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, 6),
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
})
new("UIPadding", {
    Parent = Sidebar,
    PaddingTop = UDim.new(0, 12),
})

-- ==================== CONTENT ====================
local Content = new("ScrollingFrame", {
    Parent = Main,
    Position = UDim2.new(0, L.SidebarW, 0, L.HeaderH),
    Size = UDim2.new(1, -L.SidebarW, 1, -L.HeaderH - L.FooterH),
    BackgroundColor3 = C.Panel,
    BorderSizePixel = 0,
    ScrollBarThickness = 4,
    ScrollBarImageColor3 = C.Accent,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
})
new("UIPadding", {
    Parent = Content,
    PaddingTop = UDim.new(0, 10),
    PaddingBottom = UDim.new(0, 10),
    PaddingLeft = UDim.new(0, 10),
    PaddingRight = UDim.new(0, 10),
})

-- ==================== FOOTER (ALT BAR) ====================
--  [ Discord 🔗 Copy ]   [ ▶ YouTube Lonex Script ]   [ FPS / Ping ]
local Footer = new("Frame", {
    Parent = Main,
    Position = UDim2.new(0, 0, 1, -L.FooterH),
    Size = UDim2.new(1, 0, 0, L.FooterH),
    BackgroundColor3 = C.Panel2,
    BorderSizePixel = 0,
})
corner(Footer, L.Radius)
new("Frame", {  -- üst köşeleri düzleştir
    Parent = Footer,
    Size = UDim2.new(1, 0, 0, L.Radius),
    Position = UDim2.new(0, 0, 0, 0),
    BackgroundColor3 = C.Panel2,
    BorderSizePixel = 0,
})

-- ---------- SOL: Discord ----------
local DBox = new("Frame", {
    Parent = Footer,
    BackgroundTransparency = 1,
    Position = UDim2.new(0, L.PadX, 0.5, -12),
    Size = UDim2.new(0.35, -L.PadX, 0, 24),
})

-- Discord ikonu (D harfli kutu)
local DIcon = new("Frame", {
    Parent = DBox,
    Size = UDim2.new(0, 22, 0, 22),
    Position = UDim2.new(0, 0, 0.5, -11),
    BackgroundColor3 = C.Discord,
    BorderSizePixel = 0,
})
corner(DIcon, 6)
new("TextLabel", {
    Parent = DIcon,
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text = "D",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBlack,
    TextSize = 13,
})

-- Copy butonu
local CopyBtn = new("TextButton", {
    Parent = DBox,
    Size = UDim2.new(0, 56, 0, 22),
    Position = UDim2.new(1, -56, 0.5, -11),
    BackgroundColor3 = C.Panel3,
    Text = "Copy",
    TextColor3 = C.Accent,
    Font = Enum.Font.GothamBold,
    TextSize = 11,
    AutoButtonColor = false,
    BorderSizePixel = 0,
})
corner(CopyBtn, 6)
stroke(CopyBtn, 1, 0.3, C.Purple, C.Accent)

-- Yazı (ikon ile copy arasında tam ortalanır)
local DText = new("TextButton", {
    Parent = DBox,
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 30, 0, 0),
    Size = UDim2.new(1, -30 - 62, 1, 0),
    Text = CONFIG.DiscordName,
    TextColor3 = C.Text,
    Font = Enum.Font.GothamMedium,
    TextSize = 13,
    TextXAlignment = Enum.TextXAlignment.Left,
    AutoButtonColor = false,
    TextTruncate = Enum.TextTruncate.AtEnd,
})

local function doCopy()
    local okCopy = pcall(function()
        if setclipboard then setclipboard(CONFIG.DiscordLink) end
    end)
    CopyBtn.Text = okCopy and "Copied!" or "Fail"
    CopyBtn.TextColor3 = okCopy and C.Green or C.Red
    task.wait(1.2)
    CopyBtn.Text = "Copy"
    CopyBtn.TextColor3 = C.Accent
end
CopyBtn.MouseButton1Click:Connect(doCopy)
DText.MouseButton1Click:Connect(doCopy)

-- ---------- ORTA: YouTube ----------
local YBox = new("Frame", {
    Parent = Footer,
    BackgroundTransparency = 1,
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    Size = UDim2.new(0.3, 0, 0, 24),
})

local YIcon = new("Frame", {
    Parent = YBox,
    Size = UDim2.new(0, 26, 0, 20),
    Position = UDim2.new(0, 0, 0.5, -10),
    BackgroundColor3 = C.YouTube,
    BorderSizePixel = 0,
})
corner(YIcon, 5)
new("TextLabel", {
    Parent = YIcon,
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text = "▶",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBold,
    TextSize = 11,
})

new("TextLabel", {
    Parent = YBox,
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 32, 0, 0),
    Size = UDim2.new(1, -32, 1, 0),
    Text = "YouTube  " .. CONFIG.YouTubeName,
    TextColor3 = C.Text,
    Font = Enum.Font.GothamMedium,
    TextSize = 13,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextTruncate = Enum.TextTruncate.AtEnd,
})

-- ---------- SAĞ: FPS / Ping ----------
local SBox = new("Frame", {
    Parent = Footer,
    BackgroundTransparency = 1,
    AnchorPoint = Vector2.new(1, 0.5),
    Position = UDim2.new(1, -L.PadX, 0.5, 0),
    Size = UDim2.new(0.35, -L.PadX, 0, 24),
})

local FPSLbl = new("TextLabel", {
    Parent = SBox,
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 0, 0, 0),
    Size = UDim2.new(0.5, -4, 1, 0),
    Text = "FPS: 60",
    TextColor3 = C.Green,
    Font = Enum.Font.GothamBold,
    TextSize = 12,
    TextXAlignment = Enum.TextXAlignment.Left,
})

local PingLbl = new("TextLabel", {
    Parent = SBox,
    BackgroundTransparency = 1,
    Position = UDim2.new(0.5, 4, 0, 0),
    Size = UDim2.new(0.5, -4, 1, 0),
    Text = "Ping: 0",
    TextColor3 = C.Accent,
    Font = Enum.Font.GothamBold,
    TextSize = 12,
    TextXAlignment = Enum.TextXAlignment.Right,
})

-- FPS döngüsü
do
    local frames, last, fps = 0, tick(), 60
    RS.RenderStepped:Connect(function()
        frames = frames + 1
        local now = tick()
        if now - last >= 0.5 then
            fps = math.floor(frames / (now - last) + 0.5)
            frames, last = 0, now
            FPSLbl.Text = "FPS: " .. fps
            FPSLbl.TextColor3 = fps >= 50 and C.Green
                or (fps >= 30 and C.Yellow or C.Red)
        end
    end)
end

-- Ping döngüsü
task.spawn(function()
    while task.wait(1) do
        local okP, ping = pcall(function()
            return math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        end)
        if okP and ping then
            PingLbl.Text = "Ping: " .. ping
            PingLbl.TextColor3 = ping < 100 and C.Green
                or (ping < 200 and C.Yellow or C.Red)
        end
    end
end)

-- ==================== KATEGORİ SİSTEMİ ====================
local pages, current = {}, nil

local function setCategory(name)
    if current == name then return end
    current = name
    for n, p in pairs(pages) do
        p.Visible = (n == name)
    end
end

local function createCategory(name)
    local page = new("Frame", {
        Name = name,
        Parent = Content,
        Size = UDim2.new(1, -8, 0, 0),
        BackgroundTransparency = 1,
        AutomaticSize = Enum.AutomaticSize.Y,
        Visible = false,
    })
    new("UIListLayout", {
        Parent = page,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8),
    })
    pages[name] = page

    local btn = new("TextButton", {
        Parent = Sidebar,
        Size = UDim2.new(1, -16, 0, 34),
        BackgroundColor3 = C.Panel2,
        Text = name,
        TextColor3 = C.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        AutoButtonColor = false,
        BorderSizePixel = 0,
        LayoutOrder = #Sidebar:GetChildren() + 1,
    })
    corner(btn, 8)
    stroke(btn, 1.2, 0.4, C.Purple, C.Accent)

    btn.MouseButton1Click:Connect(function()
        for _, b in ipairs(Sidebar:GetChildren()) do
            if b:IsA("TextButton") then
                b.BackgroundColor3 = C.Panel2
                b.TextColor3 = C.Text
            end
        end
        btn.BackgroundColor3 = C.Panel3
        btn.TextColor3 = C.Accent
        setCategory(name)
    end)
    return page
end

-- ==================== ACCORDION (AÇILIR BUTON) ====================
local function createAccordion(parent, title)
    local container = new("Frame", {
        Parent = parent,
        Size = UDim2.new(1, 0, 0, 34),
        BackgroundColor3 = C.Panel2,
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.Y,
    })
    corner(container, 8)
    stroke(container, 1.2, 0.4, C.Purple, C.Accent)
    new("UIListLayout", {
        Parent = container,
        SortOrder = Enum.SortOrder.LayoutOrder,
    })

    local header = new("TextButton", {
        Parent = container,
        Size = UDim2.new(1, 0, 0, 34),
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false,
        LayoutOrder = 1,
    })

    new("TextLabel", {
        Parent = header,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 12, 0, 0),
        Size = UDim2.new(1, -44, 1, 0),
        Text = title,
        TextColor3 = C.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
    })

    local arrow = new("TextLabel", {
        Parent = header,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -28, 0, 0),
        Size = UDim2.new(0, 24, 1, 0),
        Text = "▶",
        TextColor3 = C.Accent,
        Font = Enum.Font.GothamBold,
        TextSize = 11,
    })

    local body = new("Frame", {
        Parent = container,
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1,
        Visible = false,
        AutomaticSize = Enum.AutomaticSize.Y,
        LayoutOrder = 2,
    })
    new("UIListLayout", {
        Parent = body,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 6),
    })
    new("UIPadding", {
        Parent = body,
        PaddingBottom = UDim.new(0, 8),
        PaddingLeft   = UDim.new(0, 10),
        PaddingRight  = UDim.new(0, 10),
    })

    local open = false
    header.MouseButton1Click:Connect(function()
        open = not open
        body.Visible = open
        arrow.Text = open and "▼" or "▶"
    end)

    return container, body
end

-- ==================== TOGGLE + SAYI INPUT ====================
local function createToggleInput(parent, opts)
    opts = opts or {}
    local row = new("Frame", {
        Parent = parent,
        Size = UDim2.new(1, 0, 0, 26),
        BackgroundTransparency = 1,
    })

    local enabled = false
    local value   = opts.default or 16

    local lbl = new("TextLabel", {
        Parent = row,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 4, 0, 0),
        Size = UDim2.new(1, -130, 1, 0),
        Text = opts.label or "Değer",
        TextColor3 = C.TextDim,
        Font = Enum.Font.GothamMedium,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
    })

    -- Toggle (kaydırıcı)
    local toggle = new("TextButton", {
        Parent = row,
        Size = UDim2.new(0, 42, 0, 22),
        Position = UDim2.new(1, -118, 0.5, -11),
        BackgroundColor3 = C.Panel,
        Text = "",
        AutoButtonColor = false,
        BorderSizePixel = 0,
    })
    corner(toggle, 11)
    stroke(toggle, 1.2, 0.3, C.Purple, C.Accent)

    local dot = new("Frame", {
        Parent = toggle,
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(0, 3, 0.5, -8),
        BackgroundColor3 = C.TextDim,
        BorderSizePixel = 0,
    })
    corner(dot, 8)

    -- Sayı kutusu
    local input = new("TextBox", {
        Parent = row,
        Size = UDim2.new(0, 68, 0, 22),
        Position = UDim2.new(1, -68, 0.5, -11),
        BackgroundColor3 = C.Panel,
        Text = tostring(value),
        TextColor3 = C.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        BorderSizePixel = 0,
        ClearTextOnFocus = false,
        PlaceholderText = "1-1200",
        PlaceholderColor3 = C.TextDim,
    })
    corner(input, 6)
    stroke(input, 1, 0.4, C.Purple, C.Accent)

    local function fire()
        if opts.onChanged then opts.onChanged(enabled, value) end
    end

    toggle.MouseButton1Click:Connect(function()
        enabled = not enabled
        Tween:Create(dot, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
            Position = enabled
                and UDim2.new(0, 23, 0.5, -8)
                or  UDim2.new(0, 3, 0.5, -8),
            BackgroundColor3 = enabled and C.Green or C.TextDim,
        }):Play()
        toggle.BackgroundColor3 = enabled and C.Panel3 or C.Panel
        lbl.TextColor3 = enabled and C.Accent or C.TextDim
        fire()
    end)

    input.FocusLost:Connect(function()
        local n = tonumber(input.Text) or value
        n = math.clamp(math.floor(n), opts.min or 1, opts.max or 1200)
        value = n
        input.Text = tostring(n)
        fire()
    end)

    return {
        getEnabled = function() return enabled end,
        getValue   = function() return value   end,
    }
end

-- ==================== KATEGORİLERİ OLUŞTUR ====================
createCategory("Main")
createCategory("Misc")

-- Main > Speed
do
    local _, body = createAccordion(pages.Main, "Speed")
    createToggleInput(body, {
        label   = "Hız (1 - 1200)",
        min     = 1,
        max     = 1200,
        default = 16,
        onChanged = function(en, val)
            print("[Lonex] Speed:", en, val)
        end,
    })
end

-- Misc > Örnek
do
    local _, body = createAccordion(pages.Misc, "Örnek Özellik")
    createToggleInput(body, {
        label   = "Değer",
        min     = 1,
        max     = 1200,
        default = 50,
        onChanged = function(en, val)
            print("[Lonex] Misc:", en, val)
        end,
    })
end

-- ==================== BAŞLANGIÇ ====================
task.defer(function()
    for _, b in ipairs(Sidebar:GetChildren()) do
        if b:IsA("TextButton") and b.Text == "Main" then
            b.BackgroundColor3 = C.Panel3
            b.TextColor3 = C.Accent
            break
        end
    end
    setCategory("Main")
end)

-- ==================== LN TOGGLE ====================
local open = true
ToggleBtn.MouseButton1Click:Connect(function()
    open = not open
    Main.Visible = open
end)

print("[Lonex Script] GUI yüklendi - " .. CONFIG.Version)
