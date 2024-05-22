local ADDON_NAME, namespace = ...;

namespace.Strings = namespace.Strings or {};

function namespace.Strings:Get(key)
    local locale = namespace.Strings[GetLocale()] or namespace.Strings["enUS"];
    return locale[key] or namespace.Strings["enUS"][key];
end