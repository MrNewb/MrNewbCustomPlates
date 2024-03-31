if Config.Keys ~= "ok" then return end
if Config.Debug then print("Keys Set To ", Config.Keys) end

-- submitted by Arkosee / https://github.com/Arkosee
function RemoveOldKeys(src, entityid, oldplate, newplate)
	TriggerClientEvent('okokGarage:removeKeys', src, oldplate)
	--print('Removed keys for '.. oldplate)
end

function GiveKeys(src, entityid, oldplate, newplate)
	TriggerClientEvent("okokGarage:GiveKeys", newplate, src)
	--print('Gave keys for '.. newplate)
end