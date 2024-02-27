if Config.Keys ~= "mono" then return end
if Config.Debug then print("Keys Set To ", Config.Keys) end

function RemoveOldKeys(src, entityid, oldplate, newplate)
    local action = 'revome' --  'add' or 'revome'
    exports.mono_garage:InventoryKeys(action, { plate = oldplate, player = src})
end

function GiveKeys(src, entityid, oldplate, newplate)
    local action = 'add'
    exports.mono_garage:InventoryKeys(action, { plate = newplate, player = src})
end