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
local coreGui = game:GetService("CoreGui")

local esp = {enabled = true, max_distance = 300, walls = false, esp_table = {}}

function esp:create_esp(player)

        local Name = Drawing.new("Text")
        Name.Text = tostring(player)
        Name.Color = Color3.new(1, 0, 0)
        Name.Size = 15
        Name.Position = Vector2.new(0, 0)
        Name.Visible = false

        local Dist = Drawing.new("Text")
        Dist.Text = ""
        Dist.Color = Color3.new(1, 0, 0)
        Dist.Size = 15
        Dist.Position = Vector2.new(0, 0)
        Dist.Visible = false
        self.esp_table[player] = {["Name"] = Name, ["Dist"] = Dist, ["Highlight"] = Instance.new("Highlight", coreGui),}
    
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
            local dist = (currPos - tor.Position).magnitude
            print(math.round(dist), self.max_distance, math.round(dist) <= self.max_distance)
            if vis and math.round(dist) <= self.max_distance and replicationObject.isAlive(entry) then
                t.Name.Text = tostring(player)
                t.Name.Position = Vector2.new(v2.X, v2.Y)
                t.Name.Visible = true
                
                t.Dist.Position = Vector2.new(v2.X, v2.Y + 15)
                t.Dist.Visible = true
                t.Dist.Text = string.format("%.0f", dist)

                t.Highlight.FillColor =
					Color3.fromHSV(math.clamp(dist / 5, 0, 125) / 255, 0.75, 1)
				t.Highlight.FillTransparency = 1
                t.Highlight.Enabled = true
            else
                t.Name.Visible = false
                t.Dist.Visible = false
                t.Highlight.FillTransparency = 1
                t.Highlight.Enabled = false
            end
        end
    else
        if t ~= nil then
            t.Name.Visible = false
            t.Dist.Visible = false
            t.Highlight.FillTransparency = 1
            t.Highlight.Enabled = false
        end
    end
    end)
    if not success then
        print(err)
    end
end
function esp:remove_esp(plr)
    local t = self.esp_table[tostring(plr)];
    if t ~= nil then
        for i, v in next, t do
            if type(v.Remove) == "function" then
                v:Remove()
            elseif type(v.Destroy) == "function" then
                v:Destroy()
            end
        end

        self.esp_table[tostring(plr)] = nil
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
        end
    end

    players.PlayerAdded:connect(function(plr)
        self:create_esp(plr)
    end)

    players.PlayerRemoving:Connect(function(plr)
        self:remove_esp(plr)
    end)
end

function esp.destroy()
    for i, v in pairs(esp.esp_table) do
        for i2, v2 in pairs(v) do
            if type(v2.Remove) == "function" then
                v2:Remove()
            elseif type(v2.Destroy) == "function" then
                v2:Destroy()
            end
        end
    end
    esp.esp_table = {}
    esp.enabled = false;
    util.misc.destroyLoop("ESP_Update")
end

esp:init();

function _G.getesp()
    return esp
end

print(util.base64.decode("c3luLnJ1bl9vbl9hY3RvcihnZXRhY3RvcnMoKVsxXSwgW1sKCnByaW50KF9HLmdldGVzcCgpLmRlc3Ryb3koKSkKCl1dKQ=="))