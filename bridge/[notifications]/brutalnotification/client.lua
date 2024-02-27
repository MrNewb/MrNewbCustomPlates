if Config.Notify ~= "brutal" then return end
if Config.Debug then print("Notify Set To ", Config.Notify) end

function NotifyPlayer(msg, status)
	return exports['brutal_notify']:SendAlert('Notification', msg, 3000, status)
end