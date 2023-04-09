
    -- collection of pf scripts in one ui
	-- credits: https://github.com/Syncxv/lua-stuff/blob/master/README.md
    -- 198ef1a180ee226497eb71de10f3696fccaabf513662da6efd5c7388efc2f152

    syn.run_on_actor(getactors()[1], [[
        if not game:IsLoaded() then
    game.Loaded:Wait()
end


local esp = {}
do
esp_module = {
    enabled = false,
    name = false,
    distance = false,
    chams = false,
    tracers = false,
    text_visible_check = false,
    chams_visible_check = false,
    tracer_visible_check = false,
    max_distance = 1000,
    text_color = Color3.new(1, 0, 0),
    chams_color = Color3.new(1, 0, 0),
    tracer_color = Color3.new(1, 0, 0),
    esp_table = {},
    chams_table = {}
}

if _G.getesp ~= nil then
    print("Destroying old esp")
    _G.getesp():destroy()
end

local util = {}
do
util_module = {}

util_module.color = {}
do
color_module = {}

function color_module.getTeamColor(p, plr)
    if p.Team == plr.Team then return Color3.new(0, 1, 0) end

    return Color3.new(1, 0, 0)
end



util_module.color = color_module
end
util_module.misc = {}
do
misc_module = {
	loops = {}
}

function misc_module:runLoop(name, callback, waitt, ...) -- This is a function that runs a loop with a callback.
    if self.loops[name] == nil then
        if callback ~= nil then
            self:createLoop(name, callback, waitt, ...)
        end
    end

    self.loops[name].Running = true
    local succ, out = coroutine.resume(self.loops[name].Loop)
    if not succ then
        warn("Loop: " .. tostring(name) .. " ERROR: " .. tostring(out))
    end
end

function misc_module:createLoop(name, callback, waitt, ...)
    if self.loops[name] ~= nil then return end

		self.loops[name] = { }
		self.loops[name].Running = false
		self.loops[name].Destroy = false
		self.loops[name].Loop = coroutine.create(function(...)
			while true do
				if self.loops[name].Running then
					callback(...)
				end

				if self.loops[name].Destroy then
					break
				end

				if type(wait) == "userdata" then
					waitt:wait()
				else
					wait(waitt)
				end
			end
		end)
end

function misc_module:stopLoop(name) -- This is a function that stops a loop.
    if self.loops[name] ~= nil then
        self.loops[name].Running = false
    end
end
function misc_module:destroyLoop(name) -- This is a function that destroies a loop.
    if self.loops[name] ~= nil then
        self.loops[name].Destroy = false
    end
end


function misc_module:get_current_pos(client)
	if client.Character then 
    	return client.Character.HumanoidRootPart.Position
	end
end
function misc_module:is_visible(camera, client, p, ...)
    return #camera:GetPartsObscuringTarget({ p }, { camera, client.Character, workspace.Ignore, ... }) == 0
end


util_module.misc = misc_module
end
util_module.base64 = {}
do
local base64_module = {}

local extract = function( v, from, width )
    local w = 0
    local flag = 2^from
    for i = 0, width-1 do
        local flag2 = flag + flag
        if v % flag2 >= flag then
            w = w + 2^i
        end
        flag = flag2
    end
    return w
end


function base64_module.makeencoder( s62, s63, spad )
	local encoder = {}
	for b64code, char in pairs{[0]='A','B','C','D','E','F','G','H','I','J',
		'K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y',
		'Z','a','b','c','d','e','f','g','h','i','j','k','l','m','n',
		'o','p','q','r','s','t','u','v','w','x','y','z','0','1','2',
		'3','4','5','6','7','8','9',s62 or '+',s63 or'/',spad or'='} do
		encoder[b64code] = char:byte()
	end
	return encoder
end

function base64_module.makedecoder( s62, s63, spad )
	local decoder = {}
	for b64code, charcode in pairs( base64_module.makeencoder( s62, s63, spad )) do
		decoder[charcode] = b64code
	end
	return decoder
end

local DEFAULT_ENCODER = base64_module.makeencoder()
local DEFAULT_DECODER = base64_module.makedecoder()

local char, concat = string.char, table.concat

function base64_module.encode( str, encoder, usecaching )
	encoder = encoder or DEFAULT_ENCODER
	local t, k, n = {}, 1, #str
	local lastn = n % 3
	local cache = {}
	for i = 1, n-lastn, 3 do
		local a, b, c = str:byte( i, i+2 )
		local v = a*0x10000 + b*0x100 + c
		local s
		if usecaching then
			s = cache[v]
			if not s then
				s = char(encoder[extract(v,18,6)], encoder[extract(v,12,6)], encoder[extract(v,6,6)], encoder[extract(v,0,6)])
				cache[v] = s
			end
		else
			s = char(encoder[extract(v,18,6)], encoder[extract(v,12,6)], encoder[extract(v,6,6)], encoder[extract(v,0,6)])
		end
		t[k] = s
		k = k + 1
	end
	if lastn == 2 then
		local a, b = str:byte( n-1, n )
		local v = a*0x10000 + b*0x100
		t[k] = char(encoder[extract(v,18,6)], encoder[extract(v,12,6)], encoder[extract(v,6,6)], encoder[64])
	elseif lastn == 1 then
		local v = str:byte( n )*0x10000
		t[k] = char(encoder[extract(v,18,6)], encoder[extract(v,12,6)], encoder[64], encoder[64])
	end
	return concat( t )
end

function base64_module.decode( b64, decoder, usecaching )
	decoder = decoder or DEFAULT_DECODER
	local pattern = '[^%w%+%/%=]'
	if decoder then
		local s62, s63
		for charcode, b64code in pairs( decoder ) do
			if b64code == 62 then s62 = charcode
			elseif b64code == 63 then s63 = charcode
			end
		end
		pattern = ('[^%%w%%%s%%%s%%=]'):format( char(s62), char(s63) )
	end
	b64 = b64:gsub( pattern, '' )
	local cache = usecaching and {}
	local t, k = {}, 1
	local n = #b64
	local padding = b64:sub(-2) == '==' and 2 or b64:sub(-1) == '=' and 1 or 0
	for i = 1, padding > 0 and n-4 or n, 4 do
		local a, b, c, d = b64:byte( i, i+3 )
		local s
		if usecaching then
			local v0 = a*0x1000000 + b*0x10000 + c*0x100 + d
			s = cache[v0]
			if not s then
				local v = decoder[a]*0x40000 + decoder[b]*0x1000 + decoder[c]*0x40 + decoder[d]
				s = char( extract(v,16,8), extract(v,8,8), extract(v,0,8))
				cache[v0] = s
			end
		else
			local v = decoder[a]*0x40000 + decoder[b]*0x1000 + decoder[c]*0x40 + decoder[d]
			s = char( extract(v,16,8), extract(v,8,8), extract(v,0,8))
		end
		t[k] = s
		k = k + 1
	end
	if padding == 1 then
		local a, b, c = b64:byte( n-3, n-1 )
		local v = decoder[a]*0x40000 + decoder[b]*0x1000 + decoder[c]*0x40
		t[k] = char( extract(v,16,8), extract(v,8,8))
	elseif padding == 2 then
		local a, b = b64:byte( n-3, n-2 )
		local v = decoder[a]*0x40000 + decoder[b]*0x1000
		t[k] = char( extract(v,16,8))
	end
	return concat( t )
end



util_module.base64 = base64_module
end
util_module.keycodes = {}
do
keycodes_module = {}

keycodes_module.Keys = {
    LAlt = Enum.KeyCode.LeftAlt,
    RAlt = Enum.KeyCode.RightAlt,
    LShift = Enum.KeyCode.LeftShift,
    RShift = Enum.KeyCode.RightShift,
    LControl = Enum.KeyCode.LeftControl,
    RControl = Enum.KeyCode.RightControl,
    Tab = Enum.KeyCode.Tab,
    CapsLock = Enum.KeyCode.CapsLock,
    Backspace = Enum.KeyCode.Backspace,
    Delete = Enum.KeyCode.Delete,
    Insert = Enum.KeyCode.Insert,
    PageUp = Enum.KeyCode.PageUp,
    PageDown = Enum.KeyCode.PageDown,
    Home = Enum.KeyCode.Home,
    End = Enum.KeyCode.End,
    NumLock = Enum.KeyCode.NumLock,
    ScrollLock = Enum.KeyCode.ScrollLock,
    RightBracket = Enum.KeyCode.RightBracket,
    LeftBracket = Enum.KeyCode.LeftBracket,
    F1 = Enum.KeyCode.F1,
    F2 = Enum.KeyCode.F2,
    F3 = Enum.KeyCode.F3,
    F4 = Enum.KeyCode.F4,
    F5 = Enum.KeyCode.F5,
    F6 = Enum.KeyCode.F6,
    F7 = Enum.KeyCode.F7,
    F8 = Enum.KeyCode.F8,
    F9 = Enum.KeyCode.F9,
    F10 = Enum.KeyCode.F10,
    F11 = Enum.KeyCode.F11,
    F12 = Enum.KeyCode.F12,
}

keycodes_module.KeyNames = {}

for key, keyCode in pairs(keycodes_module.Keys) do
    table.insert(keycodes_module.KeyNames, key)
end

util_module.keycodes = keycodes_module
end

util = util_module
end

local camera = workspace.CurrentCamera

local shared = getrenv().shared
local replicationObject = shared.require("ReplicationObject")
local replicationInterface = shared.require("ReplicationInterface")

local runService = game:GetService("RunService")
local players = game:GetService("Players")
local client = game:GetService("Players").LocalPlayer
local coreGui = game:GetService("CoreGui")



-- Normal ESP
function esp_module:create_esp(player)
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
        self.Name.Visible = esp_module.name and true

        self.Dist.Text = dist
        self.Dist.Position = p2
        self.Dist.Visible = esp_module.distance and true

        local BottomCenter = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
        self.Tracer.From = BottomCenter
        self.Tracer.To = p3
        self.Tracer.Visible = esp_module.tracers and true
    end

    function esp_instance:ShowText(name, dist, p1, p2)
        self.Name.Text = name
        self.Name.Position = p1
        self.Name.Visible = esp_module.name and true

        self.Dist.Text = dist
        self.Dist.Position = p2
        self.Dist.Visible = esp_module.distance and true
    end

    function esp_instance:ShowTracer(p2)
        local BottomCenter = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
        self.Tracer.From = BottomCenter
        self.Tracer.To = p2
        self.Tracer.Visible = esp_module.tracers and true
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
function esp_module:remove_esp(plr)
    local t = self.esp_table[plr];
    if t ~= nil then
        t:Destroy();
        self.esp_table[plr] = nil
    end
end


function esp_module:update_esp(player)
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
            t:HideAll();
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
        
        local head_pos, on_screen = camera:WorldToScreenPoint(head.Position)
        local dist = (currPos - tor.Position).magnitude
        
        if not (on_screen and math.round(dist) <= self.max_distance and replicationObject.isAlive(entry)) then
            t:HideAll()
            return
        end
        
        local visible = util.misc:is_visible(camera, client, head.Position, body_parts.head.Parent)
        
        local name = tostring(player)
        local distance = string.format("%.0f", dist)
        local name_pos = Vector2.new(head_pos.X, head_pos.Y)
        local distance_pos = Vector2.new(head_pos.X, head_pos.Y + 15)
        local tracer_pos = Vector2.new(head_pos.X, head_pos.Y + 30)
        
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

-- Chams
function esp_module:create_chams(wsPlayer)
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

function esp_module:remove_chams(wsPlayer)
    local t = self.chams_table[wsPlayer]
    if t ~= nil then
        t.highlight:Destroy()
        self.chams_table[wsPlayer] = nil
    end
end
function esp_module:update_chams()
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


function esp_module:init()
    util.misc:runLoop("ESP_Update", function()
        if self.enabled then
            for _, v in pairs(players:GetPlayers()) do
                self:update_esp(v)
            end
        end
    end, runService.RenderStepped)

    util.misc:runLoop("CHAMS_Update", function()
        self:update_chams()
    end, runService.RenderStepped)

    for _, v in pairs(players:GetPlayers()) do
        if v ~= client then
            spawn(function()
                self:create_esp(v)
            end)
        end
    end

    for _, team in pairs(workspace.Players:GetChildren()) do
		for _, player in pairs(team:GetChildren()) do
			self:create_chams(player)
		end
	end
    players.PlayerAdded:Connect(function(plr)
        self:create_esp(plr)
    end)

    players.PlayerRemoving:Connect(function(plr)
        self:remove_esp(plr)
    end)

    for _, team in pairs(workspace.Players:GetChildren()) do
        team.ChildAdded:Connect(function(wsPlayer)
            self:create_chams(wsPlayer)
        end)

        team.ChildRemoved:Connect(function(child)
            self:remove_chams(child)
        end)
    end
end

function esp_module:destroy()
    util.misc:destroyLoop("ESP_Update")
    util.misc:destroyLoop("CHAMS_Update")
    for _, v in pairs(esp_module.esp_table) do
        v:Destroy()
    end
    esp_module.esp_table = {}
    for _, v in pairs(esp_module.chams_table) do
        v.highlight:Destroy()
    end
    esp_module.enabled = false;
end

function esp_module:gui_init(MainUI)
    local ESPPage = MainUI.AddPage("ESP")

    ESPPage.AddLabel("ESP")
    ESPPage.AddToggle("Enabled", self.enabled, function(Value)
        self.enabled = Value
    end)
    ESPPage.AddToggle("Chams", self.enabled, function(Value)
        self.chams = Value
    end)
    ESPPage.AddToggle("Tracers", self.enabled, function(Value)
        self.tracers = Value
    end)
    ESPPage.AddToggle("Show Distance", self.enabled, function(Value)
        self.distance = Value
    end)
    ESPPage.AddToggle("Show Name", self.enabled, function(Value)
        self.name = Value
    end)
    ESPPage.AddToggle("Text Visible Check", self.text_visible_check, function(Value)
        self.text_visible_check = Value
    end)
    ESPPage.AddToggle("Chams Visible Check", self.chams_visible_check, function(Value)
        self.chams_visible_check = Value
    end)
    ESPPage.AddToggle("Tracer Visible Check", self.tracer_visible_check, function(Value)
        self.tracer_visible_check = Value
    end)
    ESPPage.AddSlider("Max Distance", {Min = 0, Max = 2000, Def = self.max_distance}, function(Value)
        self.max_distance = Value
    end)
    ESPPage.AddColourPicker("Text Color", self.text_color, function(Value)
        self.text_color = Value
        for _, v in pairs(self.esp_table) do
            v:SetColor(Value)
        end
    end)

    ESPPage.AddColourPicker("Tracer Color", self.text_color, function(Value)
        self.tracer_color = Value
        for _, v in pairs(self.esp_table) do
            v.Tracer.Color = Value
        end
    end)

    ESPPage.AddColourPicker("Chams Color", self.chams_color, function(Value)
        self.chams_color = Value
        for _, v in pairs(self.chams_table) do
            v.highlight.FillColor = Value
        end
    end)
end

function _G.getesp()
    return esp_module
end

esp = esp_module
end
local hitbox = {}
do
hitbox_module = {}
--made by The3Bakers#4565
--discord link https://discord.gg/vQQqcgBWCG
local util = util_module

local runService = game:GetService("RunService")
local function createText(bruh, position)
    local text = Drawing.new("Text");

    text.Visible = true
    text.Transparency = 1
    text.ZIndex = 1
    text.Color = Color3.fromRGB(255, 255, 255);
    text.Position = position
    text.Text = bruh;
    return text
end

local HitBoxes = {} --hitbex list used for later
--oringal hitboxes used to disable the script
local OriginalHB = function()
    local a = { ["Left Leg"] = { radius = 0.1, precedence = 4, size = Vector3.new(1, 2, 1) },
        ["Right Arm"] = { radius = 0.1, precedence = 3, size = Vector3.new(1, 2, 1) },
        Head = { radius = 0.1, precedence = 1, size = Vector3.new(1, 1, 1) },
        Torso = { radius = 0.1, precedence = 2, size = Vector3.new(2, 2, 1) },
        ["Right Leg"] = { radius = 0.1, precedence = 4, size = Vector3.new(1, 2, 1) },
        ["Left Arm"] = { radius = 0.1, precedence = 3, size = Vector3.new(1, 2, 1) } }
    return a
end
for _, v in pairs(getgc(true)) do
    if type(v) == "table" then
        for i, c in pairs(v) do
            if i == "Head" and type(c) == "table" and c.size then
                HitBoxes[#HitBoxes + 1] = v --we have hitbox size for 2 teams ?!?!?! wtf pf
            end
        end
    end
end
local GetMaterials = function() --get new table with all materials
    local Matierals = { "Asphalt", "Basalt", "Brick", "Cobblestone", "Concrete", "Corroded Metal", "Cracked Lava",
        "Diamond Plate", "Fabric", "Foil", "ForceField", "Glacier", "Glass", "Granite", "Grass", "Ground", "Ice",
        "Leafy Grass", "Limestone", "Marble", "Metal", "Mud", "Neon", "Pavement", "Pebble", "Plastic", "Rock", "Salt",
        "Sand", "Sandstone", "Slate", "Smooth Plastic", "Snow", "Wood", "Wood Planks" }
    return Matierals
end
local GetR6Parts = function(all) --get table with r6 parts
    local Parts
    if all then
        Parts = { "Random", "All", "Head", "Torso", "Right Arm", "Left Arm", "Right Leg", "Left Leg" }
    else
        Parts = { "Head", "Torso", "Right Arm", "Left Arm", "Right Leg", "Left Leg" }
    end
    return Parts
end
local UpdateHB = function(target, size) --set size for hitbox
    for _, v in pairs(HitBoxes) do
        v[target].size = Vector3.new(size, size, size)
        v[target].radius = size
    end
end
local ResetHB = function() --set all hitboxes to oringal sizes
    for i, v in pairs(HitBoxes) do
        for i2, v2 in pairs(v) do
            for i3 in pairs(v2) do
                HitBoxes[i][i2][i3] = OriginalHB()[i2][i3]
            end
        end
    end
end
local GetEnemys = function() --simple ass get enemys
    local players = {}
    local characters = {}
    local enemyteam
    for _, v in pairs(game.Players:GetChildren()) do
        if v.Team ~= game.Players.LocalPlayer.Team then
            enemyteam = tostring(v.TeamColor)
            players[#players + 1] = v
        end
    end
    if not enemyteam then
        enemyteam = "Bright orange"
        if game.Players.LocalPlayer.Team.Name == "Ghosts" then
            enemyteam = "Bright blue"
        end
    end
    for _, v in pairs(game.Workspace.Players[enemyteam]:GetChildren()) do
        characters[#characters + 1] = v
    end
    return { characters, players }
end
local Options = { --optinos folder (dont worry u dont have to set these we have a ui now)
    Enabled = false,
    Target = { "Head" },
    Size = 7,
    Color = Color3.new(1, 0, 0),
    Material = "Asphalt",
    Transparency = 0.5,
    Show = false,
    Key = util.keycodes.Keys.LAlt
}

function hitbox_module:init()
    local margin = 20;
    local screenWidth = game.Players.LocalPlayer:GetMouse().ViewSizeX
    local TargetText = createText(Options.Target[1], Vector2.new(screenWidth - 50, 0 * margin))
    local SizeText = createText(tostring(Options.Size), Vector2.new(screenWidth - 50, 1 * margin))
    local TransText = createText(tostring(Options.Transparency), Vector2.new(screenWidth - 50, 2 * margin))
    game.RunService.RenderStepped:Connect(function()
        if Options.Enabled and Options.Show then 
            TargetText.Visible = true
            SizeText.Visible = true
            SizeText.Text = tostring(Options.Size)
            TransText.Visible = true
            TransText.Text = tostring(Options.Transparency)
            for _, v in pairs(GetEnemys()[1]) do --in every enemy character
                for _, c in pairs(Options.Target) do --for every part selected (mainly used for all)
                    local cham = Instance.new("Part") --add part
                    cham.Transparency = 1 - Options.Transparency --set up transparency
                    cham.Size = Vector3.new(Options.Size, Options.Size, Options.Size) --set up size
                    cham.Color = Options.Color --set up color
                    cham.Material = Options.Material --set up material
                    cham.CanCollide = false --we dont wanna stand on enemy O_o
                    cham.CFrame = v[c].CFrame --set the part to the part we want (makes scince shut up)
                    cham.Parent = v[c] --wecan use ingoremisc etc but we are lazy
                    coroutine.wrap(function()
                        game.RunService.RenderStepped:Wait()
                        cham:Destroy() --destroy after a frame because we make new part on frame
                    end)()
                end
            end
        else
            TargetText.Visible = false
            SizeText.Visible = false
            TransText.Visible = false
        end
    end)

    

    local uis = game:GetService("UserInputService")

    uis.InputBegan:Connect(function(input)
        if uis:GetFocusedTextBox() then
            return -- make sure player's not chatting!
        end
    
        if input.KeyCode == Options.Key then
            if Options.Target[1] == "Head" then
                print("Setting target to torso")
                Options.Target = { "Torso" }
            else
                print("Setting target to Head")
                Options.Target = { "Head" }
            end
    
            TargetText.Text = Options.Target[1]
    
            if Options.Enabled then
                ResetHB()
                for _, v in pairs(Options.Target) do
                    UpdateHB(v, Options.Size)
                end
            end
    
            -- TargetDropDown:Refresh("Target", findIndex(GetR6Parts(true), Options.Target[1]), targetDropDownCallback)
            print("Final = ", Options.Target[1])
        end
    end)
end
--epic coasting ui lib
function hitbox_module:gui_init(MainUI)
        

    local MainSection = MainUI.AddPage("Hit Box")
    MainSection.AddToggle("Enabled", Options.Enabled, function(x)
        Options.Enabled = x
        ResetHB() --always reset hb size even if we enable it
        if x then
            for _, v in pairs(Options.Target) do
                UpdateHB(v, Options.Size) --update hb size
            end
        end
    end)
    MainSection.AddToggle("Show", Options.Show, function(x)
        Options.Show = x
    end)
    
    local targetDropDownCallback = function(x)
        if x == "All" then
            Options.Target = GetR6Parts() --if we select all we get every part from the r6 table
        else
            Options.Target = { x } --keep part inside table
        end
        if Options.Enabled then
            ResetHB()
            for _, v in pairs(Options.Target) do
                UpdateHB(v, Options.Size)
            end
        end
    end
    MainSection.AddColourPicker("Color", Options.Color, function(x)
        Options.Color = x
    end)
    MainSection.AddSlider("Size",{Min = 1, Max = 15, Def = Options.Size}, function(x)
        Options.Size = x
        if Options.Enabled then
            ResetHB()
            for _, v in pairs(Options.Target) do
                UpdateHB(v, Options.Size)
            end
        end
    end)
    MainSection.AddSlider("Transparency", {Min = 0, Max = 100, Def = Options.Transparency * 100}, function(x)
        Options.Transparency = x / 100
    end)
    local TargetDropDown = MainSection.AddDropdown("Target", GetR6Parts(true), targetDropDownCallback)
    MainSection.AddDropdown("Matieral", GetMaterials(), 1, function(x)
        Options.Material = x
    end)
    MainSection.AddDropdown("Toggle Key", util.keycodes.KeyNames, function(x)
        Options.Key = util.keycodes.Keys[x]
    end)
end

hitbox = hitbox_module
end
local aimbot = {}
do
aimbot_module = {}


if not getgenv or not mousemoverel then
    game:GetService("Players").LocalPlayer:Kick("Your exploit is not supported!")
end

local util = util_module

local id = "198ef1a180ee226497eb71de10f3696fccaabf513662da6efd5c7388efc2f152" .. math.random(1, 100000000)
local AIMBOT_SETTINGS = {
    id = id,
    Enabled = false,
    Smoothness = 2,
    FOV = 150,
    ShowFOV = false,
    VisibleCheck = false,
    PredictMovement = false,
    PredictBulletDrop = false,
    BulletDropToggleKey = util.keycodes.Keys.LAlt,
    Key = util.keycodes.Keys.RightBracket
}

-- services
local players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- variables
local client = game:GetService("Players").LocalPlayer;
local shared = getrenv().shared
local camera = workspace.CurrentCamera
local mouseLocation = UserInputService.GetMouseLocation
local WorldToViewportPoint = camera.WorldToViewportPoint





-- modules
local replicationObject = shared.require("ReplicationObject")
local replicationInterface = shared.require("ReplicationInterface")
local publicSettings = shared.require("PublicSettings");
local physics = shared.require("physics");
local cameraInterface = shared.require("CameraInterface");
local gameClock = shared.require("GameClock")

local firearmObject = shared.require("FirearmObject")

if (_G.oldFirearmObject == nil) then
    _G.oldFirearmObject = firearmObject.new
end

-- only works for the first weapon XD
-- ill figure something out soon (maybe)
firearmObject.new = function(...)
    -- print(p1, p2);
    local res = _G.oldFirearmObject(...);

    local args = { ... }
    if args[1] == 1 then
        print("new weapon" .. args[2])

        _G.firearmObject = res;
    end

    return res;
end;


--ui stuff


-- local AimPoint = Drawing.new("Circle")
-- AimPoint.Thickness = 2
-- AimPoint.NumSides = 12
-- AimPoint.Radius = 2
-- AimPoint.Filled = true
-- AimPoint.Transparency = 1
-- AimPoint.Color = Color3.new(math.random(), math.random(), math.random())
-- AimPoint.Visible = false

local circle = Drawing.new("Circle")
circle.Thickness = 2
circle.NumSides = 12
circle.Radius = 350
circle.Filled = false
circle.Transparency = 1
circle.Color = Color3.new(math.random(), math.random(), math.random())
circle.Visible = false
-- functions

local function GetDistance(to, from)
    local deltaX = to.X - from.X;
    local deltaY = to.Y - from.Y;
    local deltaZ = to.Z - from.Z;

    return math.sqrt(deltaX * deltaX + deltaY * deltaY + deltaZ * deltaZ);
end

local function isAlive(entry)
    return replicationObject.isAlive(entry)
end

local function isVisible(p, ...)
    if not AIMBOT_SETTINGS.VisibleCheck then
        return true
    end

    return #camera:GetPartsObscuringTarget({ p }, { camera, client.Character, workspace.Ignore, ... }) == 0
end

local function get_bal_pos(player)
    local pos = nil;
    local trajectory = nil;
    local activeCamera = cameraInterface.getActiveCamera("MainCamera")

    local cameraPosition = activeCamera:getCFrame().p
    local playerPosition, isPlayerPositionValid = replicationInterface.getEntry(player):getPosition()

    if isPlayerPositionValid then
        trajectory = physics.trajectory(cameraPosition, publicSettings.bulletAcceleration, playerPosition,
        _G.firearmObject:getWeaponStat("bulletspeed"))
    end
    -- for i,v in pairs(v13) do print(i) end
    if trajectory then
        local hehe = cameraPosition + trajectory
        -- print("BAL POS REAL = ", hehe)
        pos = camera:WorldToViewportPoint(hehe)
    end


    return pos
end

local function get_current_pos()
    if client.Character == nil then
        return nil
    end
    return client.Character.HumanoidRootPart.Position
end

local function get_prediction_pos(entry, character)
    -- local activeCamera = CameraInterface.getActiveCamera("MainCamera")

    local speed = _G.firearmObject:getWeaponStat("bulletspeed")

    local cFrame = entry._smoothReplication:getFrame(gameClock.getTime())
    local TargetVelocity = cFrame.velocity

    local TargetLocation = character:getCharacterHash().head.Position

    local CurrentPosition = get_current_pos();

    if CurrentPosition == nil then
        return nil
    end

    local Distance = GetDistance(CurrentPosition, TargetLocation);

    -- local minDistance = 10 -- set a minimum distance value
    -- if Distance < minDistance then
    --     print("close range is inaccurate and will be skipped")
    --     return CurrentCamera:WorldToScreenPoint(TargetLocation) -- prediction is not accurate for short distances
    -- end

    local TravelTime = Distance / speed;

    local PredictedLocation = TargetLocation + TargetVelocity * TravelTime
    -- print("\n\n\n------------", "\n\n\n", "TravelTime = ", TravelTime, "\n\n\n", "TARGET VELOCITY = ", TargetVelocity,
    -- "\n\n\n", "PREDICTED LOCATION = ", PredictedLocation, "\n\n\n", "CURRENT LOCATION = ", CurrentPosition,
    -- "\n\n\n------------\n\n\n")

    return camera:WorldToScreenPoint(PredictedLocation)
end



-- local max_distance = 2000  -- maximum distance for bullet drop compensation
-- local min_distance = 50  -- minimum distance for bullet drop compensation
-- local max_bullet_drop = 50  -- maximum bullet drop compensation in pixels
-- local min_bullet_drop = 0  -- minimum bullet drop compensation in pixels

-- local function lerp(a, b, t)
--     return a + (b - a) * t
-- end
local function get_closest(fov)
    local targetPos = nil
    local magnitude = fov or math.huge
    for _, player in pairs(players:GetPlayers()) do
        if player == client or player.Team == client.Team then
            continue
        end

        local entry = replicationInterface.getEntry(player)
        local character = entry and replicationObject.getThirdPersonObject(entry)

        if character and isAlive(entry) then
            local body_parts = character:getCharacterHash()

            local screen_pos, on_screen = WorldToViewportPoint(camera, body_parts.head.Position)
            local screen_pos_2D = Vector2.new(screen_pos.X, screen_pos.Y)
            local new_magnitude = (screen_pos_2D - mouseLocation(UserInputService)).Magnitude
            if
                on_screen
                and new_magnitude < magnitude
                and isVisible(body_parts.head.Position, body_parts.torso.Parent)
            then
                magnitude = new_magnitude
                local res
                if AIMBOT_SETTINGS.PredictMovement then
                    res = get_prediction_pos(entry, character) or body_parts.head.Position;
                else
                    res = body_parts.head.Position;
                end

                if AIMBOT_SETTINGS.PredictBulletDrop then
                    local currentPos = get_current_pos()
                    if currentPos then
                        -- local distance = GetDistance(currentPos, body_parts.head.Position);
                        local ballistic_pos = (get_bal_pos(player))
                        if ballistic_pos then
                            res = Vector2.new(res.X, ballistic_pos.Y - (ballistic_pos.Y - res.Y))
                            -- print("\n\n", "BALLISTIC POS = ", ballistic_pos, "\n\n", "RES = ", res, "\n\n", "DISTANCE = ",
                            -- distance, "\n\n")
                        end
                    end
                end
                targetPos = res;
                -- AimPoint.Position = Vector2.new(res.X, res.Y)

                -- local pos = get_pos(player);
                -- print("pos = ", pos);
                -- local dotSize = _size / 2 * ScreenGui.AbsoluteSize.y
                -- local res = Vector2.new(
                --     pos.X / UIScale - dotSize,
                --     pos.Y / UIScale - dotSize
                -- )
                -- targetPos = body_parts.head.Position
            end
        end
    end
    return targetPos
end
local mouse = client:GetMouse()
local function aimAt(pos, smooth)
    local targetPos = pos
    local mousePos = Vector2.new(mouse.X, mouse.Y) -- Use mouseLocation instead of WorldToScreenPoint
    local smoothFactor = smooth or 1
    local deltaX = (targetPos.X - mousePos.X) / smoothFactor
    local deltaY = (targetPos.Y - mousePos.Y) / smoothFactor

    mousemoverel(deltaX, deltaY)
end

function aimbot_module:init()
    util.misc:runLoop("AIMBOT_XD",function()
        if id ~= AIMBOT_SETTINGS.id then
            if circle.__OBJECT_EXISTS then
                print("stopping this instance of aimbot", id, AIMBOT_SETTINGS.id)
                circle:Remove()
                -- AimPoint:Remove()
                util.misc:destroyLoop("AIMBOT_XD")
            end
            return
        end
    
        if AIMBOT_SETTINGS.Enabled and UserInputService:IsKeyDown(AIMBOT_SETTINGS.Key) then
            local success, err = pcall(function()
                local _pos = get_closest(AIMBOT_SETTINGS.FOV)
                if _pos then
                    -- print("pos = ", _pos)
                    aimAt(_pos, AIMBOT_SETTINGS.Smoothness)
                end
            end)

            if not success then
                print("ERROR: ", err)
            end
        end
        if circle.__OBJECT_EXISTS then
            circle.Visible = AIMBOT_SETTINGS.Enabled and AIMBOT_SETTINGS.ShowFOV
            circle.Position = mouseLocation(UserInputService)
            circle.Radius = AIMBOT_SETTINGS.FOV
        end
    end, RunService.RenderStepped)
    
    -- my bullet drop prediction sucks man
    -- local uis = game:GetService("UserInputService")
    
    -- uis.InputBegan:Connect(function(input)
    --     if (uis:GetFocusedTextBox() or id ~= AIMBOT_SETTINGS.id) then
    --         return; -- make sure player's not chatting!
    --     end
    --     if input.KeyCode == Enum.KeyCode.LeftAlt then
    --         AIMBOT_SETTINGS.PredictBulletDrop = not AIMBOT_SETTINGS.PredictBulletDrop
    --     end
    -- end)
end

function aimbot_module:gui_init(MainUI)
    local AimbotPage = MainUI.AddPage("Aimbot")

    AimbotPage.AddLabel("Aimbot Settings")
    AimbotPage.AddToggle("Enabled", AIMBOT_SETTINGS.Enabled, function(Value)
        AIMBOT_SETTINGS.Enabled = Value
    end)
    AimbotPage.AddToggle("Visible Check", AIMBOT_SETTINGS.VisibleCheck, function(Value)
        AIMBOT_SETTINGS.VisibleCheck = Value
    end)
    AimbotPage.AddToggle("Predict Movement", AIMBOT_SETTINGS.VisibleCheck, function(Value)
        AIMBOT_SETTINGS.PredictMovement = Value
    end)
    AimbotPage.AddToggle("Bullet Drop Prediction", AIMBOT_SETTINGS.VisibleCheck, function(Value)
        AIMBOT_SETTINGS.PredictBulletDrop = Value
    end)
    AimbotPage.AddToggle("Show FOV", AIMBOT_SETTINGS.VisibleCheck, function(Value)
        AIMBOT_SETTINGS.ShowFOV = Value
    end)
    AimbotPage.AddSlider("Smoothness", {Min = 1, Max = 20, Def = AIMBOT_SETTINGS.Smoothness}, function(Value)
        AIMBOT_SETTINGS.Smoothness = Value
    end)
    AimbotPage.AddSlider("FOV", {Min = 1, Max = 1300, Def = AIMBOT_SETTINGS.FOV}, function(Value)
        AIMBOT_SETTINGS.FOV = Value
    end)

    AimbotPage.AddColourPicker("FOV Color", circle.Color, function(Value)
        circle.Color = Value
    end)

    AimbotPage.AddDropdown("Aim Key", util.keycodes.KeyNames, function(x)
        AIMBOT_SETTINGS.Key = util.keycodes.Keys[x]
    end)
    -- AimbotPage.AddDropdown("Bullet Drop Toggle Key", util.keycodes.KeyNames, function(x)
    --     AIMBOT_SETTINGS.BulletDropToggleKey = util.keycodes.Keys[x]
    -- end)
end


aimbot = aimbot_module
end
local UILibrary = {}
do
gui_module = {}
--https://v3rmillion.net/showthread.php?tid=1023761
local Player = game.Players.LocalPlayer
local Mouse = Player:GetMouse()

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGuiService = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")

local TweenTime = 0.1
local Level = 1

local GlobalTweenInfo = TweenInfo.new(TweenTime)
local AlteredTweenInfo = TweenInfo.new(TweenTime, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)

local DropShadowID = "rbxassetid://297774371"
local DropShadowTransparency = 0.3

local IconLibraryID = "rbxassetid://3926305904"
local IconLibraryID2 = "rbxassetid://3926307971"

local MainFont = Enum.Font.Gotham

local function GetXY(GuiObject)
	local X, Y = Mouse.X - GuiObject.AbsolutePosition.X, Mouse.Y - GuiObject.AbsolutePosition.Y
	local MaxX, MaxY = GuiObject.AbsoluteSize.X, GuiObject.AbsoluteSize.Y
	X, Y = math.clamp(X, 0, MaxX), math.clamp(Y, 0, MaxY)
	return X, Y, X/MaxX, Y/MaxY
end

local function TitleIcon(ButtonOrNot)
	local NewTitleIcon = Instance.new(ButtonOrNot and "ImageButton" or "ImageLabel")
	NewTitleIcon.Name = "TitleIcon"
	NewTitleIcon.BackgroundTransparency = 1
	NewTitleIcon.Image = IconLibraryID
	NewTitleIcon.ImageRectOffset = Vector2.new(524, 764)
	NewTitleIcon.ImageRectSize = Vector2.new(36, 36)
	NewTitleIcon.Size = UDim2.new(0,14,0,14)
	NewTitleIcon.Position = UDim2.new(1,-17,0,3)
	NewTitleIcon.Rotation = 180
	NewTitleIcon.ZIndex = Level
	return NewTitleIcon
end

local function TickIcon(ButtonOrNot)
	local NewTickIcon = Instance.new(ButtonOrNot and "ImageButton" or "ImageLabel")
	NewTickIcon.Name = "TickIcon"
	NewTickIcon.BackgroundTransparency = 1
	NewTickIcon.Image = "rbxassetid://3926305904"
	NewTickIcon.ImageRectOffset = Vector2.new(312,4)
	NewTickIcon.ImageRectSize = Vector2.new(24,24)
	NewTickIcon.Size = UDim2.new(1,-6,1,-6)
	NewTickIcon.Position = UDim2.new(0,3,0,3)
	NewTickIcon.ZIndex = Level
	return NewTickIcon
end

local function DropdownIcon(ButtonOrNot)
	local NewDropdownIcon = Instance.new(ButtonOrNot and "ImageButton" or "ImageLabel")
	NewDropdownIcon.Name = "DropdownIcon"
	NewDropdownIcon.BackgroundTransparency = 1
	NewDropdownIcon.Image = IconLibraryID2
	NewDropdownIcon.ImageRectOffset = Vector2.new(324,364)
	NewDropdownIcon.ImageRectSize = Vector2.new(36,36)
	NewDropdownIcon.Size = UDim2.new(0,16,0,16)
	NewDropdownIcon.Position = UDim2.new(1,-18,0,2)
	NewDropdownIcon.ZIndex = Level
	return NewDropdownIcon
end

local function SearchIcon(ButtonOrNot)
	local NewSearchIcon = Instance.new(ButtonOrNot and "ImageButton" or "ImageLabel")
	NewSearchIcon.Name = "SearchIcon"
	NewSearchIcon.BackgroundTransparency = 1
	NewSearchIcon.Image = IconLibraryID
	NewSearchIcon.ImageRectOffset = Vector2.new(964,324)
	NewSearchIcon.ImageRectSize = Vector2.new(36,36)
	NewSearchIcon.Size = UDim2.new(0,16,0,16)
	NewSearchIcon.Position = UDim2.new(0,2,0,2)
	NewSearchIcon.ZIndex = Level
	return NewSearchIcon
end

local function RoundBox(CornerRadius, ButtonOrNot)
	local NewRoundBox = Instance.new(ButtonOrNot and "ImageButton" or "ImageLabel")
	NewRoundBox.BackgroundTransparency = 1
	NewRoundBox.Image = "rbxassetid://3570695787"
	NewRoundBox.SliceCenter = Rect.new(100,100,100,100)
	NewRoundBox.SliceScale = math.clamp((CornerRadius or 5) * 0.01, 0.01, 1)
	NewRoundBox.ScaleType = Enum.ScaleType.Slice
	NewRoundBox.ZIndex = Level
	return NewRoundBox
end

local function DropShadow()
	local NewDropShadow = Instance.new("ImageLabel")
	NewDropShadow.Name = "DropShadow"
	NewDropShadow.BackgroundTransparency = 1
	NewDropShadow.Image = DropShadowID
	NewDropShadow.ImageTransparency = DropShadowTransparency
	NewDropShadow.Size = UDim2.new(1,0,1,0)
	NewDropShadow.ZIndex = Level
	return NewDropShadow
end

local function Frame()
	local NewFrame = Instance.new("Frame")
	NewFrame.BorderSizePixel = 0
	NewFrame.ZIndex = Level
	return NewFrame
end

local function ScrollingFrame()
	local NewScrollingFrame = Instance.new("ScrollingFrame")
	NewScrollingFrame.BackgroundTransparency = 1
	NewScrollingFrame.BorderSizePixel = 0
	NewScrollingFrame.ScrollBarThickness = 0
	NewScrollingFrame.ZIndex = Level
	return NewScrollingFrame
end

local function TextButton(Text, Size)
	local NewTextButton = Instance.new("TextButton")
	NewTextButton.Text = Text
	NewTextButton.AutoButtonColor = false
	NewTextButton.Font = MainFont
	NewTextButton.TextColor3 = Color3.fromRGB(255,255,255)
	NewTextButton.BackgroundTransparency = 1
	NewTextButton.TextSize = Size or 12
	NewTextButton.Size = UDim2.new(1,0,1,0)
	NewTextButton.ZIndex = Level
	return NewTextButton
end

local function TextBox(Text, Size)
	local NewTextBox = Instance.new("TextBox")
	NewTextBox.Text = Text
	NewTextBox.Font = MainFont
	NewTextBox.TextColor3 = Color3.fromRGB(255,255,255)
	NewTextBox.BackgroundTransparency = 1
	NewTextBox.TextSize = Size or 12
	NewTextBox.Size = UDim2.new(1,0,1,0)
	NewTextBox.ZIndex = Level
	return NewTextBox
end

local function TextLabel(Text, Size)
	local NewTextLabel = Instance.new("TextLabel")
	NewTextLabel.Text = Text
	NewTextLabel.Font = MainFont
	NewTextLabel.TextColor3 = Color3.fromRGB(255,255,255)
	NewTextLabel.BackgroundTransparency = 1
	NewTextLabel.TextSize = Size or 12
	NewTextLabel.Size = UDim2.new(1,0,1,0)
	NewTextLabel.ZIndex = Level
	return NewTextLabel
end

local function Tween(GuiObject, Dictionary)
	local TweenBase = TweenService:Create(GuiObject, GlobalTweenInfo, Dictionary)
	TweenBase:Play()
	return TweenBase
end

function gui_module.Load(GUITitle)
	local TargetedParent = RunService:IsStudio() and Player:WaitForChild("PlayerGui") or CoreGuiService
	
	local FindOldInstance = TargetedParent:FindFirstChild(GUITitle)
	
	if FindOldInstance then
		FindOldInstance:Destroy()
	end
	
	local NewInstance, ContainerFrame, ContainerShadow, MainFrame
	
	NewInstance = Instance.new("ScreenGui")
	NewInstance.Name = GUITitle
	NewInstance.Parent = TargetedParent
	
	ContainerFrame = Frame()
	ContainerFrame.Name = "ContainerFrame"
	ContainerFrame.Size = UDim2.new(0,500,0,300)
	ContainerFrame.Position = UDim2.new(0.5,-250,0.5,-150)
	ContainerFrame.BackgroundTransparency = 1
	ContainerFrame.Parent = NewInstance
	
	ContainerShadow = DropShadow()
	ContainerShadow.Name = "Shadow"
	ContainerShadow.Parent = ContainerFrame
	
	Level += 1
	
	MainFrame = RoundBox(5)
	MainFrame.ClipsDescendants = true
	MainFrame.Name = "MainFrame"
	MainFrame.Size = UDim2.new(1,-50,1,-30)
	MainFrame.Position = UDim2.new(0,25,0,15)
	MainFrame.ImageColor3 = Color3.fromRGB(30,30,30)
	MainFrame.Parent = ContainerFrame
	
	local MenuBar, DisplayFrame, TitleBar
	
	MenuBar = ScrollingFrame()
	MenuBar.Name = "MenuBar"
	MenuBar.BackgroundTransparency = 0.7
	MenuBar.BackgroundColor3 = Color3.fromRGB(20,20,20)
	MenuBar.Size = UDim2.new(0,100,0,235)
	MenuBar.Position = UDim2.new(0,5,0,30)
	MenuBar.CanvasSize = UDim2.new(0,0,0,0)
	MenuBar.Parent = MainFrame
	
	DisplayFrame = RoundBox(5)
	DisplayFrame.Name = "Display"
	DisplayFrame.ImageColor3 = Color3.fromRGB(20,20,20)
	DisplayFrame.Size = UDim2.new(1,-115,0,235)
	DisplayFrame.Position = UDim2.new(0,110,0,30)
	DisplayFrame.Parent = MainFrame
	
	TitleBar = RoundBox(5)
	TitleBar.Name = "TitleBar"
	TitleBar.ImageColor3 = Color3.fromRGB(40,40,40)
	TitleBar.Size = UDim2.new(1,-10,0,20)
	TitleBar.Position = UDim2.new(0,5,0,5)
	TitleBar.Parent = MainFrame
	
	Level += 1
	
	local MinimiseButton, TitleButton
	local MinimiseToggle = true
	
	MinimiseButton = TitleIcon(true)
	MinimiseButton.Name = "Minimise"
	MinimiseButton.Parent = TitleBar
	
	TitleButton = TextButton(GUITitle, 14)
	TitleButton.Name = "TitleButton"
	TitleButton.Size = UDim2.new(1,-20,1,0)
	TitleButton.Parent = TitleBar
	
	local function MinimizeMainframe()
		MinimiseToggle = not MinimiseToggle
		if not MinimiseToggle then
			Tween(MainFrame, {Size = UDim2.new(1,-50,0,30)})
			Tween(MinimiseButton, {Rotation = 0})
			Tween(ContainerShadow, {ImageTransparency = 1})
		else
			Tween(MainFrame, {Size = UDim2.new(1,-50,1,-30)})
			Tween(MinimiseButton, {Rotation = 180})
			Tween(ContainerShadow, {ImageTransparency = DropShadowTransparency})
		end
	end

	MinimiseButton.MouseButton1Down:Connect(MinimizeMainframe)
	UserInputService.InputBegan:Connect(function(input)
		if input.KeyCode == Enum.KeyCode.P then
			MinimizeMainframe()
		end
	end)
	
	TitleButton.MouseButton1Down:Connect(function()
		local LastMX, LastMY = Mouse.X, Mouse.Y
		local Move, Kill
		Move = Mouse.Move:Connect(function()
			local NewMX, NewMY = Mouse.X, Mouse.Y
			local DX, DY = NewMX - LastMX, NewMY - LastMY
			ContainerFrame.Position += UDim2.new(0,DX,0,DY)
			LastMX, LastMY = NewMX, NewMY
		end)
		Kill = UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				Move:Disconnect()
				Kill:Disconnect()
			end
		end)
	end)
	
	Level += 1
	
	local MenuListLayout
	
	MenuListLayout = Instance.new("UIListLayout")
	MenuListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	MenuListLayout.Padding = UDim.new(0,5)
	MenuListLayout.Parent = MenuBar
	
	local TabCount = 0
	
	local TabLibrary = {}
	
	function TabLibrary.AddPage(PageTitle, SearchBarIncluded)
		local SearchBarIncluded = (SearchBarIncluded == nil) and true or SearchBarIncluded
		
		local PageContainer = RoundBox(5)
		PageContainer.Name = PageTitle
		PageContainer.Size = UDim2.new(1,0,0,20)
		PageContainer.LayoutOrder = TabCount
		PageContainer.ImageColor3 = (TabCount == 0) and Color3.fromRGB(50,50,50) or Color3.fromRGB(40,40,40)
		PageContainer.Parent = MenuBar
		
		local PageButton = TextButton(PageTitle, 14)
		PageButton.Name = PageTitle.."Button"
		PageButton.TextTransparency = (TabCount == 0) and 0 or 0.5
		PageButton.Parent = PageContainer
		
		PageButton.MouseButton1Down:Connect(function()
			spawn(function()
				for _, Button in next, MenuBar:GetChildren() do
					if Button:IsA("GuiObject") then
						local IsButton = string.find(Button.Name:lower(), PageContainer.Name:lower())
						local Button2 = Button:FindFirstChild(Button.Name.."Button")
						Tween(Button, {ImageColor3 = IsButton and Color3.fromRGB(50,50,50) or Color3.fromRGB(40,40,40)})
						Tween(Button2, {TextTransparency = IsButton and 0 or 0.5})
					end
				end
			end)
			spawn(function()
				for _, Display in next, DisplayFrame:GetChildren() do
					if Display:IsA("GuiObject") then
						Display.Visible = string.find(Display.Name:lower(), PageContainer.Name:lower())
					end
				end
			end)
		end)
		
		local DisplayPage = ScrollingFrame()
		DisplayPage.Visible = (TabCount == 0)
		DisplayPage.Name = PageTitle
		DisplayPage.Size = UDim2.new(1,0,1,0)
		DisplayPage.Parent = DisplayFrame
		
		TabCount += 1
		
		local DisplayList = Instance.new("UIListLayout")
		DisplayList.SortOrder = Enum.SortOrder.LayoutOrder
		DisplayList.Padding = UDim.new(0,5)
		DisplayList.Parent = DisplayPage
		
		DisplayList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			local Y1 = DisplayList.AbsoluteContentSize.Y
			local Y2 = DisplayPage.AbsoluteWindowSize.Y
			DisplayPage.CanvasSize = UDim2.new(0,0,(Y1/Y2)+0.05,0)
		end)
		
		local DisplayPadding = Instance.new("UIPadding")
		DisplayPadding.PaddingBottom = UDim.new(0,5)
		DisplayPadding.PaddingTop = UDim.new(0,5)
		DisplayPadding.PaddingLeft = UDim.new(0,5)
		DisplayPadding.PaddingRight = UDim.new(0,5)
		DisplayPadding.Parent = DisplayPage
		
		if SearchBarIncluded then
			local SearchBarContainer = RoundBox(5)
			SearchBarContainer.Name = "SearchBar"
			SearchBarContainer.ImageColor3 = Color3.fromRGB(35,35,35)
			SearchBarContainer.Size = UDim2.new(1,0,0,20)
			SearchBarContainer.Parent = DisplayPage
			
			local SearchBox = TextBox("Search...")
			SearchBox.Name = "SearchInput"
			SearchBox.Position = UDim2.new(0,20,0,0)
			SearchBox.Size = UDim2.new(1,-20,1,0)
			SearchBox.TextTransparency = 0.5
			SearchBox.TextXAlignment = Enum.TextXAlignment.Left
			SearchBox.Parent = SearchBarContainer
			
			local SearchIcon = SearchIcon()
			SearchIcon.Parent = SearchBarContainer
			
			SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
				local NewValue = SearchBox.Text
				
				for _, Element in next, DisplayPage:GetChildren() do
					if Element:IsA("Frame") then
						if not string.find(Element.Name:lower(), "label") then
							if string.find(Element.Name:lower(), NewValue:lower()) then
								Element.Visible = true
							else
								Element.Visible = false
							end
						end
					end
				end
			end)
		end
		
		local PageLibrary = {}
		
		function PageLibrary.AddButton(Text, Callback, Parent, Underline)
			local ButtonContainer = Frame()
			ButtonContainer.Name = Text.."BUTTON"
			ButtonContainer.Size = UDim2.new(1,0,0,20)
			ButtonContainer.BackgroundTransparency = 1
			ButtonContainer.Parent = Parent or DisplayPage
			
			local ButtonForeground = RoundBox(5)
			ButtonForeground.Name = "ButtonForeground"
			ButtonForeground.Size = UDim2.new(1,0,1,0)
			ButtonForeground.ImageColor3 = Color3.fromRGB(35,35,35)
			ButtonForeground.Parent = ButtonContainer
			
			if Underline then
				local TextSize = TextService:GetTextSize(Text, 12, Enum.Font.Gotham, Vector2.new(0,0))
			
				local BottomEffect = Frame()
				BottomEffect.Size = UDim2.new(0,TextSize.X,0,1)
				BottomEffect.Position = UDim2.new(0.5,(-TextSize.X/2)-1,1,-1)
				BottomEffect.BackgroundColor3 = Color3.fromRGB(255,255,255)
				BottomEffect.BackgroundTransparency = 0.5
				BottomEffect.Parent = ButtonForeground
			end
			
			local HiddenButton = TextButton(Text, 12)
			HiddenButton.Parent = ButtonForeground
			
			HiddenButton.MouseButton1Down:Connect(function()
				Callback()
				Tween(ButtonForeground, {ImageColor3 = Color3.fromRGB(45,45,45)})
				Tween(HiddenButton, {TextTransparency = 0.5})
				wait(TweenTime)
				Tween(ButtonForeground, {ImageColor3 = Color3.fromRGB(35,35,35)})
				Tween(HiddenButton, {TextTransparency = 0})
			end)
		end
		
		function PageLibrary.AddLabel(Text, FontSize, TextColor)
			local LabelContainer = Frame()
			LabelContainer.Name = Text.."LABEL"
			LabelContainer.Size = UDim2.new(1, 0, 0, 20) -- Adjust the width to be 100%
			LabelContainer.BackgroundTransparency = 1
			LabelContainer.Parent = DisplayPage
			
			local LabelForeground = RoundBox(5)
			LabelForeground.Name = "LabelForeground"
			LabelForeground.ImageColor3 = Color3.fromRGB(45,45,45)
			LabelForeground.Size = UDim2.new(1, 0, 1, 0) -- Make the width match the LabelContainer
			LabelForeground.Parent = LabelContainer
			
			local HiddenLabel = TextLabel(Text, FontSize or 12)
			HiddenLabel.Parent = LabelForeground
			HiddenLabel.TextColor3 = TextColor or Color3.fromRGB(255,255,255)
		
			-- Update height of the LabelContainer
			local textBounds = HiddenLabel.TextBounds
			local paddingY = 4 -- Vertical padding
		
			LabelContainer.Size = UDim2.new(1, 0, 0, textBounds.Y + paddingY) -- Update only the height
		end
		
		
		
		function PageLibrary.AddDropdown(Text, ConfigurationArray, Callback)
			local DropdownArray = ConfigurationArray or {}
			
			local DropdownToggle = false
			
			local DropdownContainer = Frame()
			DropdownContainer.Size = UDim2.new(1,0,0,20)
			DropdownContainer.Name = Text.."DROPDOWN"
			DropdownContainer.BackgroundTransparency = 1
			DropdownContainer.Parent = DisplayPage
			
			local DropdownForeground = RoundBox(5)
			DropdownForeground.ClipsDescendants = true
			DropdownForeground.ImageColor3 = Color3.fromRGB(35,35,35)
			DropdownForeground.Size = UDim2.new(1,0,1,0)
			DropdownForeground.Parent = DropdownContainer
			
			local DropdownExpander = DropdownIcon(true)
			DropdownExpander.Parent = DropdownForeground
			
			local DropdownLabel = TextLabel(Text, 12)
			DropdownLabel.Size = UDim2.new(1,0,0,20)
			DropdownLabel.Parent = DropdownForeground
			
			local DropdownFrame = Frame()
			DropdownFrame.Position = UDim2.new(0,0,0,20)
			DropdownFrame.BackgroundTransparency = 1
			DropdownFrame.Size = UDim2.new(1,0,0,#DropdownArray*20)
			DropdownFrame.Parent = DropdownForeground
			
			local DropdownList = Instance.new("UIListLayout")
			DropdownList.Parent = DropdownFrame
			
			for OptionIndex, Option in next, DropdownArray do
				PageLibrary.AddButton(Option, function()
					Callback(Option)
					DropdownLabel.Text = Text..": "..Option
				end, DropdownFrame, OptionIndex < #DropdownArray)
			end
			
			DropdownExpander.MouseButton1Down:Connect(function()
				DropdownToggle = not DropdownToggle
				Tween(DropdownContainer, {Size = DropdownToggle and UDim2.new(1,0,0,20+(#DropdownArray*20)) or UDim2.new(1,0,0,20)})
				Tween(DropdownExpander, {Rotation = DropdownToggle and 135 or 0})
			end)
		end
		
		function PageLibrary.AddColourPicker(Text, DefaultColour, Callback)
			local DefaultColour = DefaultColour or Color3.fromRGB(255,255,255)
			
			local ColourDictionary = {
				white = Color3.fromRGB(255,255,255),
				black = Color3.fromRGB(0,0,0),
				red = Color3.fromRGB(255,0,0),
				green = Color3.fromRGB(0,255,0),
				blue = Color3.fromRGB(0,0,255)
			}
			
			if typeof(DefaultColour) == "table" then
				DefaultColour = Color3.fromRGB(DefaultColour[1] or 255, DefaultColour[2] or 255, DefaultColour[3] or 255)
			elseif typeof(DefaultColour) == "string" then
				DefaultColour = ColourDictionary[DefaultColour:lower()] or ColourDictionary["white"]
			end
			
			local PickerContainer = Frame()
			PickerContainer.ClipsDescendants = true
			PickerContainer.Size = UDim2.new(1,0,0,20)
			PickerContainer.Name = Text.."COLOURPICKER"
			PickerContainer.BackgroundTransparency = 1
			PickerContainer.Parent = DisplayPage
			
			local ColourTracker = Instance.new("Color3Value")
			ColourTracker.Value = DefaultColour
			ColourTracker.Parent = PickerContainer
			
			local PickerLeftSide, PickerRightSide, PickerFrame = RoundBox(5), RoundBox(5), RoundBox(5)
			
			PickerLeftSide.Size = UDim2.new(1,-22,1,0)
			PickerLeftSide.ImageColor3 = Color3.fromRGB(35,35,35)
			PickerLeftSide.Parent = PickerContainer
			
			PickerRightSide.Size = UDim2.new(0,20,1,0)
			PickerRightSide.Position = UDim2.new(1,-20,0,0)
			PickerRightSide.ImageColor3 = DefaultColour
			PickerRightSide.Parent = PickerContainer
			
			PickerFrame.ImageColor3 = Color3.fromRGB(35,35,35)
			PickerFrame.Size = UDim2.new(1,-22,0,60)
			PickerFrame.Position = UDim2.new(0,0,0,20)
			PickerFrame.Parent = PickerContainer
			
			local PickerList = Instance.new("UIListLayout")
			PickerList.SortOrder = Enum.SortOrder.LayoutOrder
			PickerList.Parent = PickerFrame
			
			local RedPicker = PageLibrary.AddSlider("R", {Min = 0, Max = 255, Def = ColourTracker.Value.R * 255}, function(Value)
				ColourTracker.Value = Color3.fromRGB(Value, ColourTracker.Value.G * 255, ColourTracker.Value.B * 255)
				Callback(ColourTracker.Value)
			end, PickerFrame)
			
			local BluePicker = PageLibrary.AddSlider("G", {Min = 0, Max = 255, Def = ColourTracker.Value.G * 255}, function(Value)
				ColourTracker.Value = Color3.fromRGB(ColourTracker.Value.R * 255, Value, ColourTracker.Value.B * 255)
				Callback(ColourTracker.Value)
			end, PickerFrame)
			
			local GreenPicker = PageLibrary.AddSlider("B", {Min = 0, Max = 255, Def = ColourTracker.Value.B * 255}, function(Value)
				ColourTracker.Value = Color3.fromRGB(ColourTracker.Value.R * 255, ColourTracker.Value.G * 255, Value)
				Callback(ColourTracker.Value)
			end, PickerFrame)
			
			local EffectLeft, EffectRight = Frame(), Frame()
			
			EffectLeft.BackgroundColor3 = Color3.fromRGB(35,35,35)
			EffectLeft.Position = UDim2.new(1,-5,0,0)
			EffectLeft.Size = UDim2.new(0,5,1,0)
			EffectLeft.Parent = PickerLeftSide
			
			EffectRight.BackgroundColor3 = DefaultColour
			EffectRight.Size = UDim2.new(0,5,1,0)
			EffectRight.Parent = PickerRightSide
			
			local PickerLabel = TextLabel(Text, 12)
			PickerLabel.Size = UDim2.new(1,0,0,20)
			PickerLabel.Parent = PickerLeftSide
			
			ColourTracker:GetPropertyChangedSignal("Value"):Connect(function()
				local NewValue = ColourTracker.Value
				EffectRight.BackgroundColor3 = NewValue
				PickerRightSide.ImageColor3 = NewValue
			end)
			
			local PickerToggle = false
			
			local PickerButton = TextButton("")
			PickerButton.Parent = PickerRightSide
			
			PickerButton.MouseButton1Down:Connect(function()
				PickerToggle = not PickerToggle
				Tween(PickerContainer, {Size = PickerToggle and UDim2.new(1,0,0,80) or UDim2.new(1,0,0,20)})
			end)
		end
		
		function PageLibrary.AddSlider(Text, ConfigurationDictionary, Callback, Parent)
			local Configuration = ConfigurationDictionary
			local Minimum = Configuration.Minimum or Configuration.minimum or Configuration.Min or Configuration.min
			local Maximum = Configuration.Maximum or Configuration.maximum or Configuration.Max or Configuration.max
			local Default = Configuration.Default or Configuration.default or Configuration.Def or Configuration.def
			
			if Minimum > Maximum then
				local StoreValue = Minimum
				Minimum = Maximum
				Maximum = StoreValue
			end
			
			Default = math.clamp(Default, Minimum, Maximum)
			
			local DefaultScale = Default/Maximum
			
			local SliderContainer = Frame()
			SliderContainer.Name = Text.."SLIDER"
			SliderContainer.Size = UDim2.new(1,0,0,20)
			SliderContainer.BackgroundTransparency = 1
			SliderContainer.Parent = Parent or DisplayPage
			
			local SliderForeground = RoundBox(5)
			SliderForeground.Name = "SliderForeground"
			SliderForeground.ImageColor3 = Color3.fromRGB(35,35,35)
			SliderForeground.Size = UDim2.new(1,0,1,0)
			SliderForeground.Parent = SliderContainer
			
			local SliderButton = TextButton(Text..": "..string.format("%.2f", Default))
			SliderButton.Size = UDim2.new(1,0,1,0)
			SliderButton.ZIndex = 6
			SliderButton.Parent = SliderForeground
			
			local SliderFill = RoundBox(5)
			SliderFill.Size = UDim2.new(DefaultScale,0,1,0)
			SliderFill.ImageColor3 = Color3.fromRGB(70,70,70)
			SliderFill.ZIndex = 5
			SliderFill.ImageTransparency = 0.7
			SliderFill.Parent = SliderButton
			
			SliderButton.MouseButton1Down:Connect(function()
				Tween(SliderFill, {ImageTransparency = 0.5})
				local X, Y, XScale, YScale = GetXY(SliderButton)
				-- local Value = math.floor(Minimum + ((Maximum - Minimum) * XScale))
				local Value = Minimum + ((Maximum - Minimum) * XScale)
				Callback(Value)
				SliderButton.Text = Text..": "..string.format("%.3f", Value)
				local TargetSize = UDim2.new(XScale,0,1,0)
				Tween(SliderFill, {Size = TargetSize})
				local SliderMove, SliderKill
				SliderMove = Mouse.Move:Connect(function()
					Tween(SliderFill, {ImageTransparency = 0.5})
					local X, Y, XScale, YScale = GetXY(SliderButton)
					local Value = Minimum + ((Maximum - Minimum) * XScale)
					Callback(Value)
					SliderButton.Text = Text..": "..string.format("%.3f", Value)
					local TargetSize = UDim2.new(XScale,0,1,0)
					Tween(SliderFill, {Size = TargetSize})
				end)
				SliderKill = UserInputService.InputEnded:Connect(function(UserInput)
					if UserInput.UserInputType == Enum.UserInputType.MouseButton1 then
						Tween(SliderFill, {ImageTransparency = 0.7})
						SliderMove:Disconnect()
						SliderKill:Disconnect()
					end
				end)
			end)
		end
		
		function PageLibrary.AddToggle(Text, Default, Callback)
			local ThisToggle = Default or false
			
			local ToggleContainer = Frame()
			ToggleContainer.Name = Text.."TOGGLE"
			ToggleContainer.Size = UDim2.new(1,0,0,20)
			ToggleContainer.BackgroundTransparency = 1
			ToggleContainer.Parent = DisplayPage
			
			local ToggleLeftSide, ToggleRightSide, EffectFrame, RightTick = RoundBox(5), RoundBox(5), Frame(), TickIcon()
			local FlatLeft, FlatRight = Frame(), Frame()
			
			ToggleLeftSide.Size = UDim2.new(1,-22,1,0)
			ToggleLeftSide.ImageColor3 = Color3.fromRGB(35,35,35)
			ToggleLeftSide.Parent = ToggleContainer
			
			ToggleRightSide.Position = UDim2.new(1,-20,0,0)
			ToggleRightSide.Size = UDim2.new(0,20,1,0)
			ToggleRightSide.ImageColor3 = Color3.fromRGB(45,45,45)
			ToggleRightSide.Parent = ToggleContainer
			
			FlatLeft.BackgroundColor3 = Color3.fromRGB(35,35,35)
			FlatLeft.Size = UDim2.new(0,5,1,0)
			FlatLeft.Position = UDim2.new(1,-5,0,0)
			FlatLeft.Parent = ToggleLeftSide
			
			FlatRight.BackgroundColor3 = Color3.fromRGB(45,45,45)
			FlatRight.Size = UDim2.new(0,5,1,0)
			FlatRight.Parent = ToggleRightSide
			
			EffectFrame.BackgroundColor3 = ThisToggle and Color3.fromRGB(0,255,109) or Color3.fromRGB(255,160,160)
			EffectFrame.Position = UDim2.new(1,-22,0.2,0)
			EffectFrame.Size = UDim2.new(0,2,0.6,0)
			EffectFrame.Parent = ToggleContainer
			
			RightTick.ImageTransparency = ThisToggle and 0 or 1
			RightTick.Parent = ToggleRightSide
			
			local ToggleButton = TextButton(Text, 12)
			ToggleButton.Name = "ToggleButton"
			ToggleButton.Size = UDim2.new(1,0,1,0)
			ToggleButton.Parent = ToggleLeftSide
			
			ToggleButton.MouseButton1Down:Connect(function()
				ThisToggle = not ThisToggle
				Tween(EffectFrame, {BackgroundColor3 = ThisToggle and Color3.fromRGB(0,255,109) or Color3.fromRGB(255,160,160)})
				Tween(RightTick, {ImageTransparency = ThisToggle and 0 or 1})
				Callback(ThisToggle)
			end)	
		end
		
		return PageLibrary
	end
	
	return TabLibrary
end

UILibrary = gui_module
end

function gui_init()
    esp:init()
    hitbox:init()
    aimbot:init()

    local MainUI = UILibrary.Load("Hi there")
    aimbot:gui_init(MainUI)
    esp:gui_init(MainUI)
    hitbox:gui_init(MainUI)
    
    local CreditsPage = MainUI.AddPage("Credits")

    CreditsPage.AddLabel("https://github.com/Syncxv/lua-stuff/tree/master/pf%20ui#credits", 10)

    CreditsPage.AddLabel("Aimbot", 14, Color3.new(1,0,0))
    CreditsPage.AddLabel("No idea#7972 (773953647289565204)")
    CreditsPage.AddLabel("me Aria#8171 (549244932213309442)")
    CreditsPage.AddLabel("Hitbox Expander",14, Color3.new(1,0,0))
    CreditsPage.AddLabel("The3Bakers#4565 https://discord.gg/vQQqcgBWCG")
    CreditsPage.AddLabel("me Aria#8171 (549244932213309442)")
    CreditsPage.AddLabel("ESP", 14, Color3.new(1,0,0))
    CreditsPage.AddLabel("me Aria#8171 (549244932213309442)")
    CreditsPage.AddLabel("Racist Dolphin")
    CreditsPage.AddLabel("No idea#7972 (773953647289565204)")
end
gui_init()

    ]]);
    
