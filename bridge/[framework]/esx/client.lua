if Config.framework ~= "esx" then return end

local ESX = exports["es_extended"]:getSharedObject()

if Config.debug then print(Config.framework) end

function GetClosestVehicle(coords)
	return ESX.Game.GetClosestVehicle(coords)
end

function GetVehiclePlate(vehicle)
	return ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))
end

function FrameWorkTrim(value)
	return ESX.Math.Trim(value)
end