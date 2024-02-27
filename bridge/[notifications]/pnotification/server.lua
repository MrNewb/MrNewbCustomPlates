if Config.Notify ~= "pNotify" then return end
if Config.Debug then print("Notify Set To ", Config.Notify) end

function NotifyPlayer(src, msg, status)
	return TriggerClientEvent("pNotify:SendNotification", src, {text =  msg, type = "success", queue = "Plates", timeout = 5000, layout = "bottomCenter"})
end