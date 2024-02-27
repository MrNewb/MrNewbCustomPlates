if Config.Keys ~= "qs" then return end
if Config.Debug then print("Keys Set To ", Config.Keys) end

RegisterNetEvent('MrNewbCustomPlates:QuasarKeyEventClient', function(data)
	local entity = data.id
	local newplate = data.newplatenum
	local model = GetDisplayNameFromVehicleModel(GetEntityModel(entity))
	exports['qs-vehiclekeys']:GiveKeys(newplate, model, true)
end)