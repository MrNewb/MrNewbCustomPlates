if GetResourceState('es_extended') ~= 'started' then return end
if Config.Debug then print("DEBUG: esx Detected") end

local ESX = exports["es_extended"]:getSharedObject()

function GetClosestVehicleFW(coords)
	return ESX.Game.GetClosestVehicle(coords)
end

function GetVehiclePlateFW(vehicle)
	return ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))
end

function FrameWorkTrim(value)
	return ESX.Math.Trim(value)
end