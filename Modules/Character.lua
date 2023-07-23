local module = {}
local cachefunc = {}
module.__index = module

function module.new(plr)
	local self = setmetatable({}, module)
	self.Player = plr;
	self.Character = (plr.Character or plr.CharacterAdded:Wait());
	cachefunc[plr] = plr.CharacterAdded:Connect(function(char)
		self.Character = char;
	end)
	return self
end

function module:GetCharacter()
	return self.Character;
end

function module:GetHumanoid()
	return self:GetCharacter():WaitForChild('Humanoid', 95)
end

function module:ChangeHumanoidProp(name, val)
	local Humanoid = self:GetHumanoid();
	if not Humanoid then return warn('[CHARACTER_MODULE]: Invalid humanoid?') end
	local s,e = pcall(function()
		Humanoid[name] = val
	end)
	if not s then
		return false, e
	end
	return true, nil;
end

function module:ChangeHumanoidState(enum: EnumItem)
	local Humanoid = self:GetHumanoid();
	if not Humanoid then return warn('[CHARACTER_MODULE]: Invalid humanoid?') end
	local s,e = pcall(function()
		Humanoid:ChangeState(enum)
	end)
	if not s then
		return false, e
	end
	return true, nil;
end

-- START: Humanoid Changes

function module:ChangeWalkSpeed(val: number)
	local result, _error = self:ChangeHumanoidProp('WalkSpeed', val)
	if not result then
		warn('[CHARACTER_MODULE]: Error setting "WalkSpeed":\n' .. _error)
		return
	end
end

function module:Jump()
	local result, _error = self:ChangeHumanoidState(Enum.HumanoidStateType.Jumping)
	if not result then
		warn('[CHARACTER_MODULE]: Error jumping character:\n' .. _error)
		return
	end
end

-- END: Humanoid Changes

function module:Destroy()
	if cachefunc[self.Player] then
		cachefunc[self.Player] = nil;
	end
	self.Player = nil;
	self.Character = nil;
end

return module
