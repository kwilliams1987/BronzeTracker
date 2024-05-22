local ADDON_NAME, namespace = ...;

namespace.Strings = namespace.Strings or {};

function namespace.Strings:Get(key)
    return namespace.Strings["en-US"][key];
end