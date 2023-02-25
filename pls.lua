-- funcs
local upvalueFix = function(func) return function(...) return func(...); end end

-- modules
local dataStoreClient, playerDataUtils, contentDatabase;
do
    for _, object in next, getgc(true) do
        if (typeof(object) == "table") then
            if (rawget(object, "getPlayerData") and rawget(object, "isDataReady")) then
                dataStoreClient = object;
            elseif (rawget(object, "rankCalculator") and rawget(object, "getPlayerRank")) then
                playerDataUtils = object;
            elseif (rawget(object, "getAllWeaponsList")) then
                contentDatabase = object;
            end



        end
    end
end

-- services
local players = game:GetService("Players");
local runService = game:GetService("RunService");
local replicatedSotrage = game:GetService("ReplicatedStorage");

-- cache
local localPlayer = players.LocalPlayer;
local content = replicatedSotrage:WaitForChild("Content");
local productionContent = content:WaitForChild("ProductionContent");
local attachmentDatabase = productionContent:WaitForChild("AttachmentDatabase");
local categories = attachmentDatabase:WaitForChild("Categories");

-- data
local defaultWeaponCache = {
    ["ASSAULT RIFLE"] = "AK12",
    ["BATTLE RIFLE"] = "AK12",
    ["CARBINE"] = "M4A1",
    ["PDW"] = "MP5K",
    ["DMR"] = "M9",
    ["SHOTGUN"] = "KSG 12",
    ["LMG"] = "COLT LMG",
    ["SNIPER RIFLE"] = "INTERVENTION",
    ["PISTOLS"] = "M9",
    ["MACHINE PISTOLS"] = "G17",
    ["REVOLVERS"] = "M9",
    ["OTHER"] = {
        ["SUPER SHORTY"] = "KSG 12",
        ["SFG 50"] = "INTERVENTION",
        ["M79 THUMPER"] = "M4A1",
        ["COILGUN"] = "M9",
        ["SAWED OFF"] = "KSG 12",
        ["SAIGA-12U"] = "M9",
        ["ORBEZ"] = "INTERVENTION",
        ["SASS 308"] = "INTERVENTION",
    },
    ["FRAGMENTATION"] = "M67 FRAG",
    ["HIGH EXPLOSIVE"] = "DYNAMITE",
    ["IMPACT"] = "M67 FRAG",
    ["ONE HAND BLADE"] = "KNIFE",
    ["TWO HAND BLADE"] = "KNIFE",
    ["ONE HAND BLUNT"] = "MAGLITE CLUB",
    ["TWO HAND BLUNT"] = "HOCKEY STICK"
};
local weaponClassType = {
    ["ASSAULT RIFLE"] = "Primary",
    ["BATTLE RIFLE"] = "Primary",
    ["CARBINE"] = "Primary",
    ["PDW"] = "Primary",
    ["DMR"] = "Primary",
    ["SHOTGUN"] = "Primary",
    ["LMG"] = "Primary",
    ["SNIPER RIFLE"] = "Primary",
    ["PISTOLS"] = "Secondary",
    ["MACHINE PISTOLS"] = "Secondary",
    ["REVOLVERS"] = "Secondary",
    ["OTHER"] = "Secondary",
    ["FRAGMENTATION"] = "Grenade",
    ["HIGH EXPLOSIVE"] = "Grenade",
    ["IMPACT"] = "Grenade",
    ["ONE HAND BLADE"] = "Knife",
    ["TWO HAND BLADE"] = "Knife",
    ["ONE HAND BLUNT"] = "Knife",
    ["TWO HAND BLUNT"] = "Knife"
};
local selecedWeapons = {};
local selectedAttachments = {};

-- loops
do
    runService.Heartbeat:Connect(function()
        if (dataStoreClient.isDataReady()) then
            local playerData = dataStoreClient.getPlayerData(localPlayer);
            local rank = playerDataUtils.getPlayerRank(playerData);

            defaultWeaponCache["DMR"] = (rank >= 2 and "MK11" or "M9");
            defaultWeaponCache["REVOLVERS"] = (rank >= 4 and "MP412 REX" or "M9");
        end
    end);
end


-- inits
do
    for _, name in next, contentDatabase.getAllWeaponsList() do
        local weaponData = contentDatabase.getWeaponData(name);
        setreadonly(weaponData, false);
        print(weaponData)
        weaponData.unlockrank = 0;
        weaponData.exclusiveunlock = false;
        weaponData.hideunlessowned = false;
        weaponData.supertest = false;
        weaponData.adminonly = false;
    end

    for _, instance in next, categories:GetDescendants() do
        if (instance:IsA("ModuleScript") and instance.Name == "AttachmentData") then
            local attachmentData = require(instance);
            setreadonly(attachmentData, false);

            attachmentData.unlockkills = 0;
        end
    end
end
