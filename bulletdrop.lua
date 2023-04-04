local shared = getrenv().shared

local ReplicationInterface = shared.require("ReplicationInterface");
local LocalPlayer = game:GetService("Players").LocalPlayer;

ReplicationInterface.operateOnAllEntries(function(player, entry)
    -- try catch block
    local success, err = pcall(function()
        if player.TeamColor ~= LocalPlayer.TeamColor and entry:isAlive() then
            local v13 = ReplicationInterface.getEntry(player);
            if not v13 then
                print("welp")
                return;
            end
			local playerPosition, isPlayerPositionValid = ReplicationInterface.getEntry(player):getPosition()
            if isPlayerPositionValid then
                print(playerPosition)
            end
        
        end
    end)
    if not success then
        print(err)
    end
end);