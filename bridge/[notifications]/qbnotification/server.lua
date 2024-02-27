if Config.Notify ~= "qb" then return end
if Config.Debug then print("Notify Set To ", Config.Notify) end

function NotifyPlayer(src, msg, status)
	return TriggerClientEvent('QBCore:Notify', src, msg, status)
end