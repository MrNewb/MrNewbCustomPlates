if GetResourceState('ox_inventory') ~= 'started' then return end
if Config.Debug then print("DEBUG ENABLED: Inventory Set To ox_inventory") end
local ox_inventory = exports.ox_inventory

function UpdateVehicleInventoryTrunkGlove(src, oldplate, newplate)
	ox_inventory:UpdateVehicle(oldplate, newplate)
end