if Config.Notify ~= "ok" then return end

function NotifyPlayer(msg, status)
	return exports['okokNotify']:Alert('Notification', msg, 10000, status, false)
end