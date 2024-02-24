if Config.Notify ~= "qb" then return end

function NotifyPlayer(src, msg, status)
	return TriggerClientEvent('QBCore:Notify', src, msg, status)
end