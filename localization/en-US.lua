local ADDON_NAME, namespace = ...;

namespace.Strings = namespace.Strings or {};
namespace.Strings["en-US"] = {
    ["SLASHCOMMAND"] = "/bronzetracker",
    ["COMMAND_INVOKED"] = "/bronzetracker invoked.",
    ["REGISTERED_ITEMS"] = "%d mounts, %d toys and %d appearances registered.",
    ["WARNING_INVALID_MOUNT"] = "Warning: spellID %d is not a valid mount.",
    ["WARNING_INVALID_TOY"] = "Warning: itemID %d is not a valid toy.",
    ["WARNING_INVALID_APPEARANCE"] = "Warning: itemID %d is not a valid appearance.",
    ["COLLECTED_STATE"] = "%s collected: %s",
    ["COLLECTION_SUMMARY"] = "%d / %d %s (%d%% remaining, %d already spent)"
};