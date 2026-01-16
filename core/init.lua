Bridge = exports.community_bridge:Bridge()

function locale(message, ...)
    return Bridge.Language.Locale(message, ...)
end

if not IsDuplicityVersion() then return end

AddEventHandler('onResourceStart', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    Bridge.Version.AdvancedVersionChecker("MrNewb/patchnotes", resource)
    Bridge.Version.AdvancedVersionChecker("MrNewb/patchnotes", "community_bridge")
end)