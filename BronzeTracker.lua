local _, addonTable = ...;

addonTable.BronzeTracker = {};

local BronzeTracker = addonTable.BronzeTracker;
BronzeTracker.debugging = true;
BronzeTracker.currencyId = 2778;
BronzeTracker.maximumRequired = 1607500;
BronzeTracker.loaded = false;

BronzeTracker.items = {};
BronzeTracker.items.mounts = {
    { itemID = 441794, cost = 38500 },
    { itemID = 127158, cost = 38500 },
    { itemID = 127170, cost = 18700 },
    { itemID = 148476, cost = 38500 },
    { itemID = 435084, cost =  2200 }
};

BronzeTracker.items.toys = {
    { itemID = 104309, cost = 50000 }
};

BronzeTracker.items.appearances = {
    { itemID = 104309, cost =  2500 }
};

function addonTable.BronzeTracker:print(message)
    if (addonTable.BronzeTracker.debugging) then
        print(message)
    end
end

function BronzeTracker:GetTotalRequired()
    local currentTotal = C_CurrencyInfo.GetCurrencyInfo(BronzeTracker.currencyId);
    local maximumRequired = 0;

    for _, mount in pairs(BronzeTracker.items.mounts) do
        local _, _, _, _, _, _, _, _, _, _, isCollected = C_MountJournal.GetMountInfoByID(mount.itemID);
        if (isCollected ~= true) then
            maximumRequired = maximumRequired + mount.cost;
        end
    end

    for _, toy in pairs(BronzeTracker.items.toys) do
        if (PlayerHasToy(toy.itemID) ~= true) then
            maximumRequired = maximumRequired + toy.cost;
        end
    end

    for _, appearance in pairs(BronzeTracker.items.appearances) do
        if (C_TransmogCollection.PlayerHasTransmogByItemInfo(appearance.itemID) ~= true) then
            maximumRequired = maximumRequired + appearance.cost;
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