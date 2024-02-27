if Config.framework ~= "qb" then return end

local QBCore = exports['qb-core']:GetCoreObject()

if Config.Debug then print("Framework Set To ", Config.framework) end

function GetClosestVehicleFW(coords)
	return QBCore.Functions.GetClosestVehicle(coords)
end

function GetVehiclePlateFW(vehicle)
	return QBCore.Functions.GetPlate(vehicle)
end

function FrameWorkTrim(value)
	return QBCore.Shared.Trim(value)
end