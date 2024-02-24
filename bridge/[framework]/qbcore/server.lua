if Config.framework ~= "qb" then return end

local QBCore = exports['qb-core']:GetCoreObject()

function VerifyPlateAvailable(plate, cb)
    MySQL.query('SELECT * FROM player_vehicles WHERE plate = ?;', { plate },
    function(result)
        cb(result and #result > 0 and result[1].plate == plate)
    end)
end

function VerifyPlateOwnership(source, plate, cb)
	local Player = QBCore.Functions.GetPlayer(source)
	if not Player then return end
	local citizenid = Player.PlayerData.citizenid
	MySQL.query('SELECT * FROM player_vehicles WHERE citizenid = ? AND plate = ?;', { citizenid, plate },
	function(result)
		cb(result and #result > 0 and result[1].plate == plate)
	end)
end

function UpdateFrameworkPlate(newplate, oldplate)
    MySQL.update.await('UPDATE player_vehicles SET plate = ?, mods = REPLACE(mods, ?, ?) WHERE plate = ?', { newplate, oldplate, newplate, oldplate })
end

function RemoveItemFromInventory(source)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local item = Config.CustomPlateName
    Player.Functions.RemoveItem(item, 1)
end

QBCore.Functions.CreateUseableItem(Config.CustomPlateName, function(source, item)
	local src = source
	TriggerClientEvent("MrNewbCustomPlates:requestPlate", src)
end)