if Config.Logs ~= "ox" then return end
if Config.Debug then print("Logs Set To ", Config.Logs) end

function logs(src, msg)
	return lib.logger(src, GetCurrentResourceName(), msg)
end
