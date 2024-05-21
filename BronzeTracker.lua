local ADDON_NAME, namespace = ...;

local BronzeTracker = namespace[ADDON_NAME];
BronzeTracker = {};
BronzeTracker.debugging = true;
BronzeTracker.currencyId = 2778;
BronzeTracker.maximumRequired = 1607500;
BronzeTracker.loaded = false;

namespace.Mounts = namespace.Mounts or {};
namespace.Toys = namespace.Toys or {};
namespace.Appearances = namespace.Appearances or {};

function BronzeTracker:print(message)
    if (BronzeTracker.debugging) then
        print(message)
    end
end

function BronzeTracker:GetTotalRequired()
    local currentTotal = C_CurrencyInfo.GetCurrencyInfo(BronzeTracker.currencyId);
    local maximumRequired = 0;

    for mountID, cost in pairs(namespace.Mounts) do
        local _, _, _, _, _, _, _, _, _, _, isCollected = C_MountJournal.GetMountInfoByID(mountID);
        if (isCollected ~= true) then
            maximumRequired = maximumRequired + cost;
        end
    end

    for itemID, cost in pairs(namespace.Toys) do
        if (PlayerHasToy(itemID) ~= true) then
            maximumRequired = maximumRequired + cost;
        end
    end

    for itemID, cost in pairs(namespace.Appearances) do
        if (C_TransmogCollection.PlayerHasTransmogByItemInfo(itemID) ~= true) then
            maximumRequired = maximumRequired + cost;
        end
    end

    local completion = floor(currentTotal.quantity / maximumRequired * 100);
    local text = C_CurrencyInfo.GetCurrencyLink(BronzeTracker.currencyId, currentTotal.quantity)
        + " / " + C_CurrencyInfo.GetCurrencyLink(BronzeTracker.currencyId, maximumRequired
        + " (" + min(completion, 100) + "%)");

    DEFAULT_CHAT_FRAME:AddMessage(text);
end

_G["BronzeTracker"] = BronzeTracker;

SLASH_BRONZETRACKER1 = "/bronzetracker";

function SlashCmdList.BRONZETRACKER(msg, editbox)
    BronzeTracker:GetTotalRequired();
end
