function VerifyVehicleOwnerShip(src, plate)
    local myVehicles = Bridge.Framework.GetOwnedVehicles(src)
    for _, vehicle in pairs(myVehicles) do
        local trimmedString = TrimString(vehicle.plate)
        if trimmedString == plate then return true end
    end
    return false
end

function UpdateFrameworkPlate(src, newplate, oldplate)
    local framework = Bridge.Framework.GetFrameworkName()
    if framework == "qbx_core" or framework == "qb-core" then
        local result = MySQL.query.await('SELECT * FROM player_vehicles WHERE plate = ?;', { newplate })
        if result and #result > 0 and result[1].plate == newplate then return false, NotifyPlayer(src, locale("Checks.PlateTaken"), "error", 5000) end
        MySQL.update.await('UPDATE player_vehicles SET plate = ?, mods = REPLACE(mods, ?, ?) WHERE plate = ?', { newplate, oldplate, newplate, oldplate })
    elseif framework == "es_extended" then
        local result = MySQL.query.await('SELECT * FROM owned_vehicles WHERE plate = ?;', { newplate })
        if result and #result > 0 and result[1].plate == newplate then return false, NotifyPlayer(src, locale("Checks.PlateTaken"), "error", 5000) end
        MySQL.update.await('UPDATE owned_vehicles SET plate = ? WHERE plate = ?', { newplate, oldplate })
    else
        return false, NotifyPlayer(src, "FRAMEWORK NOT SUPPORTED", "error", 5000)
    end
    return true
end

function RunPlateChecks(src, data, slot)
    local netId = data.netId
    local newPlate = data.plate
    local vehicle = NetworkGetEntityFromNetworkId(netId)
    local plate = GetVehicleNumberPlateText(vehicle)
    local trimmedString = TrimString(plate)
    newPlate = string.upper(newPlate)
    if not RunBadWordFilter(newPlate) then return end
    local owner = VerifyVehicleOwnerShip(src, trimmedString)
    if not owner then return NotifyPlayer(src, locale("Checks.NotVehicleOwner", trimmedString), "error", 5000) end
    if not UpdateFrameworkPlate(src, newPlate, trimmedString) then return end
    UpdateInventoryPlate(trimmedString, newPlate)
    RemoveItem(src, Config.PlateItemName, 1, slot, nil)
    SetVehicleNumberPlateText(vehicle, newPlate)
    NotifyPlayer(src, locale("Success.PlateSet", trimmedString, newPlate), "success", 5000)
    Wait(250)
    TriggerClientEvent("MrNewbCustomPlates:Client:UpdatePlate", src, newPlate, trimmedString, netId)
    TriggerClientEvent("MrNewbCustomPlates:Client:UpdatePlateText", -1, newPlate, netId)
    local vehicleState = Entity(vehicle).state
    vehicleState:set('plate', newPlate, true)
end