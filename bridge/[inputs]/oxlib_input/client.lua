if Config.Input ~= "ox" then return end

if Config.Debug then print("Input Set To ", Config.Input) end

function CreateInput(data)
	local title = data.title
	local description = data.options1
	local input = lib.inputDialog(tostring(title), {{type = 'input', label = tostring(title), description = tostring(description), placeholder = Config.Placeholder, icon = Config.Icon,required = true, min = Config.MinNumbers, max = Config.MaxNumbers}})
	if not input then return NotifyPlayer("You havent filled out the plate info", "error") end
	local fixcasing = string.upper(input[1])
	local finalize = FrameWorkTrim(fixcasing)
	data.inputted1 = finalize
	if CheckLetterNumber(data.inputted1) then return ReturnedInput(data) end
	NotifyPlayer("You can only use numbers and letters", "error")
end