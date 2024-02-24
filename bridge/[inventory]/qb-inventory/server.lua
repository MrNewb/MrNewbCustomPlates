if Config.Inventory ~= "qb" then return end

function UpdateVehicleInventoryTrunkGlove(src, oldplate, newplate)
	MySQL.update.await('UPDATE gloveboxitems SET plate = ? WHERE plate = ?', { newplate, oldplate })
	MySQL.update.await('UPDATE trunkitems SET plate = ? WHERE plate = ?', { newplate, oldplate })
end