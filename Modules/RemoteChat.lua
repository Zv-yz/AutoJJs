local RemoteChat = {}
local Channels = {}

local WC = game.WaitForChild
local FFC = game.FindFirstChild

local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui", 95)

local Methods = {
	[Enum.ChatVersion.LegacyChatService] = function(Message: string)
		local ChatUI = PlayerGui:FindFirstChild("Chat")

		if ChatUI then
			local ChatFrame = WC(ChatUI, "Frame", 95)
			local CBPF = WC(ChatFrame, "ChatBarParentFrame", 95)
			
			local Frame = WC(CBPF, "Frame", 95)
			local BF = WC(Frame, "BoxFrame", 95)

			local ChatFM = WC(BF, "Frame", 95)
			local ChatBar = FFC(ChatFM, "ChatBar", 95)

			ChatBar:CaptureFocus()
			ChatBar.Text = Message
			ChatBar:ReleaseFocus(true)
		else
			Channels["RBXGeneral"]:SendAsync(Message)
		end
	end,

	[Enum.ChatVersion.TextChatService] = function(Message: string)
		Channels["RBXGeneral"]:SendAsync(Message)
	end,
}

function RemoteChat:Send(Message: string)
	pcall(Methods[TextChatService.ChatVersion], Message)
end

for _, Channel in ipairs(TextChatService:GetDescendants()) do
	if Channel:IsA("TextChannel") then
		Channels[Channel.Name] = Channel
	end
end

return RemoteChat