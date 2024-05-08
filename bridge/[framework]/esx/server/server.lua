if GetResourceState('es_extended') ~= 'started' then return end
if Config.Debug then print("DEBUG esx Detected") end

local ESX = exports["es_extended"]:getSharedObject()

function GetPlayerIdentifierFW(src)
    local xPlayer = ESX.GetPlayerFromId(src)
    if Config.Debug then print("xPlayer Identifier ",json.encode(xPlayer.identifier)) end
    return xPlayer.identifier
end

function VerifyPlateAvailable(plate, cb)
    MySQL.query('SELECT * FROM owned_vehicles WHERE plate = ?;', { plate },
    function(result)
        if Config.Debug then print("DEBUG: VerifyPlateAvailable "..json.encode(result)) end
        cb(result and #result > 0 and result[1].plate == plate)
    end)
end

function VerifyPlateOwnership(source, plate, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local owner = xPlayer.identifier
	MySQL.query('SELECT * FROM owned_vehicles WHERE owner = ? AND plate = ?;', { owner, plate },
	function(result)
        if Config.Debug then print("DEBUG: VerifyPlateOwnership "..json.encode(result)) end
		cb(result and #result > 0 and result[1].plate == plate)
	end)
end

function UpdateFrameworkPlate(newplate, oldplate)
    MySQL.update.await('UPDATE owned_vehicles SET plate = ?, vehicle = REPLACE(vehicle, ?, ?) WHERE plate = ?', { newplate, oldplate, newplate, oldplate })
end

function RemoveItemFromInventory(source)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    xPlayer.removeInventoryItem(Config.CustomPlateName, 1)
    if not Config.Debug then return end
    print("MrNewbCustomPlates Removing item ",Config.CustomPlateName)
end

ESX.RegisterUsableItem(Config.CustomPlateName, function(source)
	local src = source
	TriggerClientEvent("MrNewbCustomPlates:requestPlate", src)
    if not Config.Debug then return end
    print("MrNewbCustomPlates RequestPlate ID# ",src)
end)