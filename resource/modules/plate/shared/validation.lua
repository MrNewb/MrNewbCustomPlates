local maxCharacters = math.min(Config.Settings.MaxCharacters or 8, 8)
local minCharacters = math.min(math.max(Config.Settings.MinCharacters or 1, 1), maxCharacters)

PlateLimits = { min = minCharacters, max = maxCharacters }

function TrimPlate(plate)
    return plate:match('^%s*(.-)%s*$'):upper()
end

local function hasBadWord(text)
    local lowered = text:lower()
    for i = 1, #Config.FilteredWords do
        local word = Config.FilteredWords[i]
        if word ~= '' and lowered:find(word:lower(), 1, true) then
            return true
        end
    end
    return false
end

-- Returns the cleaned plate, or nil and the locale key of the reason it was rejected
function ValidatePlate(text)
    local plate = TrimPlate(text)
    if plate == '' then return nil, 'Checks.NoInput' end
    if #plate < minCharacters then return nil, 'Checks.NotLongEnough' end
    if #plate > maxCharacters then return nil, 'Checks.TooLong' end
    if not plate:match('^%w+$') then return nil, 'Checks.LetterNumber' end
    if hasBadWord(plate) then return nil, 'Checks.BadWord' end

    return plate
end
