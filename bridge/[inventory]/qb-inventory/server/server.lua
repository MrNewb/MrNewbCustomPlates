if GetResourceState('qb-inventory') ~= 'started' then return end
if Config.Debug then print("DEBUG ENABLED: Inventory Set To qb-inventory") end

function UpdateVehicleInventoryTrunkGlove(src, oldplate, newplate)
	MySQL.update.await('UPDATE gloveboxitems SET plate = ? WHERE plate = ?', { newplate, oldplate })
	MySQL.update.await('UPDATE trunkitems SET plate = ? WHERE plate = ?', { newplate, oldplate })
end