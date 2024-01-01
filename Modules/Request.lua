local module = {}
local HTTPService = game:GetService('HttpService');

function checkHost(func)
	local s,e = pcall(function()
		return game[func];
	end)
	
	if s then
		return game[func];
	end
	
	return nil
end

function getSupported(funcs)
	local tbl = {}
	for i,v in pairs(funcs) do
		if typeof(v) == 'function' then
			table.insert(tbl, true)
		end
	end
	return tbl
end

local functions = {
	request = (request or http_request) or (http and http.request) or (syn and syn.request);
	post = checkHost('HttpPost');
}

function module:Post(url, data)
	if #getSupported(functions) == 0 then return 'not supported' end
	if functions.request then
		return functions.request({
			Url = url,
			Method = 'POST',
			Headers = { ['Content-Type'] = 'application/json' },
			Body = HTTPService:JSONEncode(data or {})
		})
	else
		return functions.post(functions.post, url, HTTPService:JSONEncode(data or {}))
	end
end

return module
