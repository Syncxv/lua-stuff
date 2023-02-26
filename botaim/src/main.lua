if not getgenv or not mousemoverel then
    game:GetService("Players").LocalPlayer:Kick("Your exploit is not supported!")
end

local id = math.random(1, 1000000);
getgenv().AIMBOT_SETTINGS = {
    id = id,
    smoothness = 2,
    FOV = 75,
    VisibleCheck = true,
}

-- services
local players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- variables
local client = players.LocalPlayer
local shared = getrenv().shared
local camera = workspace.CurrentCamera
local mouseLocation = UserInputService.GetMouseLocation
local WorldToViewportPoint = camera.WorldToViewportPoint
local ReplicationInterface = shared.require("ReplicationInterface");
local PublicSettings = shared.require("PublicSettings");
local Physics = shared.require("physics");
local CameraInterface = shared.require("CameraInterface");
local HudScreenGui = shared.require("HudScreenGui")
local UIScale = HudScreenGui.getUIScale()
local LocalPlayer = game:GetService("Players").LocalPlayer;
local CurrentCamera = workspace.CurrentCamera
local ScreenGui = HudScreenGui.getScreenGui()
local CoreGui = game:GetService("CoreGui")


local _size = 0.009259259259259259



-- modules
local replicationObject = shared.require("ReplicationObject")
local replicationInterface = shared.require("ReplicationInterface")

local firearmSight = shared.require("FirearmSight")

if(_G.oldFirearmSight == nil) then
    _G.oldFirearmSight = firearmSight.new
end

firearmSight.new = function(p1, p2)
    -- print(p1, p2);
    
    _G.firearmObject = p1;
    
    return _G.oldFirearmSight(p1, p2);
end;


--ui stuff


local AimPoint = Drawing.new("Circle")
AimPoint.Thickness = 2
AimPoint.NumSides = 12
AimPoint.Radius = 2
AimPoint.Filled = true
AimPoint.Transparency = 1
AimPoint.Color = Color3.new(math.random(), math.random(), math.random())
AimPoint.Visible = true

-- functions
local ShowUIElement = function(Element, Enabled)
	Element.Visible = Enabled
	for _, v in next, Element:GetDescendants() do
		v.Visible = Enabled
	end
end

local function isAlive(entry)
    return replicationObject.isAlive(entry)
end

local function isVisible(p, ...)
    if not getgenv().AIMBOT_SETTINGS.VisibleCheck then
        return true
    end

    return #camera:GetPartsObscuringTarget({ p }, { camera, client.Character, workspace.Ignore, ... }) == 0
end


local function get_pos(player)
    local pos = nil;
    local trajectory = nil;
    local activeCamera = CameraInterface.getActiveCamera("MainCamera")
    
    local cameraPosition = activeCamera:getCFrame().p
    local playerPosition, isPlayerPositionValid = ReplicationInterface.getEntry(player):getPosition()

    if isPlayerPositionValid then
        trajectory = Physics.trajectory(cameraPosition, PublicSettings.bulletAcceleration, playerPosition, _G.firearmObject:getWeaponStat("bulletspeed"))
    end
                -- for i,v in pairs(v13) do print(i) end
    if trajectory then
        pos =  CurrentCamera:WorldToScreenPoint(cameraPosition + trajectory)
    end


    return pos
end


local function get_current_pos()
    return client.Character.HumanoidRootPart.Position
end

local Mouse = players.LocalPlayer:GetMouse()

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
                local BallisticPos = get_pos(player);
                local PartPos = CurrentCamera:WorldToScreenPoint(body_parts.head.Position)
                local res = Vector2.new(PartPos.X, PartPos.Y - math.abs(PartPos.Y - BallisticPos.Y) * 0.9)
                AimPoint.Position = res
                targetPos = res;
                
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
    local targetPos = (pos)
    local mousePos = camera:WorldToScreenPoint(mouse.Hit.p)
    mousemoverel((targetPos.X - mousePos.X), (targetPos.Y - mousePos.Y))
end
local circle = Drawing.new("Circle")
circle.Thickness = 2
circle.NumSides = 12
circle.Radius = 350
circle.Filled = false
circle.Transparency = 1
circle.Color = Color3.new(math.random(), math.random(), math.random())
circle.Visible = true

RunService.RenderStepped:Connect(function()
    if id ~= getgenv().AIMBOT_SETTINGS.id then
        if circle.__OBJECT_EXISTS then
            print("stopping this instance of aimbot", id, getgenv().AIMBOT_SETTINGS.id)
            circle:Remove()
            AimPoint:Remove()
        end
        return
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.RightBracket) then
        local _pos = get_closest(getgenv().AIMBOT_SETTINGS.FOV)
        if _pos then
            print("pos = ", _pos)
            aimAt(_pos, getgenv().AIMBOT_SETTINGS.smoothness)
        end
    end
    if circle.__OBJECT_EXISTS then
        circle.Position = mouseLocation(UserInputService)
        circle.Radius = getgenv().AIMBOT_SETTINGS.FOV
    end
end)
