--// Celestial UI Library (Single File Core)
--// ScriptWare compatible

local Library = {}
Library.__index = Library

Library.Flags = {}
Library.Windows = {}

-- services
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

-------------------------------------------------
-- WINDOW
-------------------------------------------------
local Window = {}
Window.__index = Window

function Window.new(cfg, Lib)
    local self = setmetatable({}, Window)

    self.Library = Lib
    self.Tabs = {}
    self.Name = cfg.Name or "Celestial"

    -- GUI
    local gui = Instance.new("ScreenGui")
    gui.Name = "CelestialUI"
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false
    gui.Parent = game:GetService("CoreGui")

    local main = Instance.new("Frame", gui)
    main.Size = UDim2.fromScale(0.45, 0.6)
    main.Position = UDim2.fromScale(0.5, 0.5)
    main.AnchorPoint = Vector2.new(0.5, 0.5)
    main.BackgroundColor3 = Color3.fromRGB(12, 15, 25)
    main.BorderSizePixel = 0

    local corner = Instance.new("UICorner", main)
    corner.CornerRadius = UDim.new(0, 12)

    -- mobile scale
    local scale = Instance.new("UIScale", main)
    if UIS.TouchEnabled then
        scale.Scale = 0.85
    end

    self.Gui = gui
    self.Main = main

    return self
end

function Window:CreateTab(name, icon)
    local Tab = TabModule.new(self, name, icon)
    table.insert(self.Tabs, Tab)
    return Tab
end

-------------------------------------------------
-- TAB
-------------------------------------------------
TabModule = {}
TabModule.__index = TabModule

function TabModule.new(Window, name, icon)
    local self = setmetatable({}, TabModule)

    self.Window = Window
    self.Elements = {}

    -- page
    local page = Instance.new("Frame", Window.Main)
    page.Size = UDim2.fromScale(1, 1)
    page.BackgroundTransparency = 1
    page.Visible = (#Window.Tabs == 0)

    self.Page = page

    return self
end

-------------------------------------------------
-- TOGGLE
-------------------------------------------------
local Toggle = {}
Toggle.__index = Toggle

function Toggle.new(Tab, cfg)
    local self = setmetatable({}, Toggle)

    self.Value = cfg.Default or false
    self.Flag = cfg.Flag
    self.Callback = cfg.Callback or function() end

    Tab.Window.Library.Flags[self.Flag] = self.Value

    -- UI
    local frame = Instance.new("TextButton", Tab.Page)
    frame.Size = UDim2.new(1, -20, 0, 42)
    frame.Position = UDim2.fromOffset(10, 10 + (#Tab.Elements * 46))
    frame.BackgroundColor3 = Color3.fromRGB(20, 24, 38)
    frame.Text = cfg.Name or "Toggle"
    frame.TextColor3 = Color3.fromRGB(220,220,220)
    frame.BorderSizePixel = 0
    frame.AutoButtonColor = false

    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 10)

    frame.MouseButton1Click:Connect(function()
        self:Set(not self.Value)
    end)

    self.Frame = frame
    table.insert(Tab.Elements, self)

    self.Callback(self.Value)
    return self
end

function Toggle:Set(v)
    self.Value = v
    self.Frame.BackgroundColor3 = v
        and Color3.fromRGB(94,231,255)
        or Color3.fromRGB(20,24,38)

    self.Callback(v)
end

-------------------------------------------------
-- TAB API
-------------------------------------------------
function TabModule:AddToggle(cfg)
    return Toggle.new(self, cfg)
end

-------------------------------------------------
-- LIBRARY API
-------------------------------------------------
function Library:CreateWindow(cfg)
    local win = Window.new(cfg, self)
    table.insert(self.Windows, win)
    return win
end

-------------------------------------------------
-- RETURN
-------------------------------------------------
return setmetatable({}, Library)
