if not Config.EnableOxExclusive or bridge.inventory.getResourceName() ~= 'ox_inventory' then return end

local function onSwapItems(payload)
    if payload.fromType ~= 'player' or payload.toType ~= 'player' then return true end
    return payload.fromInventory == payload.toInventory
end

local hookId = bridge.inventory.registerHook('swapItems', onSwapItems, {
    itemFilter = { [Config.PlateItemName] = true },
})

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName ~= cache.resource or not hookId then return end
    bridge.inventory.removeHooks(hookId)
end)
