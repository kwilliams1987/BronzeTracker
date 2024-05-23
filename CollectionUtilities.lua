local ADDON_NAME, namespace = ...;

local CollectionUtilities = namespace.CollectionUtilities;
local Logger, LogLevel, Strings = namespace.Logger, namespace.Logger.LogLevel, namespace.Strings;

CollectionUtilities = {};

function CollectionUtilities:PlayerHasMount(itemID)
    local mountID = C_MountJournal.GetMountFromItem(itemID);
    if (mountID == nil) then
        Logger:Print(LogLevel.WARNING, Strings:Get("WARNING_INVALID_MOUNT"), itemID);

        return nil;
    else
        local name, _, _, _, _, _, _, _, _, _, isCollected, _ = C_MountJournal.GetMountInfoByID(mountID);
        Logger:Print(LogLevel.VERBOSE, Strings:Get("COLLECTED_STATE"), name, tostring(isCollected));
        return isCollected;
    end
end

function CollectionUtilities:PlayerHasToy(itemID)
    local _, toyName = C_ToyBox.GetToyInfo(itemID)

    if (toyName == nil) then
        Logger:Print(LogLevel.WARNING, Strings:Get("WARNING_INVALID_TOY"), itemID);

        return nil;
    else
        local collected = PlayerHasToy(itemID);
        Logger:Print(LogLevel.VERBOSE, Strings:Get("COLLECTED_STATE"), toyName, tostring(collected));

        return collected;
    end
end

function CollectionUtilities:PlayerHasAppearance(itemID)
    local itemName = C_Item.GetItemInfo(itemID);

    if (C_Item.IsDressableItemByID(itemID)) then
        Logger:Print(LogLevel.VERBOSE, Strings:Get("CHECKING_DRESSABLE_ITEM"), itemID);

        local itemAppearanceID, _ = C_TransmogCollection.GetItemInfo(itemID);

        if (itemName == nil or itemAppearanceID == nil) then
            Logger:Print(LogLevel.WARNING, Strings:Get("WARNING_INVALID_APPEARANCE"), itemID);

            return nil;
        else
            local collected = C_TransmogCollection.PlayerHasTransmogByItemInfo(itemID);
            Logger:Print(LogLevel.VERBOSE, Strings:Get("COLLECTED_STATE"), itemName, tostring(collected));

            return collected;
        end
    else
        Logger:Print(LogLevel.VERBOSE, Strings:Get("CHECKING_ENSEMBLE_ITEM"), itemID);

        local tooltip = C_TooltipInfo.GetItemByID(itemID);

        if (tooltip == nil) then
            return nil;
        end

        for index, line in ipairs(tooltip.lines) do
            if (line.leftText and string.match(line.leftText, ITEM_SPELL_KNOWN)) then
                Logger:Print(LogLevel.VERBOSE, Strings:Get("FOUND_ITEM_TOOLTIP_TEXT"), "ITEM_SPELL_KNOWN", index, "leftText", line.tooltipType);

                return true;
            end

            if (line.rightText and string.match(line.rightText, ITEM_SPELL_KNOWN)) then
                Logger:Print(LogLevel.VERBOSE, Strings:Get("FOUND_ITEM_TOOLTIP_TEXT"), "ITEM_SPELL_KNOWN", index, "rightText", line.tooltipType);

                return true;
            end
        end

        return false;
    end
end