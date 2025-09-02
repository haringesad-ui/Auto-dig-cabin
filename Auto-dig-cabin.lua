-- 🚀 Auto Digging Cabin Indo + GUI (KRNL Friendly)
local p = game.Players.LocalPlayer
_G.enabled = true
_G.loopDelay = 2

-- 🛠️ Tool Finder
local function getTool()
    return p.Character and p.Character:FindFirstChildOfClass("Tool")
end

-- 🛠️ Hole Finder
local function getHole()
    for _,v in pairs(workspace:GetDescendants()) do
        if v.Name:find(p.Name.."_Crater_Hitbox") then
            return v
        end
    end
end

-- 🔄 Core Auto Dig
local function autoDig()
    local tool = getTool()
    if tool then tool:Activate() end
    local h = getHole()
    if h then h:Destroy() end
end

-- Events
p.Character.ChildAdded:Connect(function(v)
    if _G.enabled and v:IsA("Tool") then
        task.wait(1)
        autoDig()
    end
end)

p.PlayerGui.ChildAdded:Connect(function(g)
    if _G.enabled then
        local bar = g:FindFirstChild("PlayerBar", true)
        local strong = g:FindFirstChild("Area_Strong", true)
        if bar and strong then
            bar:GetPropertyChangedSignal("Position"):Connect(function()
                if _G.enabled and math.abs(bar.Position.X.Scale - strong.Position.X.Scale) <= 0.04 then
                    autoDig()
                end
            end)
        end
    end
end)

p.AttributeChanged:Connect(function(attr)
    if _G.enabled and attr == "IsDigging" and not p:GetAttribute("IsDigging") then
        autoDig()
    end
end)

-- Backup Loop
spawn(function()
    while true do
        if _G.enabled then autoDig() end
        task.wait(_G.loopDelay)
    end
end)

-- 🌟 GUI KRNL Style
local gui = Instance.new("ScreenGui", p.PlayerGui)
gui.Name = "AutoDigGUI"

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 220, 0, 140)
main.Position = UDim2.new(0.1, 0, 0.1, 0)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true -- biar bisa dipindah

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,30)
title.Text = "⚒️ Cabin Indo Auto Dig"
title.BackgroundColor3 = Color3.fromRGB(40,40,40)
title.TextColor3 = Color3.fromRGB(0,255,0)
title.TextScaled = true

local toggle = Instance.new("TextButton", main)
toggle.Size = UDim2.new(1,-20,0,30)
toggle.Position = UDim2.new(0,10,0,40)
toggle.Text = "Auto Dig: ON"
toggle.BackgroundColor3 = Color3.fromRGB(60,60,60)
toggle.TextColor3 = Color3.fromRGB(255,255,255)
toggle.TextScaled = true

toggle.MouseButton1Click:Connect(function()
    _G.enabled = not _G.enabled
    toggle.Text = "Auto Dig: " .. (_G.enabled and "ON" or "OFF")
    title.TextColor3 = _G.enabled and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
end)

local delayBtn = Instance.new("TextButton", main)
delayBtn.Size = UDim2.new(1,-20,0,30)
delayBtn.Position = UDim2.new(0,10,0,80)
delayBtn.Text = "Loop Delay: ".._G.loopDelay.."s"
delayBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
delayBtn.TextColor3 = Color3.fromRGB(255,255,0)
delayBtn.TextScaled = true

delayBtn.MouseButton1Click:Connect(function()
    if _G.loopDelay == 2 then
        _G.loopDelay = 1
    elseif _G.loopDelay == 1 then
        _G.loopDelay = 0.5
    else
        _G.loopDelay = 2
    end
    delayBtn.Text = "Loop Delay: ".._G.loopDelay.."s"
end)

print("✅ Auto Dig Cabin Indo GUI Loaded (KRNL Friendly)")
