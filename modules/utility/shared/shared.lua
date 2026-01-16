function TrimString(plate)
    local stringIfy = tostring(plate)
    return stringIfy:match("^%s*(.-)%s*$"):upper()
end

function CheckLetterNumber(data, _type)
    if _type == "ALPHANUMERICAL" then return data:match("^%w+$") ~= nil end
end

function RunBadWordFilter(data)
	for _, blacklisted in pairs(Config.FilteredWords) do
		if string.find(data:lower(), blacklisted:lower()) then return false end
	end
	return data
end

function GetClosestVehicle(coords, distance, includePlayerVeh)
    local vehicleEntity, vehicleCoords, _vehicleNetID = Bridge.Utility.GetClosestVehicle(coords, distance, includePlayerVeh)
    return vehicleEntity, vehicleCoords
end

if IsDuplicityVersion() then return end

RegisterNetEvent("MrNewbCustomPlates:Client:UpdatePlate", function(newplate, oldplate, netid)
    if source ~= 65535 then return end
    if not NetworkDoesNetworkIdExist(netid) then return end
    local vehicle = NetworkGetEntityFromNetworkId(netid)
    SetVehicleNumberPlateText(vehicle, newplate)
    Bridge.VehicleKey.RemoveKeys(vehicle, oldplate)
    Wait(500)
    Bridge.VehicleKey.GiveKeys(vehicle, newplate)
end)

RegisterNetEvent("MrNewbCustomPlates:Client:UpdatePlateText", function(newplate, netid)
    if source ~= 65535 then return end
    if not NetworkDoesNetworkIdExist(netid) then return end
    local vehicle = NetworkGetEntityFromNetworkId(netid)
    if not DoesEntityExist(vehicle) then return end
    SetVehicleNumberPlateText(vehicle, newplate)
end)