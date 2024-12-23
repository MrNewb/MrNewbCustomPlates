lib.versionCheck('MrNewb/MrNewbCustomPlates')

RegisterNetEvent("MrNewbCustomPlates:server:getPlate", function(data)
    local src = source
    local oldPlate = data.vehicle
    local newPlate = data.inputted1
    local entityId = data.entity
    local netId = data.networkId

    if not newPlate then return NotifyPlayer(src, Lang.NoPlateProvided) end

    VerifyPlateOwnership(src, oldPlate, function(plateOwner)
        if not plateOwner then return NotifyPlayer(src, Lang.FailedNotOwned) end

        VerifyPlateAvailable(newPlate, function(plateExists)
            if plateExists then return NotifyPlayer(src, Lang.FailedTaken) end

            RemoveOldKeys(src, entityId, oldPlate, newPlate)
            UpdateFrameworkPlate(newPlate, oldPlate)
            UpdateVehicleInventoryTrunkGlove(src, oldPlate, newPlate)
            TriggerClientEvent("MrNewbCustomPlates:setplatetoclient", -1, data)
            NotifyPlayer(src, Lang.Changed)
            RemoveItemFromInventory(src)

            GiveKeys(src, entityId, netId, oldPlate, newPlate)
            if Config.Logs then Logs(src, " | Has changed plate from "..oldPlate.." to "..newPlate) end
            if not Config.Debug then return end
            print("Player id# "..src.." has changed a plate from ".."Old Plate "..oldPlate.." New Plate "..newPlate)
        end)
    end)
end)

RegisterNetEvent("MrNewbCustomPlates:server:VerifyOwnership", function(vehicle, plate)
    local src = source

    VerifyPlateOwnership(src, plate, function(plateOwner)
        if not plateOwner then return NotifyPlayer(src, Lang.FailedNotOwned) end

        TriggerClientEvent("MrNewbCustomPlates:plateCustomization", src, vehicle, plate)
    end)
end)