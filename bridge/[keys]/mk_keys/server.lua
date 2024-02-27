if Config.Keys ~= "mk" then return end
if Config.Debug then print("Keys Set To ", Config.Keys) end

function RemoveOldKeys(src, entityid, oldplate, newplate)
	exports["mk_vehiclekeys"]:RemoveKey(entityid, src)
end

function GiveKeys(src, entityid, oldplate, newplate)
	if exports["mk_vehiclekeys"]:UsingKeyfobs() then
		exports["mk_vehiclekeys"]:UpdatePlate(oldPlate, newplate)
	end
	exports["mk_vehiclekeys"]:AddKey(entityid, source)
end