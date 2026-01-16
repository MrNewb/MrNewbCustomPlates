if not Config.EnableOxExclusive then return end
if GetResourceState('ox_inventory') ~= 'started' then return end

local hookId = exports.ox_inventory:registerHook('swapItems', function(payload)
    if payload.fromType == "player" and payload.toType == "player" then
        return false
    else
        return true
    end
end, {
    itemFilter = {
        [Config.PlateItemName] = true,
    },
})