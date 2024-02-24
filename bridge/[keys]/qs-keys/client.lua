if Config.Keys ~= "qs" then return end

RegisterNetEvent('MrNewbCustomPlates:QuasarKeyEventClient', function(data)
	local entity = data.id
	local newplate = data.newplatenum
	local model = GetDisplayNameFromVehicleModel(GetEntityModel(entity))
	exports['qs-vehiclekeys']:GiveKeys(newplate, model, true)
end)