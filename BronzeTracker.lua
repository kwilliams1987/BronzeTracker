local ADDON_NAME, namespace = ...;

local BronzeTracker = namespace[ADDON_NAME];
local Logger, LogLevel, Strings = namespace.Logger, namespace.Logger.LogLevel, namespace.Strings;

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

    for collection, items in pairs(namespace.Collections) do
        Logger:Print(LogLevel.VERBOSE, Strings:Get("PRELOADING_ITEM_TYPE"), collection);

        for itemID in pairs(items) do
            itemLoader:AddContinuable(Item:CreateFromItemID(itemID));
        end
    end

    itemLoader:ContinueOnLoad(function()
        local currencyInfo = C_CurrencyInfo.GetCurrencyInfo(BronzeTracker.currencyId);
        local alreadyOwned, remainingNeeded = 0, 0;
        local collections = {
            ["Mounts"] = "PlayerHasMount",
            ["Toys"] = "PlayerHasToy",
            ["Appearances"] = "PlayerHasAppearance"
        };

        for collection, tester in pairs(collections) do
            for itemID, cost in pairs(namespace.Collections[collection]) do
                local collected = namespace.CollectionUtilities[tester](itemID);

                if (collected ~= nil) then
                    if (collected == true) then
                        alreadyOwned = alreadyOwned + cost;
                    else
                        remainingNeeded = remainingNeeded + cost;
                    end
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
