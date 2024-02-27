if Config.Notify ~= "ok" then return end
if Config.Debug then print("Notify Set To ", Config.Notify) end

function NotifyPlayer(src, msg, status)
	return TriggerClientEvent('okokNotify:Alert', src, 'Notification', msg, 3000, status, false)
end