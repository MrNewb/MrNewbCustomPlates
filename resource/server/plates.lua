local qbxVehicleQueries = {
    select = 'SELECT `plate`, `mods` AS `props` FROM `player_vehicles` WHERE `citizenid` = ? AND UPPER(TRIM(`plate`)) = ? LIMIT 1',
    taken = 'SELECT 1 FROM `player_vehicles` WHERE UPPER(TRIM(`plate`)) = ? LIMIT 1',
    update = 'UPDATE `player_vehicles` SET `plate` = ?, `mods` = ? WHERE `plate` = ? LIMIT 1',
}

local vehicleQueries = {
    qbx_core = qbxVehicleQueries,
    ['qb-core'] = qbxVehicleQueries,
    es_extended = {
        select = 'SELECT `plate`, `vehicle` AS `props` FROM `owned_vehicles` WHERE `owner` = ? AND UPPER(TRIM(`plate`)) = ? LIMIT 1',
        taken = 'SELECT 1 FROM `owned_vehicles` WHERE UPPER(TRIM(`plate`)) = ? LIMIT 1',
        update = 'UPDATE `owned_vehicles` SET `plate` = ?, `vehicle` = ? WHERE `plate` = ? LIMIT 1',
    },
}

local function setJsonPlate(encoded, newPlate)
    if type(encoded) == 'table' then
        encoded.plate = newPlate
        return json.encode(encoded)
    end
    if type(encoded) ~= 'string' or encoded == '' then return encoded end

    local ok, data = pcall(json.decode, encoded)
    if not ok or type(data) ~= 'table' then return encoded end

    data.plate = newPlate
    return json.encode(data)
end

local function updateFrameworkPlate(src, newPlate, oldPlate)
    local queries = vehicleQueries[bridge.framework.getResourceName()]
    if not queries then
        bridge.notifications.notify(src, { description = locale('Checks.FrameworkUnsupported'), type = 'error' })
        return false
    end

    local identifier = bridge.framework.getIdentifier(src)
    if not identifier then return false end

    local row = MySQL.single.await(queries.select, { identifier, oldPlate })
    if not row then
        bridge.notifications.notify(src, { description = locale('Checks.NotVehicleOwner', oldPlate), type = 'error' })
        return false
    end

    local taken = MySQL.scalar.await(queries.taken, { newPlate })
    if taken then
        bridge.notifications.notify(src, { description = locale('Checks.PlateTaken'), type = 'error' })
        return false
    end

    local affected = MySQL.update.await(queries.update, { newPlate, setJsonPlate(row.props, newPlate), row.plate })
    if not affected or affected < 1 then
        bridge.notifications.notify(src, { description = locale('Checks.PlateTaken'), type = 'error' })
        return false
    end

    return true
end

local function applyPlate(src, data)
    local ped = GetPlayerPed(src)
    if ped == 0 or not DoesEntityExist(ped) then return false end
    if GetVehiclePedIsIn(ped, false) ~= 0 then
        bridge.notifications.notify(src, { description = locale('Checks.InsideVehicle'), type = 'error' })
        return false
    end

    local valid, newPlate = ValidatePlate(data.plate)
    if not valid then
        bridge.notifications.notify(src, { description = locale(newPlate), type = 'error' })
        return false
    end

    local vehicle = NetworkGetEntityFromNetworkId(data.netId)
    if vehicle == 0 or not DoesEntityExist(vehicle) or GetEntityType(vehicle) ~= 2 or #(GetEntityCoords(ped) - GetEntityCoords(vehicle)) > 12.0 then
        bridge.notifications.notify(src, { description = locale('Checks.NoVehicle'), type = 'error' })
        return false
    end

    local oldPlate = TrimPlate(GetVehicleNumberPlateText(vehicle))
    if oldPlate == '' then return false end
    if oldPlate == newPlate then
        bridge.notifications.notify(src, { description = locale('Checks.SamePlate'), type = 'error' })
        return false
    end

    if bridge.inventory.getItemCount(src, Config.PlateItemName) <= 0 or not bridge.inventory.removeItem(src, Config.PlateItemName, 1) then
        bridge.notifications.notify(src, { description = locale('Checks.NoItem'), type = 'error' })
        return false
    end

    if not updateFrameworkPlate(src, newPlate, oldPlate) then
        bridge.inventory.addItem(src, Config.PlateItemName, 1)
        return false
    end

    SetVehicleNumberPlateText(vehicle, newPlate)
    Entity(vehicle).state:set('ox_lib:setVehicleProperties', { plate = newPlate }, true)
    bridge.vehiclekeys.remove(src, vehicle, oldPlate)
    bridge.vehiclekeys.give(src, vehicle, newPlate)

    if GetResourceState('jg-mechanic') == 'started' then
        exports['jg-mechanic']:vehiclePlateUpdated(oldPlate, newPlate)
    end

    bridge.notifications.notify(src, { description = locale('Success.PlateSet', oldPlate, newPlate), type = 'success' })
    return true
end

lib.callback.register('MrNewbCustomPlates:Callback:ApplyPlate', function(src, data)
    if type(data) ~= 'table' or type(data.plate) ~= 'string' then return false end
    if type(data.netId) ~= 'number' or data.netId < 1 or data.netId // 1 ~= data.netId then return false end
    return applyPlate(src, data)
end)

bridge.framework.registerItemUse(Config.PlateItemName, function(src)
    local ped = GetPlayerPed(src)
    if ped == 0 or not DoesEntityExist(ped) then return end
    TriggerClientEvent('MrNewbCustomPlates:Client:UsePlate', src)
end)

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    exports[bridge.name]:VersionCheck('MrNewb/patchnotes', resourceName)
end)
