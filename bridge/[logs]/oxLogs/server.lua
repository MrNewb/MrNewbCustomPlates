if Config.Logs ~= "ox" then return end

function logs(src, msg)
	return lib.logger(src, GetCurrentResourceName(), msg)
end
