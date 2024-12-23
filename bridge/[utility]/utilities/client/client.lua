function NotifyPlayer(message)
	if Config.Notify == "ox" then
		print(json.encode(message))
		return lib.notify({ title = message.title or "Blank Title", description = message.msg or "Blank MSG", duration = message.timeout or 5000, type = message.status or "error"})
	elseif Config.Notify == "mythic" then
		return exports['mythic_notify']:SendAlert(message.status, message.msg)
	elseif Config.Notify == "old_mythic" then
		return exports['mythic_notify']:DoHudText(message.status, message.msg)
	elseif Config.Notify == "pNotify" then
		return exports.pNotify:SendNotification({text = message.msg, type = message.status, timeout = message.timeout})
	elseif Config.Notify == "brutal" then
		return exports['brutal_notify']:SendAlert(Lang.NotificationTitle, message.msg, message.timeout, message.status)
	elseif Config.Notify == "okok" then
		return exports['okokNotify']:Alert(Lang.NotificationTitle, message.msg, message.timeout, message.status, false)
	elseif Config.Notify == "sd" then
		return exports['sd-notify']:Notify(Lang.NotificationTitle, message.msg, message.timeout, message.status, message.position, false, false)
	elseif Config.Notify == "wasabi" then
		return exports.wasabi_notify:notify(Lang.status, message.msg, message.timeout, message.status)
	elseif Config.Notify == "qb" then
		return TriggerEvent('QBCore:Notify', message.msg, message.status, message.timeout)
	elseif Config.Notify == "custom" then
		-- add your custom notification here
	end
end

RegisterNetEvent('MrNewbCustomPlates:Client:NotifyPlayer', function(message)
	NotifyPlayer(message)
end)

function CreateProgress(vehicle, currentplate)
	if Config.Progress == "qb" then
		exports['progressbar']:Progress({
			name = 'Plate changer',
			duration = 2000,
			label = Lang.ProgressLabel,
			useWhileDead = false,
			canCancel = true,
			controlDisables = {
				disableMovement = true,
				disableCarMovement = true,
				disableMouse = false,
				disableCombat = true,
			},
			animation = {
				animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
				anim = "machinic_loop_mechandplayer",
				flags = 49,
			},
		}, function(cancelled)
			if not cancelled then
				TriggerServerEvent("MrNewbCustomPlates:server:VerifyOwnership", vehicle, currentplate)
			else
				NotifyPlayer(Lang.PlateChangeCanceled)
			end
		end)
	elseif Config.Progress == "ox" then
		if lib.progressBar({
			duration = 2000,
			label = Lang.ProgressLabel,
			useWhileDead = false,
			canCancel = true,
			disable = {move = true, car = true, sprint = true},
			anim = {
				dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
				clip = 'machinic_loop_mechandplayer',
				flag = 49,
			},
			prop = {
				model = `p_num_plate_04`,
				pos = vec3(0.03, 0.03, 0.02),
				rot = vec3(0.0, 0.0, -1.5)
			},
		}) then
			TriggerServerEvent("MrNewbCustomPlates:server:VerifyOwnership", vehicle, currentplate)
		else
			NotifyPlayer(Lang.PlateChangeCanceled)
		end
	elseif Config.Progress == "custom" then
		-- add your custom progress bar here
	end
end

function CreateInput(data)
	if Config.Input == "ox" then
		local title = data.title
		local description = data.options1
		local input = lib.inputDialog(tostring(title), {{type = 'input', label = tostring(title), description = tostring(description), placeholder = 'IAMNEWB1', icon = Config.Icon,required = true, min = Config.MinNumbers, max = Config.MaxNumbers}})
		if not input then return NotifyPlayer(Lang.InputMenuDumb) end
		local fixcasing = string.upper(input[1])
		local finalize = FrameWorkTrim(fixcasing)
		data.inputted1 = finalize
		if CheckLetterNumber(data.inputted1) then return ReturnedInput(data) end
		NotifyPlayer(Lang.NumberLetter)
	elseif Config.Input == "qb" then
		local qbdata = exports['qb-input']:ShowInput({
			header = data.title,
			submitText = "Confirm",
			inputs = {
				{ type = 'text', isRequired = true, text = data.options1, name = 'inputted1', default = 'IAMNEWB1', },
			}
		})
		local inputMenuData = qbdata and qbdata.inputted1 or nil
		if not inputMenuData then return NotifyPlayer(Lang.InputMenuDumb) end
		local fixcasing = string.upper(qbdata.inputted1)
		local finalize = FrameWorkTrim(fixcasing)
		qbdata.inputted1 = finalize
		data.inputted1 = qbdata.inputted1
		local chars = string.len(qbdata.inputted1)
		if not (chars >= Config.MinNumbers and chars <= Config.MaxNumbers) then
			return NotifyPlayer(Lang.MinMaxChars)
		end
		if CheckLetterNumber(qbdata.inputted1) then return ReturnedInput(data) end
		NotifyPlayer(Lang.NumberLetter)
	elseif Config.Input == "custom" then
		-- add your custom input here
	end
end

RegisterNetEvent('MrNewbCustomPlates:QuasarKeyEventClient', function(data)
	local entity = data.id
	local newplate = data.newplatenum
	local model = GetDisplayNameFromVehicleModel(GetEntityModel(entity))
	exports['qs-vehiclekeys']:GiveKeys(newplate, model, true)
end)

RegisterNetEvent('MrNewbCustomPlates:MrNewbKeyEventClient', function(plateString)
	exports.MrNewbVehicleKeys:RemoveKeysByPlate(plateString)
end)