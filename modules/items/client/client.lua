Bridge.Callback.Register('MrNewbCustomPlates:Callback:SetPlate', function()
    return GetPlayerVehicleData()
end)

function GetPlayerVehicleData()
    local ped = PlayerPedId()
    local inVehicle = IsPedSittingInAnyVehicle(ped)
    if inVehicle then return false, Bridge.Notify.SendNotify(locale("Checks.InsideVehicle"), "error", 5000) end
    local vehicle, vehCoords = GetClosestVehicle(GetEntityCoords(ped), 10, false)
    if not vehicle or not vehCoords then return false, Bridge.Notify.SendNotify(locale("Checks.NoVehicle"), "error", 5000) end
    if not NetworkGetEntityIsNetworked(vehicle) then return false, Bridge.Notify.SendNotify(locale("Checks.MustBeNetworked"), "error", 5000) end
    TaskTurnPedToFaceCoord(ped, vehCoords.x, vehCoords.y, vehCoords.z, 1.0)
    Wait(500)
    BeginProgressBar()
    ClearPedTasks(ped)
    local inputStatus = CreateInputMenu()
    if not inputStatus then return false end

    return {netId = NetworkGetNetworkIdFromEntity(vehicle), plate = inputStatus }
end