local frame = CreateFrame("FRAME", "FooAddonFrame");
frame:RegisterEvent("PLAYER_LEVEL_UP");
local function eventHandler(self, event, ...)
    Screenshot();
end
frame:SetScript("OnEvent", eventHandler);
