if Config.framework ~= "esx" then return end

local ESX = exports["es_extended"]:getSharedObject()

if Config.Debug then print(Config.framework) end

function VerifyPlateAvailable(plate, cb)
    MySQL.query('SELECT * FROM owned_vehicles WHERE plate = ?;', { plate },
    function(result)
        cb(result and #result > 0 and result[1].plate == plate)
    end)
end

function VerifyPlateOwnership(source, plate, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local owner = xPlayer.identifier
	MySQL.query('SELECT * FROM owned_vehicles WHERE owner = ? AND plate = ?;', { owner, plate },
	function(result)
		cb(result and #result > 0 and result[1].plate == plate)
	end)
end

function UpdateFrameworkPlate(newplate, oldplate)
    MySQL.update.await('UPDATE owned_vehicles SET plate = ?, vehicle = REPLACE(vehicle, ?, ?) WHERE plate = ?', { newplate, oldplate, newplate, oldplate })
end

function RemoveItemFromInventory(source)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local item = Config.CustomPlateName
    xPlayer.removeInventoryItem(item, 1)
end

ESX.RegisterUsableItem(Config.CustomPlateName, function(source)
	local src = source
	TriggerClientEvent("MrNewbCustomPlates:requestPlate", src)
end)