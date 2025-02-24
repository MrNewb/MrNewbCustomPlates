Bridge = exports.community_bridge:Bridge()

RegisterNetEvent('Bridge:Refresh', function(moduleName, wrappedModule)
    Bridge[moduleName] = wrappedModule
end)

function locale(message)
    return Bridge.Language.Locale(message)
end

function DoDebugPrint(message)
	if not Config.Utility.Debug then return end
	return Bridge.Prints.Debug(message)
end

function GenerateRandomString()
    return Bridge.Ids.RandomLower(nil, 8)
end

function TrimString(plate)
    local stringIfy = tostring(plate)
    return stringIfy:match("^%s*(.-)%s*$"):upper()
end

function CheckLetterNumber(data, _type)
    if _type == "ALPHANUMERICAL" then return data:match("^%w+$") ~= nil end
end

function RunBadWordFilter(data)
	for _, blacklisted in pairs(Config.FilteredWords) do
		if string.find(data:lower(), blacklisted:lower()) then
			return false
		end
	end
	return data
end