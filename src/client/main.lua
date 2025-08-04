Bridge.Callback.Register('MrNewbCustomPlates:Callback:SetPlate', function()
    return GetPlayerVehicleData()
end)

function CreateInputMenu()
    local data = {
        {
            type = 'input',
            label = locale("PlateCustomize.Title"),
            description = locale("PlateCustomize.Description"),
            placeholder = 'MrNewb',
            required = true,
            min = Config.Settings.MinCharacters,
            max = Config.Settings.MaxCharacters,
        },
    }
    local inputData = OpenInput(locale("PlateCustomize.Title"), data, false, locale("PlateCustomize.Submit"))
    return VerifyInputChecks(inputData)
end

function VerifyInputChecks(inputData)
    if not inputData or not inputData[1] then return false, NotifyPlayer(locale("Checks.NoInput"), "error", 5000) end

    local renamedData = inputData[1]
    local length = string.len(renamedData)
    if length < Config.Settings.MinCharacters or length > Config.Settings.MaxCharacters then
        local message = length < Config.Settings.MinCharacters and "Checks.NotLongEnough" or "Checks.TooLong"
        return false, NotifyPlayer(locale(message), "error", 5000)
    end

    if not CheckLetterNumber(renamedData, "ALPHANUMERICAL") then return false, NotifyPlayer(locale("Checks.LetterNumber"), "error", 5000) end
    if not RunBadWordFilter(renamedData) then return false, NotifyPlayer(locale("Checks.BadWord"), "error", 5000) end
    return renamedData
end

function BeginProgressBar()
    if not Config.ProgressBarEnabled then return end
    local success = Bridge.ProgressBar.Open({
        duration = 5000,
        label = locale("Progressbar.ProgressText"),
        disable = { move = true, combat = true },
        anim = { dict = "amb@prop_human_parking_meter@female@base", clip = "base_female", },
        flag = 49,
        canCancel = true,
    })
    return success
end

function GetPlayerVehicleData()
    local ped = PlayerPedId()
    local inVehicle = IsPedSittingInAnyVehicle(ped)
    if inVehicle then return false, NotifyPlayer(locale("Checks.InsideVehicle"), "error", 5000) end
    local vehicle, vehCoords = GetClosestVehicle(GetEntityCoords(ped), 10, false)
    if not vehicle or not vehCoords then return false, NotifyPlayer(locale("Checks.NoVehicle"), "error", 5000) end
    if not NetworkGetEntityIsNetworked(vehicle) then return false, NotifyPlayer(locale("Checks.MustBeNetworked"), "error", 5000) end
    TaskTurnPedToFaceCoord(ped, vehCoords.x, vehCoords.y, vehCoords.z, 1.0)
    Wait(500)
    BeginProgressBar()
    ClearPedTasks(ped)
    local inputStatus = CreateInputMenu()
    if not inputStatus then return false end

    return {netId = NetworkGetNetworkIdFromEntity(vehicle), plate = inputStatus }
end

RegisterNetEvent("MrNewbCustomPlates:Client:UpdatePlate", function(newplate, oldplate, netid)
    if not NetworkDoesNetworkIdExist(netid) then return end
    local vehicle = NetworkGetEntityFromNetworkId(netid)
    SetVehicleNumberPlateText(vehicle, newplate)
    Bridge.VehicleKey.RemoveKeys(vehicle, oldplate)
    Wait(500)
    Bridge.VehicleKey.GiveKeys(vehicle, newplate)
end)

RegisterNetEvent("MrNewbCustomPlates:Client:UpdatePlateText", function(newplate, netid)
    if not NetworkDoesNetworkIdExist(netid) then return end
    local vehicle = NetworkGetEntityFromNetworkId(netid)
    if not DoesEntityExist(vehicle) then return end
    SetVehicleNumberPlateText(vehicle, newplate)
end)