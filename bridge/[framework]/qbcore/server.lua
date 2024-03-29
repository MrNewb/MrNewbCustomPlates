if Config.framework ~= "qb" then return end

local QBCore = exports['qb-core']:GetCoreObject()

if Config.Debug then print("Framework Set To ", Config.framework) end

function VerifyPlateAvailable(plate, cb)
    MySQL.query('SELECT * FROM player_vehicles WHERE plate = ?;', { plate },
    function(result)
        if Config.Debug then print("VerifyPlateAvailable ",json.encode(result)) end
        cb(result and #result > 0 and result[1].plate == plate)
    end)
end

function VerifyPlateOwnership(source, plate, cb)
	local Player = QBCore.Functions.GetPlayer(source)
	if not Player then return end
	local citizenid = Player.PlayerData.citizenid
	MySQL.query('SELECT * FROM player_vehicles WHERE citizenid = ? AND plate = ?;', { citizenid, plate },
	function(result)
        if Config.Debug then print("VerifyPlateOwnership ",json.encode(result)) end
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
    if Config.Debug then print("Removing item ",item) end
    Player.Functions.RemoveItem(item, 1)
end

QBCore.Functions.CreateUseableItem(Config.CustomPlateName, function(source, item)
	local src = source
    if Config.Debug then print("requestPlate ID# ",src) end
	TriggerClientEvent("MrNewbCustomPlates:requestPlate", src)
end)