local timer = GetTime();

local colorScheme = {blue = "FF3CAFFF"}

local version;

if (not ASConfig) then ASConfig = {}; end

function print(s)
    DEFAULT_CHAT_FRAME:AddMessage(s);
end

local function printHelp()
    print("|c" .. colorScheme.blue .. "AutoShot: |rAutomatically take screenshots.");
    print("|c" .. colorScheme.blue .. "   Commands:");
    print(" - |c" .. colorScheme.blue .. "trigger hk: |rTake screenshot after getting an honorable kill outside a battleground. Current value: [" .. tostring(ASConfig.SSOnHK) .. "]");
    print(" - |c" .. colorScheme.blue .. "trigger bg: |rTake screenshot after completing a battleground. Current value: [" .. tostring(ASConfig.SSOnBG) .. "]");
    print(" - |c" .. colorScheme.blue .. "trigger lvl: |rTake screenshot after levelling up. Current value: [" .. tostring(ASConfig.SSOnLvl) .. "]");
    print(" - |c" .. colorScheme.blue .. "trigger timer: |rTake screenshot after a certain time has passed. Current value: [" .. tostring(ASConfig.SSOnTimer) .. "]");
    print(" - |c" .. colorScheme.blue .. "timer <seconds>: |rTime between automatic screenshots (not counting other triggers). Current value: [" .. ASConfig.SSTimer .. "]");
end

function AutoShot_OnLoad()
    version = GetAddOnMetadata("AutoShot", "Version");
    
    AutoShot:RegisterEvent("PLAYER_LEVEL_UP");
    AutoShot:RegisterEvent("PLAYER_PVP_KILLS_CHANGED");
    AutoShot:RegisterEvent("UPDATE_BATTLEFIELD_STATUS");
    AutoShot:RegisterEvent("ADDON_LOADED");
    
    if not ASConfig.SSOnBG then ASConfig.SSOnBG = true; end
    if not ASConfig.SSOnHK then ASConfig.SSOnHK = true; end
    if not ASConfig.SSOnLvl then ASConfig.SSOnLvl = true; end
    if not ASConfig.SSOnTimer then ASConfig.SSOnTimer = true; end
    if not ASConfig.SSTimer then ASConfig.SSTimer = 1800; end
    
    print("|c" .. colorScheme.blue .. "AutoShot |rv" .. version .. " loaded.");
end

function AutoShot_OnEvent(event, ...)
    -- <Should> Take screenshot after bg finish. Untested.
    if (event == "UPDATE_BATTLEFIELD_STATUS" and ASConfig.SSOnBG) then
        if GetBattlefieldInstanceExpiration() > 0 then 
            Screenshot(); 
        end         
    
    -- Take screenshot after HK while not in bg.
    elseif (event == "PLAYER_PVP_KILLS_CHANGED" and ASConfig.SSOnHK) then
        local b, t = IsInInstance();
        
        if not b or t ~= "pvp" then
            Screenshot();
        end
        
    -- Take screenshot on levelup.    
    elseif (event == "PLAYER_LEVEL_UP" and ASConfig.SSOnLvl) then
        Screenshot();
    end
end

function AutoShot_OnUpdate()
    -- Take screenshot if timer exceeds the set SSTimer length.
    if (ASConfig.SSOnTimer) then
        if (GetTime() - timer > ASConfig.SSTimer) then
            Screenshot();
            timer = GetTime();
        end
    end
end

SLASH_AUTOSHOT1, SLASH_AUTOSHOT2 = "/as", "/autoshot";

local function slashCommandHandler(msg, editbox)
    local _,_,cmd, args = string.find(msg, "^(%S*)%s*(.-)$");
    cmd = string.lower(cmd);
    
    if cmd == "trigger" then
        if args == "hk" then 
            ASConfig.SSOnHK = not ASConfig.SSOnHK;
            print("AutoShot Honorable Kill Trigger set to: [" .. tostring(ASConfig.SSOnHK) .. "]");
        elseif args == "bg" then 
            ASConfig.SSOnBG = not ASConfig.SSOnBG;
            print("AutoShot Battleground Trigger set to: [" .. tostring(ASConfig.SSOnBG) .. "]");
   
        elseif args == "timer" then 
            ASConfig.SSOnTimer = not ASConfig.SSOnTimer;
            print("AutoShot Timer Trigger set to: [" .. tostring(ASConfig.SSOnTimer) .. "]");
        elseif args == "lvl" then 
            ASConfig.SSOnLvl = not ASConfig.SSOnLvl; 
            print("AutoShot Levelup Trigger set to: [" .. tostring(ASConfig.SSOnLvl) .. "]");        
        end
    
    elseif cmd == "timer" then
        if tonumber(args) ~= nil then
            ASConfig.SSTimer = tonumber(args);
            print("Seconds between automatic screenshots set to: [" .. ASConfig.SSTimer .. "]");
        end
    
    elseif cmd == "version" then
        print("AutoShot version " .. version);
    
    else
        printHelp();
    end
end

SlashCmdList["AUTOSHOT"] = slashCommandHandler;

