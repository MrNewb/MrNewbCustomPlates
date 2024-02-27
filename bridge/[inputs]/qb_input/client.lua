if Config.Input ~= "qb" then return end

if Config.Debug then print("Input Set To ", Config.Input) end

function CreateInput(data)
	local qbdata = exports['qb-input']:ShowInput({
		header = data.title,
		submitText = "Confirm",
		inputs = {
			{
				type = 'text', 
				isRequired = true, 
				text = data.options1, 
				name = 'inputted1',
				default = Config.Placeholder,
			},
		}
	})
	local inputMenuData = qbdata and qbdata.inputted1 or nil

	if not inputMenuData then return NotifyPlayer("You havent filled out the plate info", "error") end
	local fixcasing = string.upper(qbdata.inputted1)
	local finalize = FrameWorkTrim(fixcasing)
	qbdata.inputted1 = finalize
	data.inputted1 = qbdata.inputted1
	local chars = string.len(qbdata.inputted1)
	if not (chars >= Config.MinNumbers and chars <= Config.MaxNumbers) then
		return NotifyPlayer("You must use at least "..Config.MinNumbers.." characters and less than "..Config.MaxNumbers, "error")
	end
	if CheckLetterNumber(qbdata.inputted1) then return ReturnedInput(data) end
	NotifyPlayer("You can only use numbers and letters", "error")
end