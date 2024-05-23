local ADDON_NAME, namespace = ...;

namespace.Strings = namespace.Strings or {};
namespace.Strings["enUS"] = {
    ["SLASHCOMMAND"] = "/bronzetracker",
    ["COMMAND_INVOKED"] = "/bronzetracker invoked.",
    ["PRELOADING_ITEM_INFO"] = "Preloading item tooltips.",
    ["REGISTERED_ITEMS"] = "%d mounts, %d toys and %d appearances registered.",
    ["WARNING_INVALID_MOUNT"] = "Warning: itemID %d is not a valid mount.",
    ["WARNING_INVALID_TOY"] = "Warning: itemID %d is not a valid toy.",
    ["WARNING_INVALID_APPEARANCE"] = "Warning: itemID %d is not a valid appearance.",
    ["COLLECTED_STATE"] = "%s collected: %s",
    ["COLLECTION_SUMMARY"] = "%d / %d %s (%d%% remaining, %d already spent)",
    ["COLLECTION_COMPLETE"] = "Collection is complete!",
    ["CHECKING_DRESSABLE_ITEM"] = "Checking if dressable %d is owned.",
    ["CHECKING_ENSEMBLE_ITEM"] = "Checking if ensemble %d is owned.",
    ["FOUND_ITEM_TOOLTIP_TEXT"] = "Found %s at line index %d (%s) with line type %d"
};