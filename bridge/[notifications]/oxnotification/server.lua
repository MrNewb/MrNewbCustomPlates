if Config.Notify ~= "ox" then return end

function NotifyPlayer(src, msg, status)
	return TriggerClientEvent('ox_lib:notify', src, { title = "Notification", description = msg, duration = 10000, type = status })
end