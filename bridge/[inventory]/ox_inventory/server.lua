if Config.Inventory ~= "ox" then return end
if Config.Debug then print("Inventory Set To ", Config.Inventory) end
local ox_inventory = exports.ox_inventory

function UpdateVehicleInventoryTrunkGlove(src, oldplate, newplate)
	ox_inventory:UpdateVehicle(oldplate, newplate)
end