if Config.Keys ~= "jaksam" then return end

function RemoveOldKeys(src, entityid, oldplate, newplate)
	exports["vehicles_keys"]:removeKeysFromPlayerId(src, oldplate)
	exports["vehicles_keys"]:refreshPlayerOwnedVehicles(src)
end

function GiveKeys(src, entityid, oldplate, newplate)
	exports["vehicles_keys"]:giveVehicleKeysToPlayerId(src, newplate, "owned")
	exports["vehicles_keys"]:refreshPlayerOwnedVehicles(src)
end