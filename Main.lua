-- ══════════════════════════════════════
--               Core				
-- ══════════════════════════════════════
local Find = function(Table) for _, Item in pairs(Table or {}) do if typeof(Item) == "table" then return Item end; end; end
local Options = Find(({...})) or {
	Keybind = "Home",

	Language = {
		UI = "pt-br",
		Words = "pt-br"
	},

	Experiments = { },

	Tempo = 2.5,
	Rainbow = false,
}

local Version = "2.1"
local Parent = gethui() or game:GetService("CoreGui");
local require = function(Name)
	return loadstring(game:HttpGet(string.format("https://raw.githubusercontent.com/Zv-yz/AutoJJs/main/%s.lua", Name)))()
end

-- ══════════════════════════════════════
--              Services				
-- ══════════════════════════════════════
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LP = Players.LocalPlayer

-- ══════════════════════════════════════
--              Modules				
-- ══════════════════════════════════════
local UI = require("UI")
local Notification = require("Notification")

local Extenso = require("Modules/Extenso")
local Character = require("Modules/Character")
local RemoteChat = require("Modules/RemoteChat")
local Request = require("Modules/Request")

-- ══════════════════════════════════════
--  	        Constants				
-- ══════════════════════════════════════
local Char = Character.new(LP)
local UIElements = UI.UIElements;
local Connections = {};

local Threading;
local FinishedThread = false;
local Toggled = false;

local Settings = {
	Keybind = Options.Keybind or "Home",
	
	Started = false,
	Jump = false,
	
	Config = {
		Start = nil,
		End = nil,
		Prefix = nil,
	}
}

-- ══════════════════════════════════════
--              Methods				
-- ══════════════════════════════════════

local Methods = {
	["Normal"] = function(Message: string, Prefix: string)
		if Settings["Jump"] then
			Char:Jump()
		end
		
		RemoteChat:Send(string.format("%s%s", Message, Prefix))
	end,
	
	["Lowercase"] = function(Message: string, Prefix: string)
		if Settings["Jump"] then
			Char:Jump()
		end
		
		RemoteChat:Send(string.format("%s%s", string.lower(Message), Prefix))
	end,

	["GJ"] = function(Message: string, Prefix: string)
		if Settings["Jump"] then
			Char:Jump()
		end
		
		RemoteChat:Send(string.format("%s%s", string.sub(Message, 1, 1) .. string.lower(string.sub(Message, 2)), Prefix))
	end,
	
	["HJ"] = function(Message: string, Prefix: string)
		for I = 1, #Message do
			if Settings["Jump"] then
				Char:Jump()
			end
			
			RemoteChat:Send(string.format("%s%s", string.sub(Message, I, I), Prefix))
			task.wait(Options.Tempo)
		end
		
		if Settings["Jump"] then
			Char:Jump()
		end
		
		RemoteChat:Send(string.format("%s%s", Message, Prefix))
	end,
}

-- ══════════════════════════════════════
--              Functions				
-- ══════════════════════════════════════

local function Listen(Name, Element)
	if Element:GetAttribute("IntBox") then
		table.insert(Connections, Element:GetPropertyChangedSignal("Text"):Connect(function()
			Element.Text = string.gsub(Element.Text, "[^%d]", "")
		end))
	end
	
	table.insert(Connections, Element.FocusLost:Connect(function()
		local CurrentText = Element.Text
		if not CurrentText or string.match(CurrentText, "^%s*$") then return end
		Settings.Config[Name] = Element.Text
	end))
end

local function EndThread(Success)
	if Threading then
		if not FinishedThread then
			task.cancel(Threading)
		end
		
		Threading = nil
		FinishedThread = false
		Settings["Started"] = false
		
		Notification:Notify(Success and 6 or 12, nil, nil, nil)
	end
end

local function DoJJ(Name: string, Number: number, Prefix: string)
	local Success: boolean, String: string? = Extenso:Convert(Number)
	local Prefix = Prefix and Prefix or ""
	
	local Method: (String: string, Prefix: string) -> ()? = Methods[Name]
	
	if not Method then
		Notification:Notify(12, nil, nil, nil)
	end
	
	if Success then
		Method(String, Prefix)
	end
end

local function StartThread()
	local Config = Settings.Config;
	
	if not Config["Start"] or not Config["End"] then return end
	if Threading then EndThread(false) return end
	
	local Method = 
		table.find(Options.Experiments, "hell_jacks_2024_02-dev") and "HJ" or
		table.find(Options.Experiments, "lowercase_jjs_2024_12") and "Lowercase" or
		table.find(Options.Experiments, "grammar_jacks_2025_06") and "GJ" or
		"Normal"
	
	Notification:Notify(5, nil, nil, nil)
	Threading = task.spawn(function()
		for Amount = Config.Start, Config.End do
			DoJJ(Method, Amount, Config["Prefix"])
			
			if Amount ~= tonumber(Config.End) then
				task.wait(Options.Tempo)
			end
		end
		
		FinishedThread = true
		EndThread(true)
	end)
end

local function GetLanguage(Lang: string)
	local Success, Result = pcall(function()
		return require(string.format("I18N/%s", Lang))
	end)
	
	if Success then
		return Result
	end
	
	return {}
end

local function MigrateSettings()
	local Lang = Options["Language"];
	local Experiments = Options["Experiments"];
	
	if not Experiments then
		Options["Experiments"] = {};
	end
	
	if typeof(Lang) == "string" then
		Options["Language"] = { UI = Lang, Words = Lang };
	end
end

MigrateSettings()

-- ══════════════════════════════════════
--                Main				
-- ══════════════════════════════════════
local UILang, WordsLang = GetLanguage(Options.Language.UI), GetLanguage(Options.Language.Words)

UI:SetVersion(Version)
UI:SetLanguage(UILang.UI)
UI:SetRainbow(Options.Rainbow)
UI:SetParent(Parent)

Notification:SetParent(UI.getUI())
Notification:SetLang(UILang.Notification) 
Extenso:SetLang(WordsLang)

for Name, Element in pairs(UIElements["Box"]) do
	task.spawn(Listen, Name, Element)
end

table.insert(Connections, UIElements["Circle"].MouseButton1Click:Connect(function()
	if Toggled then
		Settings["Jump"] = false
		Toggled = false
		TweenService:Create(UIElements["Circle"], TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Position = UDim2.new(0.22, 0, 0.5, 0) }):Play()
		TweenService:Create(UIElements["Slide"], TweenInfo.new(0.3), { BackgroundColor3 = Color3.fromRGB(20, 20, 20) }):Play()
	else
		Settings["Jump"] = true
		Toggled = true
		TweenService:Create(UIElements["Circle"], TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Position = UDim2.new(0.772, 0, 0.5, 0) }):Play()
		TweenService:Create(UIElements["Slide"], TweenInfo.new(0.3), { BackgroundColor3 = Color3.fromRGB(37, 150, 255) }):Play()
	end
end))

table.insert(Connections, UIElements["Play"].MouseButton1Up:Connect(function()
	if not Settings.Config["Start"] or not Settings.Config["End"] then return end
	if not Settings["Started"] then
		Settings["Started"] = true
		StartThread()
	else
		Settings["Started"] = false
		EndThread(false)
	end
end))

if Notification then
	Notification:SetupJJs()
end

Request:Post("https://scripts-zvyz.glitch.me/api/count")
