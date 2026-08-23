if not Config.EnableOxExclusive or bridge.inventory.getResourceName() ~= 'ox_inventory' then return end

local hookId = bridge.inventory.registerHook('swapItems', function(payload)
    if payload.fromType ~= 'player' or payload.toType ~= 'player' then return true end
    return payload.fromInventory == payload.toInventory
end, {
    itemFilter = {
        [Config.PlateItemName] = true,
    },
})

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName ~= GetCurrentResourceName() or not hookId then return end
    bridge.inventory.removeHooks(hookId)
end)
