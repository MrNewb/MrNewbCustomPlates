local pendingInput
local pendingAcknowledge
local applyingPlate = false

local function finishPlateInput(plate)
    if not pendingInput then return end

    local input = pendingInput
    pendingInput = nil
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'close' })
    input:resolve(plate or false)
end

-- Opens the overlay and waits for the player to submit (the plate) or cancel (nil)
local function openPlateCustomizer(labels)
    finishPlateInput()

    pendingInput = promise.new()
    pendingAcknowledge = promise.new()
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'open',
        minLength = PlateLimits.min,
        maxLength = PlateLimits.max,
        locale = GetConvar('ox:locale', 'en'),
        labels = labels,
    })

    local acknowledge = pendingAcknowledge
    SetTimeout(2000, function() acknowledge:resolve(false) end)
    if not Citizen.Await(acknowledge) then
        finishPlateInput()
        bridge.notifications.notify({ description = locale('Checks.UiUnavailable'), type = 'error' })
        return
    end

    return Citizen.Await(pendingInput) or nil
end

RegisterNUICallback('plateReady', function(_, cb)
    if pendingAcknowledge then pendingAcknowledge:resolve(true) end
    cb(1)
end)

RegisterNUICallback('plateSubmit', function(data, cb)
    if not pendingInput then
        cb({ ok = false })
        return
    end

    local plate = data and data.plate
    if type(plate) ~= 'string' or plate == '' then
        cb({ ok = false, error = locale('Checks.NoInput') })
        return
    end

    local valid, reason = ValidatePlate(plate)
    if not valid then
        cb({ ok = false, error = locale(reason) })
        return
    end

    finishPlateInput(valid)
    cb({ ok = true })
end)

RegisterNUICallback('plateCancel', function(_, cb)
    finishPlateInput()
    cb(1)
end)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName ~= cache.resource then return end
    finishPlateInput()
end)

local function getPlateTargetVehicle(ped)
    if cache.vehicle then
        bridge.notifications.notify({ description = locale('Checks.InsideVehicle'), type = 'error' })
        return
    end

    local vehicle = lib.getClosestVehicle(GetEntityCoords(ped), Config.MaxInteractDistance, false)
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

local function getVehicleModelName(vehicle)
    local model = GetEntityModel(vehicle)
    local label = GetLabelText(GetDisplayNameFromVehicleModel(model))
    if label ~= 'NULL' then return label end
    return GetDisplayNameFromVehicleModel(model)
end

local function askForPlate(vehicle)
    local length = PlateLimits.min == PlateLimits.max and PlateLimits.min or ('%s-%s'):format(PlateLimits.min, PlateLimits.max)

    return openPlateCustomizer({
        title = locale('PlateCustomize.Title'),
        description = locale('PlateCustomize.VehicleDescription', getVehicleModelName(vehicle), length),
        placeholder = TrimPlate(GetVehicleNumberPlateText(vehicle)),
        submit = locale('PlateCustomize.Submit'),
        submitting = locale('Progressbar.ProgressText') .. '...',
        cancel = locale('PlateCustomize.Cancel'),
        lettersOnly = locale('Checks.LetterNumber'),
        inputLabel = locale('PlateCustomize.InputLabel'),
        minLengthHint = locale('PlateCustomize.MinLengthHint', PlateLimits.min),
        invalidPlate = locale('PlateCustomize.Invalid'),
    })
end

local function changePlate()
    local ped = cache.ped
    local vehicle = getPlateTargetVehicle(ped)
    if not vehicle then return end

    local plate = askForPlate(vehicle)
    if not plate then return end

    if not DoesEntityExist(vehicle) or #(GetEntityCoords(ped) - GetEntityCoords(vehicle)) > Config.MaxInteractDistance then
        bridge.notifications.notify({ description = locale('Checks.NoVehicle'), type = 'error' })
        return
    end

    walkToVehicleRear(ped, vehicle)
    local completed = playPlateChangeProgress()
    ClearPedTasks(ped)
    if not completed then
        bridge.notifications.notify({ description = locale('Checks.Canceled'), type = 'error' })
        return
    end

    lib.callback.await('MrNewbCustomPlates:applyPlate', false, {
        netId = NetworkGetNetworkIdFromEntity(vehicle),
        plate = plate,
    })
end

RegisterNetEvent('MrNewbCustomPlates:client:usedPlate', function()
    if source ~= 65535 then return end
    if applyingPlate then return end

    applyingPlate = true
    changePlate()
    applyingPlate = false
end)
