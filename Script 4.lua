syn.run_on_actor(getactors()[1],[[
local shared = getrenv().shared

local players = game:GetService("Players")

local ReplicationInterface = shared.require("ReplicationInterface");
local PublicSettings = shared.require("PublicSettings");
local Physics = shared.require("physics");
local CameraInterface = shared.require("CameraInterface");
local HudScreenGui = shared.require("HudScreenGui")
local UIScale = HudScreenGui.getUIScale()
local LocalPlayer = game:GetService("Players").LocalPlayer;
local CurrentCamera = workspace.CurrentCamera


-- print(u6.getEntry(localPlayer));
--         for i,v in pairs(u6) do print(i) end

local firearmSight = shared.require("FirearmSight")

-- _G.oldFirearmSight = firearmSight.new

firearmSight.new = function(p1, p2)
    -- print(p1, p2);
    
    _G.firearmObject = p1;
    
    return _G.oldFirearmSight(p1, p2);
end;

ReplicationInterface.operateOnAllEntries(function(player, entry)
    -- try catch block
    local success, err = pcall(function()
        if player.TeamColor ~= LocalPlayer.TeamColor and entry:isAlive() then
            print(player)
            _G.player = player;
            _G.entry = entry;
            local v13 = ReplicationInterface.getEntry(player);
            if not v13 then
                print("welp")
                return;
            end
            print('------', player, _G.firearmObject);
            closestPlayerDot = nil;
            local activeCamera = CameraInterface.getActiveCamera("MainCamera")

            local cameraPosition = activeCamera:getCFrame().p
			local playerPosition, isPlayerPositionValid = ReplicationInterface.getEntry(player):getPosition()

            if isPlayerPositionValid then
                local trajectory = Physics.trajectory(cameraPosition, PublicSettings.bulletAcceleration, playerPosition, _G.firearmObject:getWeaponStat("bulletspeed"))
                print(trajectory);

                if trajectory then
					closestPlayerDot = CurrentCamera:WorldToViewportPoint(cameraPosition + trajectory)
				end
            end
            -- for i,v in pairs(v13) do print(i) end

            if closestPlayerDot then
                local position = UDim2.new(0, closestPlayerDot.x / UIScale - 1, 0, closestPlayerDot.y / UIScale - 1);
                print(position)
            end
        
        end
    end)
    if not success then
        print(err)
    end
end);
]])