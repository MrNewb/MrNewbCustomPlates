if Config.Notify ~= "brutal" then return end

function NotifyPlayer(msg, status)
	return exports['brutal_notify']:SendAlert('Notification', msg, 3000, status)
end