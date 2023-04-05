local util = require("util")
local camera = workspace.CurrentCamera
local shared = getrenv().shared
local replicationObject = shared.require("ReplicationObject")
local replicationInterface = shared.require("ReplicationInterface")
local gameClock = shared.require("GameClock")


local runService = game:GetService("RunService")
local localPlayer = game:GetService("Players").LocalPlayer

local esp = {enabled = false, esp_table = {}}

function esp:create_esp(player)
    local entry = replicationInterface.getEntry(player)
    local character = entry and replicationObject.getThirdPersonObject(entry)

    if character and replicationObject.isAlive(entry) then

        local body_parts = character:getCharacterHash()
        local head = body_parts.head
        local head_CFrame = entry._smoothReplication:getFrame(
                                gameClock.getTime())
        local color = util.colors.getTeamColor(localPlayer, player)

        local v2 = camera:WorldToScreenPoint(head_CFrame *
                                                 CFrame.new(0, head.Size.Y, 0).p)
        local Name = Drawing.new("Text")
        Name.Text = tostring(player)
        Name.Color = color
        Name.Size = 15
        Name.Position = Vector2.new(v2.X, v2.Y)
        Name.Visible = self.enabled

        local Dist = Drawing.new("Text")
        Dist.Text = ""
        Dist.Color = color
        Dist.Size = 15
        Dist.Position = Vector2.new(v2.X, v2.Y + 15)
        Dist.Visible = self.enabled
        print(player, entry, character, body_parts.head.Size)

        self.esp_table[player] = {["Name"] = Name, ["Dist"] = Dist}
    end
end

function esp:init() 
    util.misc:runLoop("ESP_Update", function()
        print("ho")
    end, runService.RenderStepped)
end

esp:init();