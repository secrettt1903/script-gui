--[[ LONEX - STEAL AN EGG MODÜLÜ (Virex'ten uyarlanmış) ]]

local ProximityPromptService = game:GetService("ProximityPromptService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LP = game:GetService("Players").LocalPlayer

-- ============ STATE ============
local SAE = {
    AutoCollect = false,
    AntiHit = false,
    SpeedEnabled = false,
    TargetSpeed = 700,
    IsTeleporting = false,
}

-- ============ ANTI-HIT TELEPORT ROTASI ============
-- Bu koordinatlar SAE haritasına özel. Güncelleme gelirse değişebilir.
local TELEPORT_POINTS = {
    Vector3.new(500.62, 241.28, -366.64),
    Vector3.new(504.45, 155.80, -366.35),
    Vector3.new(508.30, 70.28, -366.03),
    Vector3.new(513.86, 70.28, -366.25),
    Vector3.new(519.43, 70.28, -366.47),
    Vector3.new(524.32, 70.28, -366.59),
    Vector3.new(529.22, 70.28, -366.71),
    Vector3.new(538.01, 70.28, -365.55),
    Vector3.new(546.80, 70.28, -364.40),
}

-- ============ AUTO COLLECT ============
-- Sadece "collect / take / pickup / steal" içeren promptları tetikler
local function IsCollectPrompt(prompt)
    if not prompt:IsA("ProximityPrompt") then return false end
    local a = string.lower(prompt.ActionText or "")
    local o = string.lower(prompt.ObjectText or "")
    for _, kw in ipairs({"collect","take","pickup","pick up","steal"}) do
        if string.find(a, kw, 1, true) or string.find(o, kw, 1, true) then
            return true
        end
    end
    return false
end

local function TryCollectPrompt(prompt)
    if not SAE.AutoCollect then return end
    if not IsCollectPrompt(prompt) then return end

    local char = LP.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local parent = prompt.Parent
    if not parent then return end

    local part
    if parent:IsA("BasePart") then
        part = parent
    elseif parent:IsA("Attachment") then
        part = parent.Parent
    end
    if not part or not part:IsA("BasePart") then return end

    local dist = (root.Position - part.Position).Magnitude
    if dist <= prompt.MaxActivationDistance then
        pcall(function()
            prompt:InputHoldBegin()
            task.wait(math.max(prompt.HoldDuration, 0.05))
            prompt:InputHoldEnd()
        end)
    end
end

ProximityPromptService.PromptShown:Connect(function(prompt)
    if SAE.AutoCollect then
        task.spawn(TryCollectPrompt, prompt)
    end
end)

-- ============ ANTI-HIT (Teleport Rotası) ============
local function TeleportRoute()
    if SAE.IsTeleporting then return end
    local char = LP.Character
    if not char then return end

    SAE.IsTeleporting = true
    for _, pos in ipairs(TELEPORT_POINTS) do
        if not char.Parent then break end
        char:PivotTo(CFrame.new(pos))
        task.wait(0.12)
    end
    SAE.IsTeleporting = false
end

-- Yumurta alındığında otomatik tetiklenir
ProximityPromptService.PromptTriggered:Connect(function(prompt, player)
    if player ~= LP then return end
    if not SAE.AntiHit then return end
    task.spawn(TeleportRoute)
end)

-- ============ SPEED OVERRIDE ============
RunService.Heartbeat:Connect(function()
    if not SAE.SpeedEnabled then return end
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = SAE.TargetSpeed
    end
end)

-- Karakter respawn olursa tekrar uygula
LP.CharacterAdded:Connect(function(char)
    task.wait(1)
    if SAE.SpeedEnabled then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = SAE.TargetSpeed end
    end
end)

-- ============ GUI BUTONLARI İÇİN API ============
-- Kendi Lonex GUI'nden şu fonksiyonları çağırabilirsin:

_G.LonexSAE = {
    SetAutoCollect = function(state)
        SAE.AutoCollect = state
    end,
    SetAntiHit = function(state)
        SAE.AntiHit = state
    end,
    SetSpeed = function(state, value)
        SAE.SpeedEnabled = state
        if value then SAE.TargetSpeed = value end
        -- Kapatılınca normal hıza dön
        if not state then
            local char = LP.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then hum.WalkSpeed = 16 end
            end
        end
    end,
}
