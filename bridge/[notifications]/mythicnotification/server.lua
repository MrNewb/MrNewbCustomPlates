if Config.Notify ~= "mythic" then return end
if Config.Debug then print("Notify Set To ", Config.Notify) end

function NotifyPlayer(src, msg, status)
	return TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'Inform ', text = msg })
end