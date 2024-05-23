local ADDON_NAME, namespace = ...;

local BronzeTracker = namespace[ADDON_NAME];
local Logger, LogLevel, Strings, Collection = namespace.Logger, namespace.Logger.LogLevel, namespace.Strings, namespace.CollectionUtilities;

BronzeTracker = {};
BronzeTracker.currencyId = 2778;
BronzeTracker.maximumRequired = 1607500;
BronzeTracker.loaded = false;

local function tableSize(table)
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

    Logger:Print(LogLevel.VERBOSE, Strings:Get("PRELOADING_ITEM_INFO"));

    local itemLoader = ContinuableContainer:Create();

    for itemID in pairs(namespace.Mounts) do
        itemLoader:AddContinuable(Item:CreateFromItemID(itemID));
    end

    for itemID in pairs(namespace.Toys) do
        itemLoader:AddContinuable(Item:CreateFromItemID(itemID));
    end

    for itemID in pairs(namespace.Appearances) do
        itemLoader:AddContinuable(Item:CreateFromItemID(itemID));
    end

    itemLoader:ContinueOnLoad(function()
        local currencyInfo = C_CurrencyInfo.GetCurrencyInfo(BronzeTracker.currencyId);
        local alreadyOwned, remainingNeeded = 0, 0;

        for itemID, cost in pairs(namespace.Mounts) do
            local collected = Collection:PlayerHasMount(itemID);

            if (collected == true) then
                alreadyOwned = alreadyOwned + cost;
            else
                remainingNeeded = remainingNeeded + cost;
            end
        end

        for itemID, cost in pairs(namespace.Toys) do
            local collected = Collection:PlayerHasToy(itemID);

            if (collected) then
                alreadyOwned = alreadyOwned + cost;
            else
                remainingNeeded = remainingNeeded + cost;
            end
        end

        for itemID, cost in pairs(namespace.Appearances) do
            local collected = Collection:PlayerHasAppearance(itemID);

            if (collected) then
                alreadyOwned = alreadyOwned + cost;
            else
                remainingNeeded = remainingNeeded + cost;
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
    end);
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
