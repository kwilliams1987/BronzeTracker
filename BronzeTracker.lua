local ADDON_NAME, namespace = ...;

local BronzeTracker = namespace[ADDON_NAME];
BronzeTracker = {};
BronzeTracker.debugLevel = 3; -- NONE, ERROR, WARNING, NOTICE, VERBOSE
BronzeTracker.currencyId = 2778;
BronzeTracker.maximumRequired = 1607500;
BronzeTracker.loaded = false;

namespace.Mounts = namespace.Mounts or {};
namespace.Toys = namespace.Toys or {};
namespace.Appearances = namespace.Appearances or {};

function BronzeTracker:print(level, message, ...)
    if (level <= BronzeTracker.debugLevel) then
        print(ADDON_NAME, format(message, ...))
    end
end

function BronzeTracker:GetTotalRequired()
    BronzeTracker:print(3, "%d mounts, %d toys and %d appearances registered.",
        #namespace.Mounts, #namespace.Toys, #namespace.Appearances);

    local currentTotal = C_CurrencyInfo.GetCurrencyInfo(BronzeTracker.currencyId);
    local alreadyOwned, remainingNeeded = 0, 0;

    for spellID, cost in pairs(namespace.Mounts) do
        local mountID = C_MountJournal.GetMountFromSpell(spellID);
        if (mountID == nil) then
            BronzeTracker:print(2, "Warning: spellID %d is not a valid mount.", spellID);
        else
            local name, _, _, _, _, _, _, _, _, _, isCollected, _ = C_MountJournal.GetMountInfoByID(mountID);
            
            BronzeTracker:print(4, "%s collected: %s", name, tostring(isCollected));
            
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
            BronzeTracker:print(2, "Warning: itemID %d is not a valid toy.", itemID);
        else
            local collected = PlayerHasToy(itemID);
            BronzeTracker:print(4, "%s collected: %s", toyName, tostring(collected));

            if (collected) then
                alreadyOwned = alreadyOwned + cost;
            else
                remainingNeeded = remainingNeeded + cost;
            end
        end
    end

    for itemID, cost in pairs(namespace.Appearances) do
        if (C_TransmogCollection.PlayerHasTransmogByItemInfo(itemID) == true) then
            alreadyOwned = alreadyOwned + cost;
        else
            remainingNeeded = remainingNeeded + cost;
        end
    end

    local completion = 100 - floor(currentTotal.quantity / remainingNeeded * 100);
    local text = format("%d / %d %s (%d%% remaining, %d already spent)",
        currentTotal.quantity,
        remainingNeeded,
        C_CurrencyInfo.GetCurrencyLink(BronzeTracker.currencyId),
        min(completion, 100),
        alreadyOwned);

    DEFAULT_CHAT_FRAME:AddMessage(text);
end

_G["BronzeTracker"] = BronzeTracker;

SLASH_BRONZETRACKER1 = "/bronzetracker";

function SlashCmdList.BRONZETRACKER(msg, editbox)
    BronzeTracker:print(3, "/bronzetracker invoked.");
    BronzeTracker:GetTotalRequired();
end
