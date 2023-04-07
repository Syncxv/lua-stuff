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

esp_module.esp_core = {
    enabled = false,
    name = false,
    distance = false,
    chams = false,
    tracers = false,
    text_visible_check = false,
    chams_visible_check = false,
    tracer_visible_check = false,
    max_distance = 300,
    text_color = Color3.new(1, 0, 0),
    chams_color = Color3.new(1, 0, 0),
    tracer_color = Color3.new(1, 0, 0),
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

    local Tracer = Drawing.new("Line")
    Tracer.From = Vector2.new(0,0)
    Tracer.To = Vector2.new(200,200)
    Tracer.Color = self.tracer_color
    Tracer.Thickness = 2
    Tracer.Transparency = 1
    Tracer.Visible = false

    local esp_instance = {
        Name = Name,
        Dist = Dist,
        Tracer = Tracer
    }

    function esp_instance:ShowAll(name, dist, p1, p2, p3)
        self.Name.Text = name
        self.Name.Position = p1
        self.Name.Visible = esp_module.esp_core.name and true

        self.Dist.Text = dist
        self.Dist.Position = p2
        self.Dist.Visible = esp_module.esp_core.distance and true

        local BottomCenter = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
        self.Tracer.From = BottomCenter
        self.Tracer.To = p3
        self.Tracer.Visible = esp_module.esp_core.tracers and true
    end

    function esp_instance:ShowText(name, dist, p1, p2)
        self.Name.Text = name
        self.Name.Position = p1
        self.Name.Visible = esp_module.esp_core.name and true

        self.Dist.Text = dist
        self.Dist.Position = p2
        self.Dist.Visible = esp_module.esp_core.distance and true
    end

    function esp_instance:ShowTracer(p2)
        local BottomCenter = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
        self.Tracer.From = BottomCenter
        self.Tracer.To = p2
        self.Tracer.Visible = esp_module.esp_core.tracers and true
    end
    
    function esp_instance:HideText()
        self.Name.Visible = false
        self.Dist.Visible = false
    end

    function esp_instance:HideTracer()
        self.Tracer.Visible = false
    end

    function esp_instance:HideAll()
        self.Name.Visible = false
        self.Dist.Visible = false
        self.Tracer.Visible = false
    end

    function esp_instance:SetColor(color)
        self.Name.Color = color
        self.Dist.Color = color
        --self.Tracer.Color = color
    end
    
    function esp_instance:Destroy()
        self:HideAll()
        self.Name:Remove()
        self.Dist:Remove()
        self.Tracer:Remove()
    end
    
    
    self.esp_table[player] = esp_instance
end
function esp_module.esp_core:remove_esp(plr)
    local t = self.esp_table[tostring(plr)];
    if t ~= nil then
        t:Destroy();
        self.esp_table[tostring(plr)] = nil
    end
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
        if not head then
            t:HideAll()
            return
        end
        
        local v3, on_screen = camera:WorldToScreenPoint(head.Position)
        local dist = (currPos - tor.Position).magnitude
        
        if not (on_screen and math.round(dist) <= self.max_distance and replicationObject.isAlive(entry)) then
            t:HideAll()
            return
        end
        
        local visible = util.misc:is_visible(camera, client, head.Position, body_parts.head.Parent)
        
        local name = tostring(player)
        local distance = string.format("%.0f", dist)
        local name_pos = Vector2.new(v3.X, v3.Y)
        local distance_pos = Vector2.new(v3.X, v3.Y + 15)
        local tracer_pos = Vector2.new(v3.X, v3.Y)
        
        -- This is so bad
        t:ShowAll(name, distance, name_pos, distance_pos, tracer_pos)
        
        if self.text_visible_check and not visible then
            t:HideText()
        end
        
        if self.tracer_visible_check and not visible then
            t:HideTracer()
        end
    else
        if t ~= nil then
            t:HideAll()
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
        if
        self.chams
        and self.enabled
        and value.esp_object.Parent.Name ~= client.TeamColor.Name
        then
            if self.chams_visible_check then
                value.highlight.DepthMode = Enum.HighlightDepthMode.Occluded
            else
                value.highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            end
            local vec3_position = value.esp_object.Head.Position
            local screen_position, on_screen = camera:WorldToScreenPoint(vec3_position)
            local distant_from_character = client:DistanceFromCharacter(vec3_position)
            if on_screen and math.round(distant_from_character) <= self.max_distance then
                value.highlight.Enabled = true
                value.highlight.FillColor = self.chams_color
                value.highlight.FillTransparency = 0.5
            else
                value.highlight.Enabled = false
            end
        else
            value.highlight.Enabled = false
        end
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
        self:update_chams()
    end, runService.RenderStepped)

    for _, v in pairs(players:GetPlayers()) do
        if v ~= localPlayer then
            spawn(function()
                self:create_esp(v)
            end)
        end
    end

    for i, team in pairs(workspace.Players:GetChildren()) do
		for i, player in pairs(team:GetChildren()) do
			self:create_chams(player)
		end
	end
    players.PlayerAdded:Connect(function(plr)
        self:create_esp(plr)
    end)

    players.PlayerRemoving:Connect(function(plr)
        self:remove_esp(plr)
    end)

    for i, team in pairs(workspace.Players:GetChildren()) do
        team.ChildAdded:Connect(function(wsPlayer)
            self:create_chams(wsPlayer)
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
    util.misc:destroyLoop("ESP_Update")
    util.misc:destroyLoop("CHAMS_Update")
    for _, v in pairs(esp_module.esp_core.esp_table) do
        v:Destroy()
    end
    esp_module.esp_core.esp_table = {}
    for _, v in pairs(esp_module.esp_core.chams_table) do
        v.highlight:Destroy()
    end
    esp_module.esp_core.enabled = false;
end

function esp_module:gui_init(MainUI)
    local ESPPage = MainUI.AddPage("ESP")

    local FirstLabel = ESPPage.AddLabel("ESP")
    local ESPToggle = ESPPage.AddToggle("Enabled", self.esp_core.enabled, function(Value)
        self.esp_core.enabled = Value
    end)
    local ChamsToggle = ESPPage.AddToggle("Chams", self.esp_core.enabled, function(Value)
        self.esp_core.chams = Value
    end)
    local TracersToggle = ESPPage.AddToggle("Tracers", self.esp_core.enabled, function(Value)
        self.esp_core.tracers = Value
    end)
    local DistanceToggle = ESPPage.AddToggle("Show Distance", self.esp_core.enabled, function(Value)
        self.esp_core.distance = Value
    end)
    local NameToggle = ESPPage.AddToggle("Show Name", self.esp_core.enabled, function(Value)
        self.esp_core.name = Value
    end)
    local TextVisibleCheckToggle = ESPPage.AddToggle("Text Visible Check", self.esp_core.text_visible_check, function(Value)
        self.esp_core.text_visible_check = Value
    end)
    local ChamsVisibleCheckToggle = ESPPage.AddToggle("Chams Visible Check", self.esp_core.chams_visible_check, function(Value)
        self.esp_core.chams_visible_check = Value
    end)
    local TracerVisibleCheckToggle = ESPPage.AddToggle("Tracer Visible Check", self.esp_core.tracer_visible_check, function(Value)
        self.esp_core.tracer_visible_check = Value
    end)
    local MaxDistanceSlider = ESPPage.AddSlider("Max Distance", {Min = 0, Max = 2000, Def = self.esp_core.max_distance}, function(Value)
        self.esp_core.max_distance = Value
    end)
    local TextColor = ESPPage.AddColourPicker("Text Color", self.esp_core.text_color, function(Value)
        self.esp_core.text_color = Value
        for _, v in pairs(self.esp_core.esp_table) do
            v:SetColor(Value)
        end
    end)

    local TracerColor = ESPPage.AddColourPicker("Tracer Color", self.esp_core.text_color, function(Value)
        self.esp_core.tracer_color = Value
        for _, v in pairs(self.esp_core.esp_table) do
            v.Tracer.Color = Value
        end
    end)

    local ChamsColor = ESPPage.AddColourPicker("Chams Color", self.esp_core.chams_color, function(Value)
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