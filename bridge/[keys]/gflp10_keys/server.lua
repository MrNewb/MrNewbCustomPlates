if Config.Keys ~= "gflp10" then return end

function GiveKeys(src, entityid, oldplate, newplate)
	exports['gflp10-carkeys']:AddCarkey(src, newplate)
end