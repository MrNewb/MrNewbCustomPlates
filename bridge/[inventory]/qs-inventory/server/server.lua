if GetResourceState('qs-inventory') ~= 'started' then return end
if Config.Debug then print("DEBUG ENABLED: Inventory Set To qs-inventory") end

function UpdateVehicleInventoryTrunkGlove(src, oldplate, newplate)
	MySQL.update.await('UPDATE inventory_glovebox SET plate = ? WHERE plate = ?', { newplate, oldplate })
	MySQL.update.await('UPDATE inventory_trunk SET plate = ? WHERE plate = ?', { newplate, oldplate })
end