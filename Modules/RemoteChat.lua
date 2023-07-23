local RemoteChat = nil;
local WC = game.WaitForChild
local FFC = game.FindFirstChild
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local DefaultRobloxChatEvents = FFC(ReplicatedStorage, 'DefaultChatSystemChatEvents')
--
if DefaultRobloxChatEvents and FFC(DefaultRobloxChatEvents, 'SayMessageRequest') then
	RemoteChat = FFC(DefaultRobloxChatEvents, 'SayMessageRequest');
end

return RemoteChat