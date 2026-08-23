local plateInputResult
local waitingForPlateInput = false
local uiAcknowledged = false

local function finishPlateInput(result)
    if not waitingForPlateInput then return end

    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'close' })
    plateInputResult = result
    waitingForPlateInput = false
end

local function openPlateCustomizer(labels)
    finishPlateInput(nil)

    plateInputResult = nil
    waitingForPlateInput = true
    uiAcknowledged = false
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'open',
        minLength = PlateLimits.min,
        maxLength = PlateLimits.max,
        locale = GetConvar('ox:locale', 'en'),
        labels = labels,
    })

    local acknowledgeDeadline = GetGameTimer() + 2000
    while waitingForPlateInput and not uiAcknowledged and GetGameTimer() < acknowledgeDeadline do
        Wait(50)
    end

    if waitingForPlateInput and not uiAcknowledged then
        finishPlateInput(nil)
        bridge.notifications.notify({ description = locale('Checks.UiUnavailable'), type = 'error' })
        return
    end

    while waitingForPlateInput do
        Wait(100)
    end

    return plateInputResult
end

RegisterNUICallback('plateReady', function(_, cb)
    uiAcknowledged = true
    cb(1)
end)

RegisterNUICallback('plateSubmit', function(data, cb)
    if not waitingForPlateInput then
        cb({ ok = false })
        return
    end

    local plate = data and data.plate
    if type(plate) ~= 'string' or plate == '' then
        cb({ ok = false, error = locale('Checks.NoInput') })
        return
    end

    local success, result = ValidatePlate(plate)
    if not success then
        cb({ ok = false, error = locale(result) })
        return
    end

    finishPlateInput(result)
    cb({ ok = true })
end)

RegisterNUICallback('plateCancel', function(_, cb)
    finishPlateInput(nil)
    cb(1)
end)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    finishPlateInput(nil)
end)

local function getPlateTargetVehicle(ped)
    if cache.vehicle then
        bridge.notifications.notify({ description = locale('Checks.InsideVehicle'), type = 'error' })
        return
    end

    local vehicle = lib.getClosestVehicle(GetEntityCoords(ped), 10.0, false)
    if not vehicle or vehicle == 0 then
        bridge.notifications.notify({ description = locale('Checks.NoVehicle'), type = 'error' })
        return
    end

    if not NetworkGetEntityIsNetworked(vehicle) then
        bridge.notifications.notify({ description = locale('Checks.MustBeNetworked'), type = 'error' })
        return
    end

    return vehicle
end

local function walkToVehicleRear(ped, vehicle)
    local modelMin = GetModelDimensions(GetEntityModel(vehicle))
    local rearCoords = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, modelMin.y - 0.45, 0.0)
    TaskGoStraightToCoord(ped, rearCoords.x, rearCoords.y, rearCoords.z, 1.0, 3000, GetEntityHeading(vehicle), 0.1)

    local moveTimeout = GetGameTimer() + 3000
    while #(GetEntityCoords(ped) - rearCoords) > 1.2 and GetGameTimer() < moveTimeout do
        Wait(50)
    end

    TaskTurnPedToFaceEntity(ped, vehicle, 750)
    Wait(500)
end

local function playPlateChangeProgress()
    if not Config.ProgressBarEnabled then return true end

    return bridge.progressbar.openprogressbar({
        duration = 5000,
        label = locale('Progressbar.ProgressText'),
        disable = { move = true, car = true, combat = true },
        anim = {
            dict = 'mini@repair',
            clip = 'fixing_a_ped',
            flag = 1,
        },
        canCancel = true,
    }) ~= false
end

local applyingPlate = false

RegisterNetEvent('MrNewbCustomPlates:Client:UsePlate', function()
    if source ~= 65535 then return end
    if applyingPlate then return end
    applyingPlate = true

    local ped = cache.ped
    local vehicle = getPlateTargetVehicle(ped)
    if not vehicle then
        applyingPlate = false
        return
    end

    local plate = openPlateCustomizer({
        title = locale('PlateCustomize.Title'),
        description = locale('PlateCustomize.Description'),
        submit = locale('PlateCustomize.Submit'),
        cancel = locale('PlateCustomize.Cancel'),
        inputLabel = locale('PlateCustomize.InputLabel'),
        minLengthHint = locale('PlateCustomize.MinLengthHint', PlateLimits.min),
        invalidPlate = locale('PlateCustomize.Invalid'),
    })
    if not plate then
        applyingPlate = false
        return
    end

    if not DoesEntityExist(vehicle) or #(GetEntityCoords(ped) - GetEntityCoords(vehicle)) > 10.0 then
        bridge.notifications.notify({ description = locale('Checks.NoVehicle'), type = 'error' })
        applyingPlate = false
        return
    end

    walkToVehicleRear(ped, vehicle)
    local completed = playPlateChangeProgress()
    ClearPedTasks(ped)
    if not completed then
        applyingPlate = false
        return
    end

    -- ox_lib's second argument is a debounce, not a timeout, so it stays false and the
    -- server guarantees a response instead.
    lib.callback.await('MrNewbCustomPlates:Callback:ApplyPlate', false, {
        netId = NetworkGetNetworkIdFromEntity(vehicle),
        plate = plate,
    })
    applyingPlate = false
end)
