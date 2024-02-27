if Config.Notify ~= "brutal" then return end
if Config.Debug then print("Notify Set To ", Config.Notify) end

function NotifyPlayer(src, msg, status)
	return TriggerClientEvent('brutal_notify:SendAlert', src, 'Notification', msg, 3000, status)
end