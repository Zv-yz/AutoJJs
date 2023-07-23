-- ══════════════════════════════════════
--               Core				
-- ══════════════════════════════════════
local Find = function(Table) for i,v in pairs(Table or {}) do if typeof(v) == 'table' then return v end; end; end
local Options = Find(({...})) or {
    Keybind = 'Home',
    Language = 'pt-br',
    Rainbow = false,
}
local Version = '0.1'
local Parent = game:GetService('CoreGui');
local require = function(Name)
	return loadstring(game:HttpGet(('https://raw.githubusercontent.com/Zv-yz/AutoJJs/main/%s.lua'):format(Name)))()
end

-- ══════════════════════════════════════
--              Services				
-- ══════════════════════════════════════
local TweenService = game:GetService('TweenService')
local Players = game:GetService('Players')
local LP = Players.LocalPlayer

-- ══════════════════════════════════════
--              Modules				
-- ══════════════════════════════════════
local UI = require("UI")
local Character = require("Modules/Character")
local RemoteChat = require("Modules/RemoteChat")
local Extenso = require("Modules/Extenso")

-- ══════════════════════════════════════
--  	        Constants				
-- ══════════════════════════════════════
local Char = Character.new(LP)
local UIElements = UI.UIElements;

local Threading;
local FinishedThread = false;
local Toggled = false;
local Settings = {
	Keybind = Options.Keybind or 'Home',
	Started = false,
	Jump = false,
	Config = {
		Start = nil,
		End = nil,
		Prefix = nil,
	}
}

-- ══════════════════════════════════════
--              Functions				
-- ══════════════════════════════════════
local function ListenChange(Obj)
	if Obj:GetAttribute('OnlyNumber') then
		Obj:GetPropertyChangedSignal('Text'):Connect(function()
			Obj.Text = Obj.Text:gsub("[^%d]", "")
		end)
	end
	Obj.FocusLost:Connect(function()
		local CurrentText = Obj.Text
		if not CurrentText or string.match(CurrentText, "^%s*$") then return end
		Settings.Config[Obj.Parent.Name] = Obj.Text
	end)
end

local function DoJJ(n, prefix, jump)
	local extenso = Extenso:Convert(n)
	local prefix = prefix and prefix or ''
	RemoteChat:FireServer(('%s'):format(extenso .. prefix), 'All')
	if jump then Char:Jump() end
end

local function EndThread()
	if Threading then
		if not FinishedThread then task.cancel(Threading) end
		Threading = nil
		FinishedThread = false
		Settings["Started"] = false
	end
end

local function StartThread()
	local Config = Settings.Config;
	if not Config["Start"] or not Config["End"] then return end
	if Threading then EndThread() return end
	Threading = task.spawn(function()
		for i = Config.Start, Config.End do
			DoJJ(i, Config["Prefix"], Settings["Jump"])
			task.wait(2.5)
		end
		FinishedThread = true
		EndThread()
	end)
end

-- ══════════════════════════════════════
--                Main				
-- ══════════════════════════════════════
UI:SetVersion(Version)
UI:SetLanguage(Options.Language)
UI:SetRainbow(Options.Rainbow)
UI:SetParent(Parent)

for i,v in pairs(UIElements["Box"]) do
	ListenChange(v)
end

UIElements["Circle"].MouseButton1Click:Connect(function()
	if Toggled then
		Settings["Jump"] = false
		Toggled = false
        TweenService:Create(UIElements["Circle"], TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Position = UDim2.new(0.22, 0, 0.5, 0) }):Play()
		--UIElements["Circle"]:TweenPosition(UDim2.new(0.22,0,0.5,0),'Out','Quad',0.3,true,nil)
		TweenService:Create(UIElements["Slide"], TweenInfo.new(0.3), { BackgroundColor3 = Color3.fromRGB(20, 20, 20) }):Play()
	else
		Settings["Jump"] = true
		Toggled = true
        TweenService:Create(UIElements["Circle"], TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Position = UDim2.new(0.772, 0, 0.5, 0) }):Play()
        --UIElements["Circle"]:TweenPosition(UDim2.new(0.772,0,0.5,0),'Out','Quad',0.3,true,nil)
		TweenService:Create(UIElements["Slide"], TweenInfo.new(0.3), { BackgroundColor3 = Color3.fromRGB(37, 150, 255) }):Play()
	end
end)

UIElements["Play"].MouseButton1Up:Connect(function()
	if not Settings.Config["Start"] or not Settings.Config["End"] then return end
	if not Settings["Started"] then
		Settings["Started"] = true
		StartThread()
	else
		Settings["Started"] = false
		EndThread()
	end
end)