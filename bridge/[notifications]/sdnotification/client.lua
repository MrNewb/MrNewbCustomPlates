if Config.Notify ~= "sd" then return end
if Config.Debug then print("Notify Set To ", Config.Notify) end

function NotifyPlayer(msg, status)
	return exports['sd-notify']:Notify("Notification", msg, 3000, status, 'top-right', false, false)
end