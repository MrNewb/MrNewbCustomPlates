if Config.Progress ~= "qb" then return end

function CreateProgress(vehicle, currentplate)
    exports['progressbar']:Progress({
        name = 'Plate changer',
        duration = 2000,
        label = 'Changing Plate',
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
            NotifyPlayer("You Have Canceled The Plate Change", "error")
        end
    end)
end