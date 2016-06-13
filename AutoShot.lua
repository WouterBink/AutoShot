AutoShot = CreateFrame("FRAME", "AutoShot");

local timer = GetTime();
local SSTimer = 1800;

local SSOnHK = true;
local SSOnLvl = true;
local SSOnBG = true;
local SSOnTimer = true;

local version = "1.0.0";
local colorScheme = "FF3CAFFF";

AutoShot:RegisterEvent("PLAYER_LEVEL_UP");
AutoShot:RegisterEvent("PLAYER_PVP_KILLS_CHANGED");
AutoShot:RegisterEvent("UPDATE_BATTLEFIELD_STATUS");

function print(s)
    DEFAULT_CHAT_FRAME:AddMessage(s);
end

local function printHelp()
    print("|c" .. colorScheme .. "AutoShot: |rAutomatically take screenshots.");
    print("|c" .. colorScheme .. "   Commands:");
    print(" - |c" .. colorScheme .. "trigger hk: |rTake screenshot after getting an honorable kill outside a battleground. Current value: [" .. tostring(SSOnHK) .. "]");
    print(" - |c" .. colorScheme .. "trigger bg: |rTake screenshot after completing a battleground. Current value: [" .. tostring(SSOnBG) .. "]");
    print(" - |c" .. colorScheme .. "trigger lvl: |rTake screenshot after levelling up. Current value: [" .. tostring(SSOnLvl) .. "]");
    print(" - |c" .. colorScheme .. "trigger timer: |rTake screenshot after a certain time has passed. Current value: [" .. tostring(SSOnTimer) .. "]");
    print(" - |c" .. colorScheme .. "timer <seconds>: |rTime between automatic screenshots (not counting other triggers). Current value: [" .. SSTimer .. "]");
end

local function eventHandler(self, event, ...)
    -- <Should> Take screenshot after bg finish.
    if SSOnBG and event == "UPDATE_BATTLEFIELD_STATUS" then
        if GetBattlefieldInstanceExpiration() > 0 then 
            Screenshot(); 
        end         
    
    -- Take screenshot after HK while not in bg.
    elseif SSOnHK and event == "PLAYER_PVP_KILLS_CHANGED" then
        local b, t = IsInInstance();
        
        if not b or t ~= "pvp" then
            Screenshot();
        end
        
    -- Take screenshot on levelup.    
    elseif SSOnLvl and event == "PLAYER_LEVEL_UP" then
        Screenshot();
    end
end

local function updateHandler()
    if SSOnTimer and GetTime() - timer > SSTimer then
        Screenshot();
        timer = GetTime();
    end
end

SLASH_AUTOSHOT1, SLASH_AUTOSHOT2 = "/as", "/autoshot";

local function slashCommandHandler(msg, editbox)
    local _,_,cmd, args = string.find(msg, "^(%S*)%s*(.-)$");
    cmd = string.lower(cmd);
    
    if cmd == "trigger" then
        if args == "hk" then 
            SSOnHK = not SSOnHK;
            print("AutoShot Honorable Kill Trigger set to: [" .. tostring(SSOnHK) .. "]");
        elseif args == "bg" then 
            SSOnBG = not SSOnBG;
            print("AutoShot Battleground Trigger set to: [" .. tostring(SSOnBG) .. "]");
   
        elseif args == "timer" then 
            SSOnTimer = not SSOnTimer;
            print("AutoShot Timer Trigger set to: [" .. tostring(SSOnTimer) .. "]");
        elseif args == "lvl" then 
            SSOnLvl = not SSOnLvl; 
            print("AutoShot Levelup Trigger set to: [" .. tostring(SSOnLvl) .. "]");        
        end
    
    elseif cmd == "timer" then
        if tonumber(args) ~= nil then
            SSTimer = tonumber(args);
            print("Seconds between automatic screenshots set to: [" .. SSTimer .. "]");
        end
    
    elseif cmd == "version" then
        print("AutoShot version " .. version);
    
    else
        printHelp();
    end
end

SlashCmdList["AUTOSHOT"] = slashCommandHandler;


AutoShot:SetScript("OnEvent", eventHandler);
AutoShot:SetScript("OnUpdate", updateHandler);
