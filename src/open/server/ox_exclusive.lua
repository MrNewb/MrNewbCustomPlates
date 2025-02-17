-- if you change Config.PlateItemName then change it on line 11
if not Config.EnableOxExclusive then return end
local hookId = exports.ox_inventory:registerHook('swapItems', function(payload)
    if payload.fromType == "player" and payload.toType == "player" then
        return false
    else
        return true
    end
end, {
    itemFilter = {
        customizableplate = true,
    },
})