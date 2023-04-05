local shared = getrenv().shared

local players = game:GetService("Players")

local client = game:GetService("Players").LocalPlayer;

local replicationObject = shared.require("ReplicationObject")
local replicationInterface = shared.require("ReplicationInterface")

for _, player in pairs(players:GetPlayers()) do
    if player == client or player.Team == client.Team then
        continue
    end

    local entry = replicationInterface.getEntry(player)
    local character = entry and replicationObject.getThirdPersonObject(entry)

    if character and replicationObject.isAlive(entry) then

        local body_parts = character:getCharacterHash()

        print(player, entry, character, body_parts.head.Size)

    end

end
