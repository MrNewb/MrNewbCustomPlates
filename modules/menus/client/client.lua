function CreateInputMenu()
    local data = {
        {
            type = 'input',
            label = locale("PlateCustomize.Title"),
            description = locale("PlateCustomize.Description"),
            placeholder = 'MrNewb',
            required = true,
            min = Config.Settings.MinCharacters,
            max = Config.Settings.MaxCharacters,
        },
    }
    local inputData = Bridge.Input.Open(locale("PlateCustomize.Title"), data, false, locale("PlateCustomize.Submit"))
    return VerifyInputChecks(inputData)
end

function VerifyInputChecks(inputData)
    if not inputData or not inputData[1] then return false, Bridge.Notify.SendNotify(locale("Checks.NoInput"), "error", 5000) end

    local renamedData = inputData[1]
    local length = string.len(renamedData)
    if length < Config.Settings.MinCharacters or length > Config.Settings.MaxCharacters then
        local message = length < Config.Settings.MinCharacters and "Checks.NotLongEnough" or "Checks.TooLong"
        return false, Bridge.Notify.SendNotify(locale(message), "error", 5000)
    end

    if not CheckLetterNumber(renamedData, "ALPHANUMERICAL") then return false, Bridge.Notify.SendNotify(locale("Checks.LetterNumber"), "error", 5000) end
    if not RunBadWordFilter(renamedData) then return false, Bridge.Notify.SendNotify(locale("Checks.BadWord"), "error", 5000) end
    return renamedData
end