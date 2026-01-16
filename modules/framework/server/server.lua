function UpdateFrameworkPlate(src, newplate, oldplate)
    local framework = Bridge.Framework.GetFrameworkName()
    if framework == "qbx_core" or framework == "qb-core" then
        local result = MySQL.query.await('SELECT * FROM player_vehicles WHERE plate = ?;', { newplate })
        if result and #result > 0 and result[1].plate == newplate then return false, Bridge.Notify.SendNotify(src, locale("Checks.PlateTaken"), "error", 5000) end
        MySQL.update.await('UPDATE player_vehicles SET plate = ?, mods = REPLACE(mods, ?, ?) WHERE plate = ?', { newplate, oldplate, newplate, oldplate })
    elseif framework == "es_extended" then
        local result = MySQL.query.await('SELECT * FROM owned_vehicles WHERE plate = ?;', { newplate })
        if result and #result > 0 and result[1].plate == newplate then return false, Bridge.Notify.SendNotify(src, locale("Checks.PlateTaken"), "error", 5000) end
        MySQL.update.await('UPDATE owned_vehicles SET plate = ? WHERE plate = ?', { newplate, oldplate })
    else
        return false, Bridge.Notify.SendNotify(src, "FRAMEWORK NOT SUPPORTED", "error", 5000)
    end
    return true
end

function VerifyVehicleOwnerShip(src, plate)
    local myVehicles = Bridge.Framework.GetOwnedVehicles(src)
    for _, vehicle in pairs(myVehicles) do
        local trimmedString = TrimString(vehicle.plate)
        if trimmedString == plate then return true end
    end
    return false
end