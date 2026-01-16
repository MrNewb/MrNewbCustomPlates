Bridge.Framework.RegisterUsableItem(Config.PlateItemName, function(src, itemData)
    local data = Bridge.Callback.Trigger("MrNewbCustomPlates:Callback:SetPlate", src)
    if not data or not data.plate or not data.netId then return end
    local success, vehicle, netId, trimmedString, newPlate, slot = RunPlateChecks(src, data, itemData.slot)
    if not success then return end
    RemovePlateItems(src, vehicle, netId, trimmedString, newPlate, slot)
end)

function RunPlateChecks(src, data, slot)
    local netId = data.netId
    local newPlate = data.plate
    local vehicle = NetworkGetEntityFromNetworkId(netId)
    local plate = GetVehicleNumberPlateText(vehicle)
    local trimmedString = TrimString(plate)
    newPlate = string.upper(newPlate)
    if not RunBadWordFilter(newPlate) then return false end
    local owner = VerifyVehicleOwnerShip(src, trimmedString)
    if not owner then return false, Bridge.Notify.SendNotify(src, locale("Checks.NotVehicleOwner", trimmedString), "error", 5000) end
    if not UpdateFrameworkPlate(src, newPlate, trimmedString) then return false end
    return true, vehicle, netId, trimmedString, newPlate, slot
end

function RemovePlateItems(src, vehicle, netId, trimmedString, newPlate, slot)
    Bridge.Inventory.UpdatePlate(trimmedString, newPlate)
    Bridge.Inventory.RemoveItem(src, Config.PlateItemName, 1, slot, nil)
    SetVehicleNumberPlateText(vehicle, newPlate)
    Bridge.Notify.SendNotify(src, locale("Success.PlateSet", trimmedString, newPlate), "success", 5000)
    Wait(250)
    TriggerClientEvent("MrNewbCustomPlates:Client:UpdatePlate", src, newPlate, trimmedString, netId)
    TriggerClientEvent("MrNewbCustomPlates:Client:UpdatePlateText", -1, newPlate, netId)
    local vehicleState = Entity(vehicle).state
    vehicleState:set('plate', newPlate, true)
end