if Config.Keys ~= "t1ger" then return end
if Config.Debug then print("Keys Set To ", Config.Keys) end

function RemoveOldKeys(src, entityid, oldplate, newplate)
	exports['t1ger_keys']:UpdateKeysToDatabase(oldplate, false)
end

function GiveKeys(src, entityid, oldplate, newplate)
	exports['t1ger_keys']:UpdateKeysToDatabase(newplate, true)
end