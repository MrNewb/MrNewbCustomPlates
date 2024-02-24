if Config.Notify ~= "qb" then return end

function NotifyPlayer(msg, status)
	return QBCore.Functions.Notify(msg, status, 10000)
end