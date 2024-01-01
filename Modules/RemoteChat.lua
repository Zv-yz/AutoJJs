local RemoteChat = {};
local TextChatService = game:GetService('TextChatService')

local WC = game.WaitForChild
local FFC = game.FindFirstChild

local Player = game:GetService('Players').LocalPlayer
local PlayerGui = WC(Player, 'PlayerGui', 95)

local TypeChat = {
	[Enum.ChatVersion.LegacyChatService] = function(M)
		local ChatUI = WC(PlayerGui, 'Chat', 95)
		local ChatFrame = WC(ChatUI, 'Frame', 95)
		local CBPF = WC(ChatFrame, 'ChatBarParentFrame', 95)
		local _FRAME = WC(CBPF, 'Frame', 95)
		local BF = WC(_FRAME, 'BoxFrame', 95)
		local Frame = WC(BF, 'Frame', 95)

		local ChatBar = FFC(Frame, 'ChatBar', 95)

		ChatBar:CaptureFocus()
		ChatBar.Text = M;
		ChatBar:ReleaseFocus(true)
	end,
	[Enum.ChatVersion.TextChatService] = function(M)
		TextChatService.TextChannels.RBXGeneral:SendAsync(M)
	end,
}

function RemoteChat:Send(Message)
	pcall(TypeChat[TextChatService.ChatVersion], Message)
end

return RemoteChat