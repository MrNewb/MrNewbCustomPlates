if Config.Notify ~= "sd" then return end
if Config.Debug then print("Notify Set To ", Config.Notify) end

function NotifyPlayer(src, msg, status)
	return TriggerClientEvent('sd-notify:Notify', src, "Notification", msg, 3000, status, 'top-right', false, false)
end