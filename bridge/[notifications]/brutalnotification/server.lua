if Config.Notify ~= "brutal" then return end

function NotifyPlayer(src, msg, status)
	return TriggerClientEvent('brutal_notify:SendAlert', src, 'Notification', msg, 3000, status)
end