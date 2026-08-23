lib.locale()

-- A number plate holds eight characters in game, so a longer value would be truncated
-- on the vehicle while the database kept the full string and every later lookup missed.
local maxCharacters = math.min(Config.Settings.MaxCharacters or 8, 8)
local minCharacters = math.min(math.max(Config.Settings.MinCharacters or 1, 1), maxCharacters)

PlateLimits = { min = minCharacters, max = maxCharacters }

function TrimPlate(plate)
    if type(plate) ~= 'string' and type(plate) ~= 'number' then return '' end
    return tostring(plate):match('^%s*(.-)%s*$'):upper()
end

local function isAlphanumeric(text)
    return text:match('^%w+$') ~= nil
end

local function hasBadWord(text)
    local lowered = text:lower()
    for i = 1, #Config.FilteredWords do
        local word = Config.FilteredWords[i]
        if word and word ~= '' and lowered:find(word:lower(), 1, true) then
            return true
        end
    end
    return false
end

function ValidatePlate(text)
    if type(text) ~= 'string' then
        return false, 'Checks.NoInput'
    end

    local plate = TrimPlate(text)
    if plate == '' then
        return false, 'Checks.NoInput'
    end

    local length = #plate
    if length < minCharacters then
        return false, 'Checks.NotLongEnough'
    end
    if length > maxCharacters then
        return false, 'Checks.TooLong'
    end
    if not isAlphanumeric(plate) then
        return false, 'Checks.LetterNumber'
    end
    if hasBadWord(plate) then
        return false, 'Checks.BadWord'
    end

    return true, plate
end
