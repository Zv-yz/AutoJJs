local RemoteChat = {}

local TextChatService = game:GetService("TextChatService")
local Methods = {
	[Enum.ChatVersion.TextChatService] = function(Message: string)
		TextChatService.TextChannels.RBXGeneral:SendAsync(Message)
	end,
}

function RemoteChat:Send(Message: string)
	pcall(Methods[TextChatService.ChatVersion], Message)
end

return RemoteChat