if Config.Keys ~= "qb" then return end
if Config.Debug then print("Keys Set To ", Config.Keys) end

function GiveKeys(src, entityid, oldplate, newplate)
	TriggerClientEvent("vehiclekeys:client:SetOwner", src, newplate)
end