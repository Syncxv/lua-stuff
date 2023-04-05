esp_module = {}

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

esp_module.esp_core = {enabled = true, max_distance = 300, visible_check = false, color = Color3.new(1, 0, 0), esp_table = {}}

function esp_module.esp_core:create_esp(player)
    local Name = Drawing.new("Text")
    Name.Text = tostring(player)
    Name.Color = self.color
    Name.Size = 15
    Name.Position = Vector2.new(0, 0)
    Name.Visible = false

    local Dist = Drawing.new("Text")
    Dist.Text = ""
    Dist.Color = self.color
    Dist.Size = 15
    Dist.Position = Vector2.new(0, 0)
    Dist.Visible = false

    local esp_instance = {
        Name = Name,
        Dist = Dist
    }

    function esp_instance:Show(name, dist, p1, p2)
        self.Name.Text = name
        self.Name.Position = p1
        self.Name.Visible = true

        self.Dist.Text = dist
        self.Dist.Position = p2
        self.Dist.Visible = true
    end
    
    function esp_instance:Hide()
        self.Name.Visible = false
        self.Dist.Visible = false
    end

    function esp_instance:SetColor(color)
        self.Name.Color = color
        self.Dist.Color = color
    end
    
    function esp_instance:Destroy()
        self:Hide()
        self.Name:Remove()
        self.Dist:Remove()
    end
    
    
    self.esp_table[player] = esp_instance
end

function esp_module.esp_core:update_esp(player)
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
            t:Hide();
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
            local v3, vis = camera:WorldToScreenPoint(head.Position)
            local dist = (currPos - tor.Position).magnitude
            if (vis and math.round(dist) <= self.max_distance and replicationObject.isAlive(entry))
            then
                if self.visible_check and not util.misc:is_visible(camera, client, head.Position, body_parts.head.Parent) then
                    t:Hide()
                    return
                end
                t:Show(tostring(player), string.format("%.0f", dist), Vector2.new(v3.X, v3.Y), Vector2.new(v3.X, v3.Y + 15))
            else
                t:Hide()
            end
        end
    else
        if t ~= nil then
            t:Hide()
        end
    end
    end)
    if not success then
        print(err)
    end
end
function esp_module.esp_core:remove_esp(plr)
    local t = self.esp_table[tostring(plr)];
    if t ~= nil then
        t:Destroy();
        self.esp_table[tostring(plr)] = nil
    end
end

function esp_module.esp_core:init() 
    util.misc:runLoop("ESP_Update", function()
        if self.enabled then
            for i, v in pairs(players:GetPlayers()) do
                self:update_esp(v)
            end
        end
    end, runService.RenderStepped)

    for _, v in pairs(players:GetPlayers()) do
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

function esp_module.esp_core:destroy()
    for _, v in pairs(esp_module.esp_core.esp_table) do
        v:Destroy()
    end
    esp_module.esp_core.esp_table = {}
    esp_module.esp_core.enabled = false;
    util.misc.destroyLoop("ESP_Update")
end

function esp_module:gui_init(MainUI)
    local FirstPage = MainUI.AddPage("ESP")

    local FirstLabel = FirstPage.AddLabel("ESP")
    local ESPToggle = FirstPage.AddToggle("Enabled", self.esp_core.enabled, function(Value)
        self.esp_core.enabled = Value
    end)
    local VisibleCheckToggle = FirstPage.AddToggle("Visible Check", self.esp_core.visible_check, function(Value)
        self.esp_core.visible_check = Value
    end)
    local MaxDistanceSlider = FirstPage.AddSlider("Max Distance", {Min = 0, Max = 2000, Def = self.esp_core.max_distance}, function(Value)
        self.esp_core.max_distance = Value
    end)
    local FirstPicker = FirstPage.AddColourPicker("ESP Color", self.esp_core.color, function(Value)
        self.esp_core.color = Value
        for _, v in pairs(self.esp_core.esp_table) do
            v:SetColor(Value)
        end
    end)
end

function _G.getesp()
    return esp_module.esp_core
end

print(util.base64.decode("c3luLnJ1bl9vbl9hY3RvcihnZXRhY3RvcnMoKVsxXSwgW1sKCnByaW50KF9HLmdldGVzcCgpLmRlc3Ryb3koKSkKCl1dKQ=="))