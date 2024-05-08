if GetResourceState('qb-core') ~= 'started' then return end
if Config.Debug then print("DEBUG: QBCore Detected") end

local QBCore = exports['qb-core']:GetCoreObject()

function GetPlayerIdentifierFW(src)
    local Player = QBCore.Functions.GetPlayer(src)
    return Player.PlayerData.citizenid
end

function VerifyPlateAvailable(plate, cb)
    MySQL.query('SELECT * FROM player_vehicles WHERE plate = ?;', { plate },
    function(result)
        if Config.Debug then print("DEBUG: VerifyPlateAvailable "..json.encode(result)) end
        cb(result and #result > 0 and result[1].plate == plate)
    end)
end

function VerifyPlateOwnership(source, plate, cb)
	local Player = QBCore.Functions.GetPlayer(source)
	if not Player then return end
	local citizenid = Player.PlayerData.citizenid
	MySQL.query('SELECT * FROM player_vehicles WHERE citizenid = ? AND plate = ?;', { citizenid, plate },
	function(result)
        if Config.Debug then print("DEBUG: VerifyPlateOwnership "..json.encode(result)) end
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
    if not Config.Debug then return end
    print("MrNewbCustomPlates Removing item ",Config.CustomPlateName)
end

QBCore.Functions.CreateUseableItem(Config.CustomPlateName, function(source, item)
	local src = source
	TriggerClientEvent("MrNewbCustomPlates:requestPlate", src)
    if not Config.Debug then return end
    print("MrNewbCustomPlates RequestPlate ID# ",src)
end)