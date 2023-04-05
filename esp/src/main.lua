local util = require("util")
local camera = workspace.CurrentCamera
local shared = getrenv().shared
local replicationObject = shared.require("ReplicationObject")
local replicationInterface = shared.require("ReplicationInterface")
local gameClock = shared.require("GameClock")

local runService = game:GetService("RunService")
local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local client = game:GetService("Players").LocalPlayer

local esp = {enabled = true, esp_table = {}}

function esp:create_esp(player)
        local color = util.color.getTeamColor(localPlayer, player)

        local Name = Drawing.new("Text")
        Name.Text = tostring(player)
        Name.Color = color
        Name.Size = 15
        Name.Position = Vector2.new(0, 0)
        Name.Visible = false

        local Dist = Drawing.new("Text")
        Dist.Text = ""
        Dist.Color = color
        Dist.Size = 15
        Dist.Position = Vector2.new(0, 0)
        Dist.Visible = false
        self.esp_table[player] = {["Name"] = Name, ["Dist"] = Dist}
    
end

function esp:update_esp(player)
    local success, err = pcall(function()
        if player == client or player.Team == client.Team or tostring(player) == nil then

            return
        end
    local currPos
    if client and client.Character then 
    	currPos = client.Character.HumanoidRootPart.Position
	end
    local t = self.esp_table[player]

    if currPos == nil then
        -- print("currPos is nil")
        if t ~= nil then
            t.Name.Visible = false
            t.Dist.Visible = false
        end
        return;
    end


    local entry = replicationInterface.getEntry(player)
    local character = entry and replicationObject.getThirdPersonObject(entry)


    if character and t ~= nil then
        local body_parts = character:getCharacterHash()
        local head = body_parts.head
        local tor = body_parts.torso;
        if head then
            local v2, vis = camera:WorldToScreenPoint(head.Position)
            if vis and replicationObject.isAlive(entry) then
                local name = tostring(player)
                print(name)
                t.Name.Text = name
                t.Name.Position = Vector2.new(v2.X, v2.Y)
                t.Name.Visible = true

                local dist = (currPos - tor.Position).magnitude
                t.Dist.Position = Vector2.new(v2.X, v2.Y + 15)
                t.Dist.Visible = true
                t.Dist.Text = string.format("%.0f", dist)
            else
                t.Name.Visible = false
                t.Dist.Visible = false
            end
        end
    else
        if t ~= nil then
            t.Name.Visible = false
            t.Dist.Visible = false
        end
    end
    end)
    if not success then
        print(err)
    end
end
function esp:remove_esp(plr)
    if self.esp_table[tostring(plr)] ~= nil then
        for i, v in next, self.esp_table[tostring(plr)] do
            v:Remove()
        end

        self.esp_table[tostring(plr)] = nil
    end
end
function esp:update_esp_color(plr)
    local color = util.color.getTeamColor(localPlayer, plr)
    if self.esp_table[tostring(plr)] ~= nil then
        for i, v in next, self.esp_table[tostring(plr)] do
            v.Color = color
        end
    end
end
function esp:init() 
    util.misc:runLoop("ESP_Update", function()
        if self.enabled then
            for i, v in pairs(players:GetPlayers()) do
                self:update_esp(v)
            end
        end
    end, runService.RenderStepped)

    for i, v in pairs(players:GetPlayers()) do
        if v ~= localPlayer then
            spawn(function()
                self:create_esp(v)
            end)

            v.Changed:Connect(function(prop)
                self:update_esp_color(v)
            end)
        end
    end

    players.PlayerRemoving:Connect(function(plr)
        self:remove_esp(plr)
    end)
end

esp:init();

function _G.shutdown()
    esp.enabled = false;
    for i, v in pairs(esp.esp_table) do
        v.Name:Remove()
        v.Dist:Remove()
    end
    esp.esp_table = {}

    util.misc.destroyLoop("ESP_Update")

end