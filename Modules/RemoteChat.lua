local RemoteChat = {}

local WC = game.WaitForChild
local FFC = game.FindFirstChild

local TextChatService = game:GetService("TextChatService")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local PlayerGui = WC(Player, "PlayerGui", 95)

local Methods = {
	--> Info: Legacy Chat going to be removed on April 30th, 2025.
	--> Source: https://devforum.roblox.com/t/migrate-to-textchatservice-removing-support-for-legacy-chat-and-custom-chat-systems/3237100
	
	[Enum.ChatVersion.LegacyChatService] = function(Message: string)
		local ChatUI = WC(PlayerGui, "Chat", 95)
		local ChatFrame = WC(ChatUI, "Frame", 95)
		local CBPF = WC(ChatFrame, "ChatBarParentFrame", 95)
		local _FRAME = WC(CBPF, "Frame", 95)
		local BF = WC(_FRAME, "BoxFrame", 95)
		local Frame = WC(BF, "Frame", 95)

		local ChatBar = FFC(Frame, "ChatBar", 95)

		ChatBar:CaptureFocus()
		ChatBar.Text = Message
		ChatBar:ReleaseFocus(true)
	end,
	
	[Enum.ChatVersion.TextChatService] = function(Message: string)
		TextChatService.TextChannels.RBXGeneral:SendAsync(Message)
	end,
}

function RemoteChat:Send(Message: string)
	pcall(Methods[TextChatService.ChatVersion], Message)
end

return RemoteChat