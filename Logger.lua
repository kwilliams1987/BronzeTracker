local ADDON_NAME, namespace = ...;

local Logger = namespace.Logger;

Logger = {};
Logger.LogLevel = {
    ["NONE"] = 0,
    ["ERROR"] = 1,
    ["WARNING"] = 2,
    ["NOTICE"] = 3,
    ["VERBOSE"] = 4
};

local minLogLevel = Logger.LogLevel.WARNING;

function Logger:Print(level, message, ...)
    if (level <= minLogLevel) then
        print(ADDON_NAME, format(message, ...))
    end
end

function Logger:Level(level = nil)
    local logLevel = tonumber(level);

    if (logLevel >= Logger.LogLevel.NONE and logLevel <= Logger.LogLevel.VERBOSE) then
        minLogLevel = logLevel;
    end

    return minLogLevel;
end