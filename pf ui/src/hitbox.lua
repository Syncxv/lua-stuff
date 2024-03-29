hitbox_module = {}
--made by The3Bakers#4565
--discord link https://discord.gg/vQQqcgBWCG
local util = require("util")

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