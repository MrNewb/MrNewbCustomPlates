if Config.Inventory ~= "ox" then return end
--print(Config.Inventory," inventory Loaded")
local ox_inventory = exports.ox_inventory

function UpdateVehicleInventoryTrunkGlove(src, oldplate, newplate)
	ox_inventory:UpdateVehicle(oldplate, newplate)
end