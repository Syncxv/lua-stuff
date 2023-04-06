esp_module = {}

if _G.getesp ~= nil then
    print("Destroying old esp")
    _G.getesp():destroy()
end

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
local objects_folder = game:GetService("Workspace").Players
local get_children = game.GetChildren
local find_first_child = game.FindFirstChild

esp_module.esp_core = {
    enabled = false,
    name = false,
    distance = false,
    chams = false,
    tracers = false,
    visible_check = false,
    max_distance = 300,
    text_color = Color3.new(1, 0, 0),
    chams_color = Color3.new(1, 0, 0),
    esp_table = {},
    chams_table = {}
}

function esp_module.esp_core:create_esp(player)
    local Name = Drawing.new("Text")
    Name.Text = tostring(player)
    Name.Color = self.text_color
    Name.Size = 15
    Name.Position = Vector2.new(0, 0)
    Name.Visible = false

    local Dist = Drawing.new("Text")
    Dist.Text = ""
    Dist.Color = self.text_color
    Dist.Size = 15
    Dist.Position = Vector2.new(0, 0)
    Dist.Visible = false

    local esp_instance = {
        Name = Name,
        Dist = Dist,
    }

    function esp_instance:Show(name, dist, p1, p2)
        self.Name.Text = name
        self.Name.Position = p1
        self.Name.Visible = esp_module.esp_core.name and true

        self.Dist.Text = dist
        self.Dist.Position = p2
        self.Dist.Visible = esp_module.esp_core.distance and true
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
            local dist: number = (currPos - tor.Position).magnitude
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

function esp_module.esp_core:create_chams(wsPlayer)
    local newChams = Instance.new("Highlight", coreGui)
    newChams.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    newChams.Adornee = wsPlayer
    newChams.Enabled = self.chams
    -- newChams.Parent = wsPlayer

    self.chams_table[wsPlayer] = {
        highlight = newChams,
        esp_object = wsPlayer
    }
end
function esp_module.esp_core:update_chams()
    for _, value in pairs(self.chams_table) do
        if self.visible_check and not util.misc:is_visible(camera, client, value.esp_object.Position, value.esp_object.Parent) then
            value.highlight.Enabled = false
            return
        end
        if value.esp_object ~= nil and value.esp_object.Parent.Name ~= client.TeamColor.Name then
            value.highlight.FillColor = self.chams_color
            value.highlight.FillTransparency = 1
            value.highlight.Enabled = true
        else
            value.highlight.Enabled = false
        end
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

    util.misc:runLoop("CHAMS_Update", function()
        if self.chams then
            self:update_chams()
        end
    end, runService.RenderStepped)

    for _, v in pairs(players:GetPlayers()) do
        if v ~= localPlayer then
            spawn(function()
                self:create_esp(v)
            end)
        end
    end

    for _, v in pairs(workspace.Players:GetChildren()) do
        for _, v2 in pairs(v:GetChildren()) do
            self:create_chams(v2)
        end
    end

    players.PlayerAdded:Connect(function(plr)
        self:create_esp(plr)
    end)

    players.PlayerRemoving:Connect(function(plr)
        self:remove_esp(plr)
    end)

    for i, team in pairs(workspace.Players:GetChildren()) do
        team.ChildAdded:Connect(function(child)
            self:create_chams(child)
        end)

        team.ChildRemoved:Connect(function(child)
            if self.chams_table[child] then
                self.chams_table[child].highlight:Destroy()
                self.chams_table[child] = nil
            end
        end)
    end
end

function esp_module.esp_core:destroy()
    for _, v in pairs(esp_module.esp_core.esp_table) do
        v:Destroy()
    end
    esp_module.esp_core.esp_table = {}
    for _, v in pairs(esp_module.esp_core.chams_table) do
        v.highlight:Destroy()
    end
    esp_module.esp_core.enabled = false;
    util.misc.destroyLoop("ESP_Update")
    util.misc.destroyLoop("CHAMS_Update")
end

function esp_module:gui_init(MainUI)
    local FirstPage = MainUI.AddPage("ESP")

    local FirstLabel = FirstPage.AddLabel("ESP")
    local ESPToggle = FirstPage.AddToggle("Enabled", self.esp_core.enabled, function(Value)
        self.esp_core.enabled = Value
    end)
    local ChamsToggle = FirstPage.AddToggle("Chams", self.esp_core.enabled, function(Value)
        self.esp_core.chams = Value
    end)
    local TracersToggle = FirstPage.AddToggle("Tracers", self.esp_core.enabled, function(Value)
        self.esp_core.tracers = Value
    end)
    local DistanceToggle = FirstPage.AddToggle("Show Distance", self.esp_core.enabled, function(Value)
        self.esp_core.distance = Value
    end)
    local NameToggle = FirstPage.AddToggle("Show Name", self.esp_core.enabled, function(Value)
        self.esp_core.name = Value
    end)
    local VisibleCheckToggle = FirstPage.AddToggle("Visible Check", self.esp_core.visible_check, function(Value)
        self.esp_core.visible_check = Value
    end)
    local MaxDistanceSlider = FirstPage.AddSlider("Max Distance", {Min = 0, Max = 2000, Def = self.esp_core.max_distance}, function(Value)
        self.esp_core.max_distance = Value
    end)
    local FirstPicker = FirstPage.AddColourPicker("ESP Color", self.esp_core.text_color, function(Value)
        self.esp_core.text_color = Value
        for _, v in pairs(self.esp_core.esp_table) do
            v:SetColor(Value)
        end
    end)

    local ChamsColor = FirstPage.AddColourPicker("Chams Color", self.esp_core.chams_color, function(Value)
        self.esp_core.chams_color = Value
        for _, v in pairs(self.esp_core.chams_table) do
            v.highlight.FillColor = Value
        end
    end)
end

function _G.getesp()
    return esp_module.esp_core
end

print(util.base64.decode("c3luLnJ1bl9vbl9hY3RvcihnZXRhY3RvcnMoKVsxXSwgW1sKCnByaW50KF9HLmdldGVzcCgpLmRlc3Ryb3koKSkKCl1dKQ=="))