if Config.framework ~= "esx" then return end

local ESX = exports["es_extended"]:getSharedObject()

if Config.debug then print(Config.framework) end

function GetClosestVehicleFW(coords)
	return ESX.Game.GetClosestVehicle(coords)
end

function GetVehiclePlateFW(vehicle)
	return ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))
end

function FrameWorkTrim(value)
	return ESX.Math.Trim(value)
end