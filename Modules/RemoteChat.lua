local RemoteChat = {}

local TextChatService = game:GetService("TextChatService")
local Channels = {}

local Methods = {
	[Enum.ChatVersion.LegacyChatService] = function(Message: string)
		Channels["RBXGeneral"]:SendAsync(Message)
	end,
	
	[Enum.ChatVersion.TextChatService] = function(Message: string)
		Channels["RBXGeneral"]:SendAsync(Message)
	end,
}

function RemoteChat:Send(Message: string)
	if not Channels["RBXGeneral"] then
		return
	end

	pcall(Methods[TextChatService.ChatVersion], Message)
end

for _, Channel in ipairs(TextChatService.TextChannels:GetChildren()) do
	if Channel:IsA("TextChannel") then
		Channels[Channel.Name] = Channel
	end
end

return RemoteChat