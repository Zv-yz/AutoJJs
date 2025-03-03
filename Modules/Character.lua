local Character = {}
local TweenService = game:GetService("TweenService")

Character.__index = Character

function Character.new(Player: Player)
	local self = setmetatable({}, Character)
	
	self.Player = Player
	self.Connections = {}
	
	self.Character = Player.Character or Player.CharacterAdded:Wait()
	self.Humanoid = self.Character:WaitForChild("Humanoid", 95)
	self.Root = self.Character:WaitForChild("HumanoidRootPart", 95)
	
	table.insert(self.Connections, Player.CharacterAdded:Connect(function(Char)
		self.Character = Char
		self.Humanoid = Char:WaitForChild("Humanoid", 95)
		self.Root = Char:WaitForChild("HumanoidRootPart", 95)
	end))
	
	return self
end

function Character:ChangeHumanoidProp(Name, Value)
	if not self.Humanoid then return false, "Humanoid not found" end
	
	local Success, Result = pcall(function()
		self.Humanoid[Name] = Value
	end)
	
	if not Success then
		return false, Result
	end
	
	return true, nil
end

function Character:ChangeHumanoidState(Enum: Enum)
	if not self.Humanoid then return false, "Humanoid not found" end
	
	local Success, Result = pcall(function()
		self.Humanoid:ChangeState(Enum)
	end)
	
	if not Success then
		return false, Result
	end
	
	return true, nil
end

--> START: Humanoid Changes

function Character:ChangeWalkSpeed(Value: number) -- Debug.
	local Success, Result = self:ChangeHumanoidProp("WalkSpeed", Value)
	
	if not Success then
		return false, string.format("Error setting \"WalkSpeed\": %s", Result)
	end
	
	return true, nil
end

function Character:Jump()
	local Success, Result = self:ChangeHumanoidState(Enum.HumanoidStateType.Jumping)
	
	if not Success then
		return false, string.format("Error jumping: %s", Result)
	end

	return true, nil
end

--> END: Humanoid Changes

function Character:GetCharacter()
	return self.Character
end

function Character:GetHumanoid()
	return self.Humanoid
end

function Character:Destroy()
	for _, Connection in ipairs(self.Connections) do
		task.spawn(Connection.Disconnect, Connection)
	end
	
	for Item in self do
		self[Item] = nil
	end
	
	setmetatable(self, nil)
end


return Character