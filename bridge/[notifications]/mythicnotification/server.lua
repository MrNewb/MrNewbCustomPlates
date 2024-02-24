if Config.Notify ~= "mythic" then return end

function NotifyPlayer(src, msg, status)
	return TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'Inform ', text = msg })
end