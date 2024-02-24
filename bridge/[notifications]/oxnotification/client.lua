if Config.Notify ~= "ox" then return end

function NotifyPlayer(msg, status)
	return lib.notify({ title = 'Notification', description = msg, duration = 10000, type = status})
end