function NotifyPlayer(message, _type, time)
    Bridge.Notify.SendNotify(message, _type, time)
end

lib.callback.register('MrNewbCustomPlates:Callback:SetPlate', function()
    return GetPlayerVehicleData()
end)

function CreateInputMenu()
    local data = {{
            type = 'input',
            label = locale("PlateCustomize.Title"),
            description = locale("PlateCustomize.Description"),
            placeholder = 'MrNewb',
            required = true,
            min = Config.Settings.MinCharachters,
            max = Config.Settings.Maxcharacters,
        },
    }
    local inputData = Bridge.Input.Open(locale("PlateCustomize.Title"), data, false, locale("PlateCustomize.Submit"))
    return VerifyInputChecks(inputData)
end

function VerifyInputChecks(inputData)
    if not inputData then return false, NotifyPlayer(locale("Checks.NoInput"), "error", 5000) end
    local renamedData = inputData[1]
    if not renamedData then return false, NotifyPlayer(locale("Checks.NoInput"), "error", 5000) end
    if string.len(renamedData) < Config.Settings.MinCharachters then return false, NotifyPlayer(locale("Checks.NotLongEnough"), "error", 5000) end
    if string.len(renamedData) > Config.Settings.Maxcharacters then return false, NotifyPlayer(locale("Checks.ToLong"), "error", 5000) end
    if not CheckLetterNumber(renamedData, "ALPHANUMERICAL") then return false, NotifyPlayer(locale("Checks.LetterNumber"), "error", 5000) end
    if not RunBadWordFilter(renamedData) then return false, NotifyPlayer(locale("Checks.BadWord"), "error", 5000) end
    return renamedData
end

function BeginProgressBar()
    if not Config.ProgressBarEnabled then return end
    Bridge.Progressbar.StartProgressBar(5000, locale("Progressbar.ProgressText"), false, false, { move = false, sprint = false, car = false, combat = false, }, {
        dict = 'amb@prop_human_parking_meter@female@base',
        clip = 'base_female',
        flag = 49,
    }, function()
        --print("Coulda Done Something Here,Buttttttttttttttt I didn't")
    end, function()
        --print("This shouldnt happen, ever but I left it here")
    end)
end

function GetPlayerVehicleData()
    if cache.vehicle then return false, NotifyPlayer(locale("Checks.InsideVehicle"), "error", 5000) end
    local ped = cache.ped
    local coords = GetEntityCoords(ped)
    local vehicle, vehicleCoords = lib.getClosestVehicle(coords, 10, false)
    if not vehicle or not vehicleCoords then return false, NotifyPlayer(locale("Checks.NoVehicle"), "error", 5000) end
    if not NetworkGetEntityIsNetworked(vehicle) then return false, NotifyPlayer(locale("Checks.MustBeNetworked"), "error", 5000) end
    --local netId = NetworkGetNetworkIdFromEntity(vehicle)
    TaskTurnPedToFaceCoord(ped, vehicleCoords.x, vehicleCoords.y, vehicleCoords.z, 1.0)
    Wait(500)
    BeginProgressBar()
    ClearPedTasks(ped)
    local inputStatus = CreateInputMenu()
    if not inputStatus then return false end
    return {netId = NetworkGetNetworkIdFromEntity(vehicle), plate = inputStatus}
end

RegisterNetEvent("MrNewbCustomPlates:Client:UpdatePlate", function(newplate, oldplate, netid)
    if not NetworkDoesNetworkIdExist(netid) then return end
    local vehicle = NetworkGetEntityFromNetworkId(netid)
    Bridge.VehicleKey.RemoveKeys(vehicle, oldplate)
    Wait(500)
    Bridge.VehicleKey.GiveKeys(vehicle, newplate)
end)