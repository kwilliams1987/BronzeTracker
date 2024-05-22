local ADDON_NAME, namespace = ...;

local BronzeTracker = namespace[ADDON_NAME];
local Logger, LogLevel, Strings = namespace.Logger, namespace.Logger.LogLevel, namespace.Strings;

BronzeTracker = {};
BronzeTracker.currencyId = 2778;
BronzeTracker.maximumRequired = 1607500;
BronzeTracker.loaded = false;

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
        local mountID = C_MountJournal.GetMountFromItem(itemID);
        if (mountID == nil) then
            Logger:Print(LogLevel.WARNING, Strings:Get("WARNING_INVALID_MOUNT"), itemID);
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
        local itemName = C_Item.GetItemInfo(itemID);
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

    if (remainingNeeded == 0) then
        DEFAULT_CHAT_FRAME:AddMessage(Strings:Get("COLLECTION_COMPLETE"));
    else
        local completion = 100 - floor(currencyInfo.quantity / remainingNeeded * 100);
        local text = format(Strings:Get("COLLECTION_SUMMARY"),
            currencyInfo.quantity,
            remainingNeeded,
            C_CurrencyInfo.GetCurrencyLink(BronzeTracker.currencyId),
            min(completion, 100),
            alreadyOwned);

        DEFAULT_CHAT_FRAME:AddMessage(text);
    end
end

_G["BronzeTracker"] = BronzeTracker;

SLASH_BRONZETRACKER1 = Strings:Get("SLASHCOMMAND");

function SlashCmdList.BRONZETRACKER(msg, editbox)
    if (msg ~= "") then
    local logLevel, _ = msg:match("^(%S*)%s*(.-)$")

        if (logLevel ~= nil) then
            Logger:Level(logLevel)
        end
    end

    Logger:Print(LogLevel.NOTICE, Strings:Get("COMMAND_INVOKED"));
    BronzeTracker:GetTotalRequired();
end
