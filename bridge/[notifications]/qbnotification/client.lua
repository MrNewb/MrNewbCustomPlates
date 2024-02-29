if Config.Notify ~= "qb" then return end
if Config.Debug then print("Notify Set To ", Config.Notify) end

local QBCore = exports['qb-core']:GetCoreObject()

function NotifyPlayer(msg, status)
	return QBCore.Functions.Notify(msg, status)
end