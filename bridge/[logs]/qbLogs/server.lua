if Config.Logs ~= "qb" then return end

function logs(src, msg)
	return TriggerEvent('qb-log:server:CreateLog', GetCurrentResourceName(), GetCurrentResourceName(), 'red', msg)
end