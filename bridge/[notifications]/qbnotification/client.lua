if Config.Notify ~= "qb" then return end
if Config.Debug then print("Notify Set To ", Config.Notify) end

function NotifyPlayer(msg, status)
	return exports['qb-notify']:Notify(msg, "primary", 10000)
end