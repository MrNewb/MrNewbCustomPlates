RegisterNetEvent("MrNewbCustomPlates:getPlate", function(data)
    local src = source
    local oldplate = data.vehicle
    local newplate = data.inputted1
    local entityid = data.entity

    if not newplate then return NotifyPlayer(src, "No Plate Provided", "error") end

    if Config.debug then print("Player id# "..src.." has changed a plate from ".."Old Plate "..oldplate.." New Plate "..newplate) end

    NotifyPlayer(src, "The license plate has been changed from "..oldplate.." to "..newplate.." ", "success")

    VerifyPlateOwnership(src, oldplate, function(plateOwner)
        if not plateOwner then return NotifyPlayer(src, "You Dont Own This Vehicle.", "error") end

        VerifyPlateAvailable(newplate, function(plateExists)
            if plateExists then return NotifyPlayer(src, "This plate already exists.", "error") end

            --if you use t1ger keys or mk uncomment the line below
            --if Config.Keys == "t1ger" then RemoveKeys(src, entityid, oldplate, newplate) end
            UpdateFrameworkPlate(newplate, oldplate)
            UpdateVehicleInventoryTrunkGlove(src, oldplate, newplate)
            TriggerClientEvent("MrNewbCustomPlates:setplatetoclient", -1, data)
            if Config.Logs then logs(src, " | Has changed plate from "..oldplate.." to "..newplate) end
            RemoveItemFromInventory(src)

            if Config.Keys then GiveKeys(src, entityid, oldplate, newplate) end
        end)
    end)
end)

RegisterNetEvent("MrNewbCustomPlates:server:VerifyOwnership", function(vehicle, plate)
    local src = source

    VerifyPlateOwnership(src, plate, function(plateOwner)
        if not plateOwner then return NotifyPlayer(src, "You Dont Own This Vehicle.", "error") end

        TriggerClientEvent("MrNewbCustomPlates:plateCustomization", src, vehicle, plate)
    end)
end)