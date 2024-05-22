local ADDON_NAME, namespace = ...;

local BronzeTracker = namespace[ADDON_NAME];
local Logger, LogLevel = namespace.Logger, namespace.Logger.LogLevel;
local Strings = namespace.Strings;
BronzeTracker = {};
BronzeTracker.currencyId = 2778;
BronzeTracker.maximumRequired = 1607500;
BronzeTracker.loaded = false;

namespace.Mounts = namespace.Mounts or {};
namespace.Toys = namespace.Toys or {};
namespace.Appearances = namespace.Appearances or {};

function tableSize(table)
    local count = 0;

    for _ in pairs(table) do
        count = count + 1
    end

    return count
end

function BronzeTracker:GetTotalRequired()
    Logger:Print(LogLevel.NOTICE, Strings:Get("REGISTERED_ITEMS"),
        tableSize(namespace.Mounts), 
        tableSize(namespace.Toys), 
        tableSize(namespace.Appearances));

    local currencyInfo = C_CurrencyInfo.GetCurrencyInfo(BronzeTracker.currencyId);
    local alreadyOwned, remainingNeeded = 0, 0;

    for itemID, cost in pairs(namespace.Mounts) do
        local spellID, mountID = GetItemSpell(itemID), nil;
        
        if (spellID ~= nil) then
            mountID = C_MountJournal.GetMountFromSpell(spellID);
        end

        if (mountID == nil) then
            Logger:Print(LogLevel.WARNING, Strings:Get("WARNING_INVALID_MOUNT"), spellID);
        else
            local name, _, _, _, _, _, _, _, _, _, isCollected, _ = C_MountJournal.GetMountInfoByID(mountID);
            
            Logger:Print(LogLevel.VERBOSE, Strings:Get("COLLECTED_STATE"), name, tostring(isCollected));
            
            if (isCollected == true) then
                alreadyOwned = alreadyOwned + cost;
            else
                remainingNeeded = remainingNeeded + cost;
            end
        end
    end

    for itemID, cost in pairs(namespace.Toys) do
        local _, toyName = C_ToyBox.GetToyInfo(itemID)

        if (toyName == nil) then
            Logger:Print(LogLevel.WARNING, Strings:Get("WARNING_INVALID_TOY"), itemID);
        else
            local collected = PlayerHasToy(itemID);
            Logger:Print(LogLevel.VERBOSE, Strings:Get("COLLECTED_STATE"), toyName, tostring(collected));

            if (collected) then
                alreadyOwned = alreadyOwned + cost;
            else
                remainingNeeded = remainingNeeded + cost;
            end
        end
    end

    for itemID, cost in pairs(namespace.Appearances) do
        local itemName = C_Items.GetItemInfo(itemID);
        local itemAppearanceID, _ = C_TransmogCollection.GetItemInfo(itemID);

        if (itemName == nil or itemAppearanceID == nil) then
            Logger:Print(LogLevel.WARNING, Strings:Get("WARNING_INVALID_APPEARANCE"), itemID);
        else
            local collected = C_TransmogCollection.PlayerHasTransmogByItemInfo(itemID);

            Logger:Print(LogLevel.VERBOSE, Strings:Get("COLLECTED_STATE"), itemName, tostring(collected));

            if (collected == true) then
                alreadyOwned = alreadyOwned + cost;
            else
                remainingNeeded = remainingNeeded + cost;
            end
        end
    end

    local completion = 100 - floor(currencyInfo.quantity / remainingNeeded * 100);
    local text = format(Strings:Get("COLLECTION_SUMMARY"),
        currencyInfo.quantity,
        remainingNeeded,
        C_CurrencyInfo.GetCurrencyLink(BronzeTracker.currencyId),
        min(completion, 100),
        alreadyOwned);

    DEFAULT_CHAT_FRAME:AddMessage(text);
end

_G["BronzeTracker"] = BronzeTracker;

SLASH_BRONZETRACKER1 = Strings:Get("SLASHCOMMAND");

function SlashCmdList.BRONZETRACKER(msg, editbox)
    local logLevel, _ = msg:match("^(%S*)%s*(.-)$")

    if (logLevel ~= nil) then
        Logger:Level(logLevel)
    end

    Logger:Print(LogLevel.NOTICE, Strings:Get("COMMAND_INVOKED"));
    BronzeTracker:GetTotalRequired();
end
