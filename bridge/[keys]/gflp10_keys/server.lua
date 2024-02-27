if Config.Keys ~= "gflp10" then return end
if Config.Debug then print("Keys Set To ", Config.Keys) end

function GiveKeys(src, entityid, oldplate, newplate)
	exports['gflp10-carkeys']:AddCarkey(src, newplate)
end