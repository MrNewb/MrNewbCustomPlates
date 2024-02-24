if Config.Notify ~= "sd" then return end

function NotifyPlayer(src, msg, status)
	return TriggerClientEvent('sd-notify:Notify', src, "Notification", msg, 3000, status, 'top-right', false, false)
end