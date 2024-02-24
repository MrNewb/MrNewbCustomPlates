if Config.Keys ~= "renewed" then return end

function GiveKeys(src, entityid, oldplate, newplate)
	if exports['Renewed-Vehiclekeys']:hasKey(src, oldplate) then
		exports['Renewed-Vehiclekeys']:removeKey(src, oldplate)
	end
	exports['Renewed-Vehiclekeys']:addKey(src, newplate)
end