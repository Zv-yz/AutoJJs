local RemoteChat = {};
--local Data = {}

local WC = game.WaitForChild
local FFC = game.FindFirstChild

local Player = game:GetService('Players').LocalPlayer
local PlayerGui = WC(Player, 'PlayerGui', 95)


-- local function getRemote()
-- 	local ReplicatedStorage = game:GetService('ReplicatedStorage')
-- 	local DefaultRobloxChatEvents = FFC(ReplicatedStorage, 'DefaultChatSystemChatEvents')


-- 	if DefaultRobloxChatEvents and FFC(DefaultRobloxChatEvents, 'SayMessageRequest') then
-- 		Data.Remote = FFC(DefaultRobloxChatEvents, 'SayMessageRequest');
-- 	end
-- end

function RemoteChat:Send(Message)
	local ChatUI = WC(PlayerGui, 'Chat', 95)
	local ChatFrame = WC(ChatUI, 'Frame', 95)
	local CBPF = WC(ChatFrame, 'ChatBarParentFrame', 95)
	local _FRAME = WC(CBPF, 'Frame', 95)
	local BF = WC(_FRAME, 'BoxFrame', 95)
	local Frame = WC(BF, 'Frame', 95)

	local ChatBar = FFC(Frame, 'ChatBar', 95)

	ChatBar:CaptureFocus()
	ChatBar.Text = Message
	ChatBar:ReleaseFocus(true)
end

return RemoteChat