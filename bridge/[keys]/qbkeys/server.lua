if Config.Keys ~= "qb" then return end

function GiveKeys(src, entityid, oldplate, newplate)
	TriggerClientEvent("vehiclekeys:client:SetOwner", src, newplate)
end