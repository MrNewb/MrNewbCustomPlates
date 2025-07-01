Bridge = exports.community_bridge:Bridge()

RegisterNetEvent('Bridge:Refresh', function(moduleName, wrappedModule)
    Bridge[moduleName] = wrappedModule
end)

function locale(message)
    return Bridge.Language.Locale(message)
end

function DoDebugPrint(message)
	if not Config.Utility.Debug then return end
	return Bridge.Prints.Debug(message)
end

function GenerateRandomString()
    return Bridge.Ids.RandomLower(nil, 8)
end

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

if not IsDuplicityVersion() then
    function NotifyPlayer(message, _type, time)
        Bridge.Notify.SendNotify(message, _type, time)
    end

    function GetClosestVehicle(coords, distance, includePlayerVeh)
        local vehicleEntity, vehicleCoords, _vehicleNetID = Bridge.Utility.GetClosestVehicle(coords, distance, includePlayerVeh)
        return vehicleEntity, vehicleCoords
    end
end

if not IsDuplicityVersion() then return end

function RemoveItem(src, itemName, amount, slot, metadata)
    Bridge.Inventory.RemoveItem(src, itemName, amount, slot, metadata)
end

function UpdateInventoryPlate(oldPlate, newPlate)
    Bridge.Inventory.UpdatePlate(oldPlate, newPlate)
end

function NotifyPlayer(src, message, _type, time)
    Bridge.Notify.SendNotify(src, message, _type, time)
end

Bridge.Framework.RegisterUsableItem(Config.PlateItemName, function(src, itemData)
    local data = Bridge.Callback.Trigger("MrNewbCustomPlates:Callback:SetPlate", src)
    if not data or not data.plate or not data.netId then return end
    RunPlateChecks(src, data, itemData.slot)
end)

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    Bridge.Version.VersionChecker("MrNewb/MrNewbCustomPlates")
end)