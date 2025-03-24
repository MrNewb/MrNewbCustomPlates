function NotifyPlayer(src, message, _type, time)
    Bridge.Notify.SendNotify(src, message, _type, time)
end

function VerifyVehicleOwnerShip(src, plate)
    local myVehicles = Bridge.Framework.GetOwnedVehicles(src)
    for _, vehicle in pairs(myVehicles) do
        local trimmedString = TrimString(vehicle.plate)
        if trimmedString == plate then
            return true
        end
    end
    return false
end

function UpdateFrameworkPlate(framework, src, newplate, oldplate)
    if framework == "qb-core" then
        local result = MySQL.query.await('SELECT * FROM player_vehicles WHERE plate = ?;', { newplate })
        if result and #result > 0 and result[1].plate == newplate then
            return false, NotifyPlayer(src, locale("Checks.PlateTaken"), "error", 5000)
        end
        MySQL.update.await('UPDATE player_vehicles SET plate = ?, mods = REPLACE(mods, ?, ?) WHERE plate = ?', { newplate, oldplate, newplate, oldplate })
    elseif framework == "qbx_core" then
        local result = MySQL.query.await('SELECT * FROM player_vehicles WHERE plate = ?;', { newplate })
        if result and #result > 0 and result[1].plate == newplate then
            return false, NotifyPlayer(src, locale("Checks.PlateTaken"), "error", 5000)
        end
        MySQL.update.await('UPDATE player_vehicles SET plate = ?, mods = REPLACE(mods, ?, ?) WHERE plate = ?', { newplate, oldplate, newplate, oldplate })
    elseif framework == "es_extended" then
        local result = MySQL.query.await('SELECT * FROM owned_vehicles WHERE plate = ?;', { newplate })
        if result and #result > 0 and result[1].plate == newplate then
            return false, NotifyPlayer(src, locale("Checks.PlateTaken"), "error", 5000)
        end
        MySQL.update.await('UPDATE owned_vehicles SET plate = ? WHERE plate = ?', { newplate, oldplate })
    end
    return true
end

function UpdateSqlTableForVehicle(src, oldPlate, newPlate)
    if Bridge.Framework.GetFrameworkName() == "qb-core" then
        return UpdateFrameworkPlate("qb-core", src, newPlate, oldPlate)
    elseif Bridge.Framework.GetFrameworkName() == "qbx_core" then
        return UpdateFrameworkPlate("qb-core", src, newPlate, oldPlate)
    elseif Bridge.Framework.GetFrameworkName() == "es_extended" then
        return UpdateFrameworkPlate("es_extended", src, newPlate, oldPlate)
    end
    return false, NotifyPlayer(src, "FRAMEWORK NOT SUPPORTED", "error", 5000)
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
    if not owner then return NotifyPlayer(src, locale("Checks.NotOwner"), "error", 5000) end
    if not UpdateSqlTableForVehicle(src, trimmedString, newPlate) then return end
    Bridge.Inventory.UpdatePlate(trimmedString, newPlate)
    Bridge.Inventory.RemoveItem(src, Config.PlateItemName, 1, slot, nil)
    SetVehicleNumberPlateText(vehicle, newPlate)
    NotifyPlayer(src, locale("Success.PlateSet"), "success", 5000)
    Wait(250)
    TriggerClientEvent("MrNewbCustomPlates:Client:UpdatePlate", src, newPlate, trimmedString, netId)
    TriggerClientEvent("MrNewbCustomPlates:Client:UpdatePlateText", -1, netId)
end

Bridge.Framework.RegisterUsableItem(Config.PlateItemName, function(src, itemData)
    local data = lib.callback.await("MrNewbCustomPlates:Callback:SetPlate", src)
    if not data then return end
    if not data.plate or not data.netId then return end
    RunPlateChecks(src, data, itemData.slot)
end)

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    Bridge.Version.VersionChecker("MrNewb/MrNewbCustomPlates")
end)