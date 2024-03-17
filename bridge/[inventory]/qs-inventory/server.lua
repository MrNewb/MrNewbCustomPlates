if Config.Inventory ~= "qs" then return end

if Config.Debug then print("Inventory Set To ", Config.Inventory) end

function UpdateVehicleInventoryTrunkGlove(src, oldplate, newplate)
	MySQL.update.await('UPDATE inventory_glovebox SET plate = ? WHERE plate = ?', { newplate, oldplate })
	MySQL.update.await('UPDATE inventory_trunk SET plate = ? WHERE plate = ?', { newplate, oldplate })
end