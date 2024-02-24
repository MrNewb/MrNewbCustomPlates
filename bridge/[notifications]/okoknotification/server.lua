if Config.Notify ~= "ok" then return end

function NotifyPlayer(src, msg, status)
	return TriggerClientEvent('okokNotify:Alert', src, 'Notification', msg, 3000, status, false)
end