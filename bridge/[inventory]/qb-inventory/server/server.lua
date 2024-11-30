if GetResourceState('qb-inventory') ~= 'started' then return end
if Config.Debug then print("DEBUG ENABLED: Inventory Set To qb-inventory") end
local version = Config.OverrideQBInventoryV2

function UpdateVehicleInventoryTrunkGlove(src, oldplate, newplate)
	if version then
		MySQL.update.await('UPDATE inventories SET identifier = CONCAT("glovebox-", ?), items = items WHERE identifier = CONCAT("glovebox-", ?)', { newplate, oldplate })
		MySQL.update.await('UPDATE inventories SET identifier = CONCAT("trunk-", ?), items = items WHERE identifier = CONCAT("trunk-", ?)', { newplate, oldplate })
		if Config.Debug then print("Updated Plate from "..oldplate.." to "..newplate) end
		-- I dont want to study this inventory to understand how to update the items. This should prevent the qb-inventory v2
	else
		MySQL.update.await('UPDATE inventory_glovebox SET plate = ? WHERE plate = ?', { newplate, oldplate })
		MySQL.update.await('UPDATE inventory_trunk SET plate = ? WHERE plate = ?', { newplate, oldplate })
		if Config.Debug then print("Updated Plate from "..oldplate.." to "..newplate) end
	end
    if GetResourceState('jg-mechanic') ~= 'started' then return end
    exports["jg-mechanic"]:vehiclePlateUpdated(oldplate, newplate)
	if Config.Debug then print("Updated Plate in jg-mechanic from "..oldplate.." to "..newplate) end
end