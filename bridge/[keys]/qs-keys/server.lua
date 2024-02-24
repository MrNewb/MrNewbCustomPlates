if Config.Keys ~= "qs" then return end

function GiveKeys(src, entityid, oldplate, newplate)
	local data = {}
	data.id = entityid
	data.oldplatenum = oldplate
	data.newplatenum = newplate
	TriggerClientEvent("MrNewbCustomPlates:QuasarKeyEventClient", src, data)
end