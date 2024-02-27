if Config.Notify ~= "ok" then return end
if Config.Debug then print("Notify Set To ", Config.Notify) end

function NotifyPlayer(msg, status)
	return exports['okokNotify']:Alert('Notification', msg, 10000, status, false)
end