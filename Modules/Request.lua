local Request = {}
local HttpService = game:GetService("HttpService");

Request.__index = Request

function Request:HasFunction(Name: string)
	local Success, Result = pcall(function()
		return game[Name]
	end)
	
	if Success then
		return game[Name]
	end
	
	return nil
end

function Request:IsSupported(Functions)
	local Result = false
	
	for _, Function in pairs(Functions) do
		if typeof(Function) == "function" then
			Result = true
		end
	end
	
	return Result
end

function Request:Post(Url, Data)
    local Functions = {
        Request = (request or http_request) or (http and http.request) or (syn and syn.request);
        Post = self:HasFunction("HttpPost");
    }

	if not self:IsSupported(Functions) then return "Not Supported" end
	
	if Functions.Request then
		return Functions.Request({
			Url = Url,
			Method = "POST",
			Headers = { ["Content-Type"] = "application/json" },
			Body = HttpService:JSONEncode(Data or {})
		})
	elseif Functions.Post then
		return Functions.Post(Functions.Post, Url, HttpService:JSONEncode(Data))
	end
end

return setmetatable({}, Request)
