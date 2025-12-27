--====================================================
-- ChutHUB | SINGLE FILE | Stable | No HttpGet
--====================================================

-- SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

local Player = Players.LocalPlayer

-- MOUSE FIX
pcall(function()
    UIS.MouseIconEnabled = true
    UIS.MouseBehavior = Enum.MouseBehavior.Default
end)

-- CLEAN
pcall(function()
    if game.CoreGui:FindFirstChild("ChutHUB") then
        game.CoreGui.ChutHUB:Destroy()
    end
end)

--====================================================
-- GUI ROOT
--====================================================
local Gui = Instance.new("ScreenGui", game.CoreGui)
Gui.Name = "ChutHUB"
Gui.ResetOnSpawn = false

-- MAIN WINDOW
local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.fromScale(0.48, 0.6)
Main.Position = UDim2.fromScale(0.5, 0.5)
Main.AnchorPoint = Vector2.new(0.5,0.5)
Main.BackgroundColor3 = Color3.fromRGB(18,18,24)
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,14)

local OriginalSize = Main.Size

--====================================================
-- TOP BAR
--====================================================
local Top = Instance.new("Frame", Main)
Top.Size = UDim2.new(1,0,0,42)
Top.BackgroundColor3 = Color3.fromRGB(28,28,36)
Top.BorderSizePixel = 0
Instance.new("UICorner", Top).CornerRadius = UDim.new(0,14)

local Title = Instance.new("TextLabel", Top)
Title.Size = UDim2.new(1,-90,1,0)
Title.Position = UDim2.new(0,12,0,0)
Title.Text = "🌱 ChutHUB"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextColor3 = Color3.new(1,1,1)
Title.BackgroundTransparency = 1

-- MINIMIZE
local MinBtn = Instance.new("TextButton", Top)
MinBtn.Size = UDim2.new(0,32,0,24)
MinBtn.Position = UDim2.new(1,-44,0.5,-12)
MinBtn.Text = "–"
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 20
MinBtn.TextColor3 = Color3.new(1,1,1)
MinBtn.BackgroundColor3 = Color3.fromRGB(70,70,90)
MinBtn.BorderSizePixel = 0
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0,6)

--====================================================
-- RESTORE BUTTON
--====================================================
local Restore = Instance.new("TextButton", Gui)
Restore.Size = UDim2.fromOffset(140,36)
Restore.Position = UDim2.fromScale(0.05,0.5)
Restore.Text = "🌱 Open ChutHUB"
Restore.Visible = false
Restore.Font = Enum.Font.Gotham
Restore.TextSize = 14
Restore.TextColor3 = Color3.new(1,1,1)
Restore.BackgroundColor3 = Color3.fromRGB(40,140,90)
Restore.BorderSizePixel = 0
Instance.new("UICorner", Restore).CornerRadius = UDim.new(0,10)

--====================================================
-- CONTENT
--====================================================
local Content = Instance.new("ScrollingFrame", Main)
Content.Position = UDim2.new(0,10,0,52)
Content.Size = UDim2.new(1,-20,1,-62)
Content.CanvasSize = UDim2.new(0,0,0,0)
Content.ScrollBarImageTransparency = 0.6
Content.BackgroundTransparency = 1
Content.BorderSizePixel = 0

local Layout = Instance.new("UIListLayout", Content)
Layout.Padding = UDim.new(0,8)

Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Content.CanvasSize = UDim2.new(0,0,0,Layout.AbsoluteContentSize.Y + 10)
end)

--====================================================
-- UI HELPERS
--====================================================
local function Button(text, callback)
    local b = Instance.new("TextButton", Content)
    b.Size = UDim2.new(1,0,0,36)
    b.Text = text
    b.Font = Enum.Font.Gotham
    b.TextSize = 14
    b.TextColor3 = Color3.new(1,1,1)
    b.BackgroundColor3 = Color3.fromRGB(50,50,70)
    b.BorderSizePixel = 0
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)
    b.MouseButton1Click:Connect(function()
        pcall(callback)
    end)
end

--====================================================
-- DROPDOWN (REAL)
--====================================================
local SelectedItems = {}

local function MultiDropdown(title, items)
    local open = false

    local Holder = Instance.new("Frame", Content)
    Holder.Size = UDim2.new(1,0,0,38)
    Holder.BackgroundTransparency = 1

    local Head = Instance.new("TextButton", Holder)
    Head.Size = UDim2.new(1,0,0,38)
    Head.Text = "▼ "..title
    Head.Font = Enum.Font.Gotham
    Head.TextSize = 14
    Head.TextColor3 = Color3.new(1,1,1)
    Head.BackgroundColor3 = Color3.fromRGB(55,55,75)
    Head.BorderSizePixel = 0
    Instance.new("UICorner", Head).CornerRadius = UDim.new(0,8)

    local List = Instance.new("Frame", Holder)
    List.Position = UDim2.new(0,0,0,42)
    List.Size = UDim2.new(1,0,0,0)
    List.BackgroundColor3 = Color3.fromRGB(40,40,55)
    List.ClipsDescendants = true
    List.BorderSizePixel = 0
    Instance.new("UICorner", List).CornerRadius = UDim.new(0,8)

    local L = Instance.new("UIListLayout", List)
    L.Padding = UDim.new(0,6)

    local function resize()
        if open then
            local h = L.AbsoluteContentSize.Y + 8
            TweenService:Create(List,TweenInfo.new(0.25),{Size=UDim2.new(1,0,0,h)}):Play()
            Holder.Size = UDim2.new(1,0,0,42+h)
        else
            TweenService:Create(List,TweenInfo.new(0.25),{Size=UDim2.new(1,0,0,0)}):Play()
            Holder.Size = UDim2.new(1,0,0,38)
        end
    end

    for _,name in ipairs(items) do
        local it = Instance.new("TextButton", List)
        it.Size = UDim2.new(1,-10,0,32)
        it.Position = UDim2.new(0,5,0,0)
        it.Text = name
        it.Font = Enum.Font.Gotham
        it.TextSize = 13
        it.TextColor3 = Color3.new(1,1,1)
        it.BackgroundColor3 = Color3.fromRGB(60,60,80)
        it.BorderSizePixel = 0
        Instance.new("UICorner", it).CornerRadius = UDim.new(0,6)

        it.MouseButton1Click:Connect(function()
            SelectedItems[name] = not SelectedItems[name]
            it.BackgroundColor3 = SelectedItems[name] and Color3.fromRGB(80,140,255) or Color3.fromRGB(60,60,80)
        end)
    end

    Head.MouseButton1Click:Connect(function()
        open = not open
        Head.Text = (open and "▲ " or "▼ ")..title
        resize()
    end)
end

--====================================================
-- EVENT PREVIEW
--====================================================
Button("👀 Preview Event (Client)", function()
    local m = RS.Modules:FindFirstChild("UpdateService")
    if m then
        for _,v in pairs(m:GetChildren()) do
            v.Parent = workspace
        end
    end
end)

--====================================================
-- DROPDOWN ITEMS
--====================================================
MultiDropdown("Auto Buy Items", {
    "Firework",
    "New Year's Firework",
    "Dragon's Firework",
    "Party Sign",
    "Disco Ball",
    "Sparkle Slice",
    "New Year's Egg"
})

local AutoBuy = false
Button("🛒 Toggle Auto Buy", function()
    AutoBuy = not AutoBuy
end)

--====================================================
-- STOCK-AWARE BURST AUTO BUY
--====================================================
local lastStock = {}

task.spawn(function()
    while task.wait(0.5) do
        if not AutoBuy then continue end

        local data = require(RS.Modules.DataService):GetData()
        local shop = data.EventShopStock and data.EventShopStock["New Years Shop"]
        if not shop or not shop.Stocks then continue end

        for item,enabled in pairs(SelectedItems) do
            if enabled then
                local s = shop.Stocks[item]
                if s then
                    local cur = s.Stock
                    local prev = lastStock[item] or 0

                    if cur > prev and cur > 0 then
                        for i = 1, cur do
                            RS.GameEvents.BuyEventShopStock:FireServer(item,"New Years Shop")
                            task.wait(0.08)
                        end
                    end

                    lastStock[item] = cur
                end
            end
        end
    end
end)

--====================================================
-- MINIMIZE / RESTORE ANIMATION
--====================================================
MinBtn.MouseButton1Click:Connect(function()
    TweenService:Create(Main,TweenInfo.new(0.25),{Size=UDim2.new(0,0,0,0)}):Play()
    task.wait(0.25)
    Main.Visible = false
    Restore.Visible = true
end)

Restore.MouseButton1Click:Connect(function()
    Main.Visible = true
    Restore.Visible = false
    TweenService:Create(Main,TweenInfo.new(0.25),{Size=OriginalSize}):Play()
end)

--====================================================
-- DRAG + SNAP + SAVE POSITION
--====================================================
local SAVE = "ChutHUB_Pos"

pcall(function()
    if isfile and readfile and isfile(SAVE) then
        local d = HttpService:JSONDecode(readfile(SAVE))
        Restore.Position = UDim2.fromScale(d.X,d.Y)
    end
end)

local dragging, start, pos
Restore.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        start = i.Position
        pos = Restore.Position
    end
end)

UIS.InputChanged:Connect(function(i)
    if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local d = i.Position - start
        Restore.Position = pos + UDim2.fromOffset(d.X,d.Y)
    end
end)

UIS.InputEnded:Connect(function(i)
    if dragging then
        dragging = false
        local x = Restore.Position.X.Scale < 0.5 and 0.02 or 0.98
        Restore.Position = UDim2.new(x,-Restore.AbsoluteSize.X/2,Restore.Position.Y.Scale,0)
        if writefile then
            writefile(SAVE,HttpService:JSONEncode({
                X = Restore.Position.X.Scale,
                Y = Restore.Position.Y.Scale
            }))
        end
    end
end)

--====================================================
-- KEY TOGGLE
--====================================================
UIS.InputBegan:Connect(function(i,g)
    if g then return end
    if i.KeyCode == Enum.KeyCode.H then
        if Main.Visible then
            MinBtn:Activate()
        else
            Restore:Activate()
        end
    end
end)

print("✅ ChutHUB fully loaded")
