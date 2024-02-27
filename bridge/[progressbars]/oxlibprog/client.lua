if Config.Progress ~= "ox" then return end
if Config.Debug then print("Progress Set To ", Config.Progress) end

function CreateProgress(vehicle, currentplate)
	if lib.progressBar({
			duration = 2000, 
			label = 'Changing Plate', 
			useWhileDead = false, 
			canCancel = true,
			disable = {move = true, car = true , move = true, sprint = true},
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
	end
end