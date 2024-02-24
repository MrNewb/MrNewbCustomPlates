RegisterNetEvent('MrNewbCustomPlates:requestPlate', function()
	local player = PlayerPedId()
	local coords = GetEntityCoords(player)
	local vehicle = GetClosestVehicle(coords)
	if not vehicle then return NotifyPlayer("You are not close enough to a vehicle", "error") end
	local currentplate = GetVehiclePlate(vehicle)

	CreateProgress(vehicle, currentplate)
end)

RegisterNetEvent('MrNewbCustomPlates:setplatetoclient', function(data)
	if not data.inputted1 then return NotifyPlayer("No Plate Provided", "error") end
	SetVehicleNumberPlateText(data.entity, data.inputted1)
end)

RegisterNetEvent('MrNewbCustomPlates:plateCustomization', function(vehicle, plate)
	local data = {}
	data.title = Config.Title
	data.options1 = Config.PlateLengthText
	data.vehicle = plate
	data.entity = vehicle
	CreateInput(data)
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
	if not data.inputted1 then return NotifyPlayer("You haven't submitted any data", "error") end
	if BadWordFilter(data) then return NotifyPlayer("You are attempting to use a word on the word filter.", "error") end
	TriggerServerEvent("MrNewbCustomPlates:getPlate", data)
end