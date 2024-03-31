if Config.Keys ~= "newb" then return end
if Config.Debug then print("Keys Set To ", Config.Keys) end

function GiveKeys(src, entityid, oldplate, newplate)
	local netId = NetworkGetNetworkIdFromEntity(entityid)
	local hasKey = exports.MrNewbVehicleKeys:HasKey(src, netId)
	if hasKey then
		exports.MrNewbVehicleKeys:RemoveKeys(src, netId)
	end
	exports.MrNewbVehicleKeys:GiveKeys(src, netId)
end