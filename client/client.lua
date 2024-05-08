RegisterNetEvent('MrNewbCustomPlates:requestPlate', function()
	local player = PlayerPedId()
	local coords = GetEntityCoords(player)
	local vehicle = GetClosestVehicleFW(coords)
	if not vehicle then return NotifyPlayer(Lang.ToFarFromVeh) end
	local currentplate = GetVehiclePlateFW(vehicle)

	CreateProgress(vehicle, currentplate)
end)

RegisterNetEvent('MrNewbCustomPlates:setplatetoclient', function(data)
	if not data.inputted1 then return NotifyPlayer(Lang.NoPlateProvided) end
	SetVehicleNumberPlateText(data.entity, data.inputted1)
	if not Config.Debug then return end
	print("DEBUG: MrNewbCustomPlates Setplatetoclient"..json.encode(data))
end)

RegisterNetEvent('MrNewbCustomPlates:plateCustomization', function(vehicle, plate)
	local data = {}
	data.title = "Custom Plate"
	data.options1 = Config.PlateLengthText
	data.vehicle = plate
	data.entity = vehicle
	data.networkId = NetworkGetNetworkIdFromEntity(vehicle)
	CreateInput(data)
	if not Config.Debug then return end
	print("DEBUG: MrNewbCustomPlates Plate Data "..json.encode(data))
end)

function CheckLetterNumber(data)
    return data:match("^%w+$") ~= nil
end

local function BadWordFilter(data)
	for _, blacklisted in pairs(Config.FilteredWords) do
		if string.find(data.inputted1:lower(), blacklisted:lower()) then
			return true
		end
	end
end

function ReturnedInput(data)
	if not data.inputted1 then return NotifyPlayer(Lang.NoInputPresent) end
	if BadWordFilter(data) then return NotifyPlayer(Lang.BadWordUsed) end
	TriggerServerEvent("MrNewbCustomPlates:server:getPlate", data)
	if not Config.Debug then return end
	print("MrNewbCustomPlates  ReturnedInput Data "..json.encode(data))
end