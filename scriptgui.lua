--[[ LONEX EXPLORER - Steal an Egg keşif aracı ]]

local LP = game:GetService("Players").LocalPlayer
local PG = LP:WaitForChild("PlayerGui")
local RS = game:GetService("ReplicatedStorage")
local SS = game:GetService("ServerStorage")

print("═══════════════════════════════════════")
print("🔍 LONEX EXPLORER BAŞLADI")
print("═══════════════════════════════════════")

-- 1) TÜM PROXIMITY PROMPT'LAR
print("\n[1] 📌 PROXIMITY PROMPT'LAR:")
local promptCount = 0
for _, d in ipairs(workspace:GetDescendants()) do
    if d:IsA("ProximityPrompt") then
        promptCount = promptCount + 1
        print(string.format("  • %s | Action: '%s' | Object: '%s' | Enabled: %s",
            d:GetFullName(), d.ActionText, d.ObjectText, tostring(d.Enabled)))
    end
end
print("  Toplam: " .. promptCount)

-- 2) TÜM CLICKDETECTOR'LAR
print("\n[2] 🖱️ CLICKDETECTOR'LAR:")
local cdCount = 0
for _, d in ipairs(workspace:GetDescendants()) do
    if d:IsA("ClickDetector") then
        cdCount = cdCount + 1
        print("  • " .. d:GetFullName())
    end
end
print("  Toplam: " .. cdCount)

-- 3) REPLICATEDSTORAGE REMOTE'LARI
print("\n[3] 📡 REPLICATEDSTORAGE REMOTE EVENTLERİ:")
local rsCount = 0
for _, d in ipairs(RS:GetDescendants()) do
    if d:IsA("RemoteEvent") or d:IsA("RemoteFunction") then
        rsCount = rsCount + 1
        print(string.format("  • %s [%s]", d:GetFullName(), d.ClassName))
    end
end
print("  Toplam: " .. rsCount)

-- 4) PLAYERGUI'DEKİ TÜM GUI'LER
print("\n[4] 🎨 PLAYERGUI:")
for _, g in ipairs(PG:GetChildren()) do
    print(string.format("  • %s [%s] | Enabled: %s",
        g.Name, g.ClassName, tostring(g.Enabled)))
end

-- 5) "EGG" GEÇEN HER ŞEY (workspace)
print("\n[5] 🥚 WORKSPACE'TE 'EGG' GEÇEN NESNELER:")
local eggCount = 0
for _, d in ipairs(workspace:GetDescendants()) do
    if d.Name:lower():find("egg") then
        eggCount = eggCount + 1
        if eggCount <= 30 then  -- ilk 30 tanesini göster
            print(string.format("  • %s [%s] | Pos: %s",
                d:GetFullName(), d.ClassName,
                d:IsA("BasePart") and tostring(d.Position) or "—"))
        end
    end
end
print("  Toplam: " .. eggCount .. " (ilk 30'u gösterildi)")

-- 6) WORKSPACE'TEKİ ÜST SEVİYE KLASÖRLER
print("\n[6] 📁 WORKSPACE ÜST SEVİYE:")
for _, d in ipairs(workspace:GetChildren()) do
    print(string.format("  • %s [%s]", d.Name, d.ClassName))
end

-- 7) OYUNCUYA ÖZEL KLASÖRLER
print("\n[7] 👤 OYUNCU KLASÖRLERİ:")
for _, p in ipairs(game.Players:GetPlayers()) do
    print("  • " .. p.Name)
    -- Kullanıcının plot'unu bulmaya çalış
    for _, d in ipairs(workspace:GetChildren()) do
        if d.Name:lower():find(p.Name:lower()) then
            print("      → Plot: " .. d:GetFullName() .. " [" .. d.ClassName .. "]")
        end
    end
end

-- 8) HUD / HOTBAR / ENVANTER BENZERİ
print("\n[8] 🎒 ENVANTER / HOTBAR BENZERİ:")
for _, g in ipairs(PG:GetChildren()) do
    if g:IsA("ScreenGui") then
        for _, c in ipairs(g:GetChildren()) do
            if c.Name:lower():find("held")
            or c.Name:lower():find("carry")
            or c.Name:lower():find("egg")
            or c.Name:lower():find("drop")
            or c.Name:lower():find("inventory") then
                print(string.format("  • %s | Visible: %s", c:GetFullName(), tostring(c.Visible)))
            end
        end
    end
end

print("\n═══════════════════════════════════════")
print("✅ KEŞİF TAMAMLANDI")
print("═══════════════════════════════════════")
