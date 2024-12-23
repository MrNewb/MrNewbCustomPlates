RegisterServerEvent('MrNewbCustomPlates:server:log', function(data)
	local src = source
	local identifier = GetPlayerIdentifierFW(src)
	local msg = "Player: " .. identifier .. " | ID#" .. src .. " | ".. data
	Logs(src, msg)
end)

function Logs(src, msg)
	if not Config.Logs then return end
	if Config.Logs == "qb" then
		return TriggerEvent('qb-log:server:CreateLog', GetCurrentResourceName(), GetCurrentResourceName(), 'red', msg)
	elseif Config.Logs == "ox" then
		return lib.logger(src, GetCurrentResourceName(), msg)
	end
end

function NotifyPlayer(src, msg)
	return TriggerClientEvent('MrNewbCustomPlates:Client:NotifyPlayer', src, msg)
end

function GiveKeys(src, entityid, netId, oldplate, newplate)
	if Config.Keys == "mrnewb" then
		return exports.MrNewbVehicleKeys:GiveKeys(src, netId)
	elseif Config.Keys == "gflp10" then
		return exports['gflp10-carkeys']:AddCarkey(src, newplate)
	elseif Config.Keys == "jaksam" then
		exports["vehicles_keys"]:giveVehicleKeysToPlayerId(src, newplate, "owned")
		exports["vehicles_keys"]:refreshPlayerOwnedVehicles(src)
	elseif Config.Keys == "mk" then
		exports["mk_vehiclekeys"]:AddKey(entityid, src)
		local usingFob = exports["mk_vehiclekeys"]:UsingKeyfobs()
		if not usingFob then return end
		exports["mk_vehiclekeys"]:UpdatePlate(oldplate, newplate)
	elseif Config.Keys == "mono" then
		local action = 'add'
		return exports.mono_garage:InventoryKeys(action, { plate = newplate, player = src})
	elseif Config.Keys == "okok" then
		SetVehicleDoorsLocked(entityid, 0)
		TriggerClientEvent("okokGarage:GiveKeys", newplate, src)
	elseif Config.Keys == "qb" then
		TriggerClientEvent("vehiclekeys:client:SetOwner", src, newplate)
	elseif Config.Keys == "qs" then
		TriggerClientEvent("MrNewbCustomPlates:QuasarKeyEventClient", src, {id = entityid, oldplatenum = oldplate, newplatenum = newplate})
	elseif Config.Keys == "renewed" then
		if exports['Renewed-Vehiclekeys']:hasKey(src, oldplate) then
			exports['Renewed-Vehiclekeys']:removeKey(src, oldplate)
		end
		exports['Renewed-Vehiclekeys']:addKey(src, newplate)
	elseif Config.Keys == "t1ger" then
		exports['t1ger_keys']:UpdateKeysToDatabase(newplate, true)
	end
end

function RemoveOldKeys(src, entityid, oldplate, newplate)
	if Config.Keys == "mrnewb" then
		TriggerClientEvent("MrNewbCustomPlates:MrNewbKeyEventClient", src, oldplate)
	elseif Config.Keys == "jaksam" then
		exports["vehicles_keys"]:removeKeysFromPlayerId(src, oldplate)
		exports["vehicles_keys"]:refreshPlayerOwnedVehicles(src)
	elseif Config.Keys == "mk" then
		return exports["mk_vehiclekeys"]:RemoveKey(entityid, src)
	elseif Config.Keys == "mono" then
		local action = 'revome' --  'add' or 'revome'
		return exports.mono_garage:InventoryKeys(action, { plate = oldplate, player = src})
	elseif Config.Keys == "okok" then
		SetVehicleDoorsLocked(entityid, 0)
		TriggerClientEvent('okokGarage:removeKeys', src, oldplate)
	elseif Config.Keys == "t1ger" then
		exports['t1ger_keys']:UpdateKeysToDatabase(oldplate, false)
	end
end
