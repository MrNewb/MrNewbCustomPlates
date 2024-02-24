if Config.Notify ~= "sd" then return end

function NotifyPlayer(msg, status)
	return exports['sd-notify']:Notify("Notification", msg, 3000, status, 'top-right', false, false)
end