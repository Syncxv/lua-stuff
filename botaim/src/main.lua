if not getgenv or not mousemoverel then
    game:GetService("Players").LocalPlayer:Kick("Your exploit is not supported!")
end

local id = hashgnaghehehhehehehehe .. math.random(1, 100000000)
getgenv().AIMBOT_SETTINGS = {
    id = id,
    smoothness = 3,
    FOV = 150,
    VisibleCheck = true,
    PredictBulletDrop = true,
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
local ReplicationInterface = shared.require("ReplicationInterface");
local PublicSettings = shared.require("PublicSettings");
local Physics = shared.require("physics");
local CameraInterface = shared.require("CameraInterface");
local HudScreenGui = shared.require("HudScreenGui")
local CurrentCamera = workspace.CurrentCamera
local gameClock = shared.require("GameClock")

local _size = 0.009259259259259259



-- modules
local replicationObject = shared.require("ReplicationObject")
local replicationInterface = shared.require("ReplicationInterface")

local firearmObject = shared.require("FirearmObject")

if (_G.oldFirearmObject == nil) then
    _G.oldFirearmObject = firearmObject.new
end

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


local AimPoint = Drawing.new("Circle")
AimPoint.Thickness = 2
AimPoint.NumSides = 12
AimPoint.Radius = 2
AimPoint.Filled = true
AimPoint.Transparency = 1
AimPoint.Color = Color3.new(math.random(), math.random(), math.random())
AimPoint.Visible = true

-- functions

local function createText(bruh, position)
    local text = Drawing.new("Text");

    text.Visible = true
    text.Transparency = 1
    text.ZIndex = 1
    text.Color = Color3.fromRGB(255, 255, 255);
    text.Position = position
    text.Text = bruh;
    coroutine.wrap(function()
        game.RunService.RenderStepped:Wait()
        text:Remove() --destroy after a frame because we make new part on frame
    end)()
    return text
end


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
    if not getgenv().AIMBOT_SETTINGS.VisibleCheck then
        return true
    end

    return #camera:GetPartsObscuringTarget({ p }, { camera, client.Character, workspace.Ignore, ... }) == 0
end

local function get_bal_pos(player)
    local pos = nil;
    local trajectory = nil;
    local activeCamera = CameraInterface.getActiveCamera("MainCamera")

    local cameraPosition = activeCamera:getCFrame().p
    local playerPosition, isPlayerPositionValid = ReplicationInterface.getEntry(player):getPosition()

    if isPlayerPositionValid then
        trajectory = Physics.trajectory(cameraPosition, PublicSettings.bulletAcceleration, playerPosition,
        _G.firearmObject:getWeaponStat("bulletspeed"))
    end
    -- for i,v in pairs(v13) do print(i) end
    if trajectory then
        local hehe = cameraPosition + trajectory
        print("BAL POS REAL = ", hehe)
        pos = CurrentCamera:WorldToViewportPoint(hehe)
    end


    return pos
end

local function get_current_pos()
    return client.Character.HumanoidRootPart.Position
end

local function get_prediction_pos(entry, character)
    -- local activeCamera = CameraInterface.getActiveCamera("MainCamera")

    local speed = _G.firearmObject:getWeaponStat("bulletspeed")

    local cFrame = entry._smoothReplication:getFrame(gameClock.getTime())
    local TargetVelocity = cFrame.velocity

    local TargetLocation = character:getCharacterHash().head.Position

    local CurrentPosition = get_current_pos();

    local Distance = GetDistance(CurrentPosition, TargetLocation);

    -- local minDistance = 10 -- set a minimum distance value
    -- if Distance < minDistance then
    --     print("close range is inaccurate and will be skipped")
    --     return CurrentCamera:WorldToScreenPoint(TargetLocation) -- prediction is not accurate for short distances
    -- end

    local TravelTime = Distance / speed;

    local PredictedLocation = TargetLocation + TargetVelocity * TravelTime
    print("\n\n\n------------", "\n\n\n", "TravelTime = ", TravelTime, "\n\n\n", "TARGET VELOCITY = ", TargetVelocity,
    "\n\n\n", "PREDICTED LOCATION = ", PredictedLocation, "\n\n\n", "CURRENT LOCATION = ", CurrentPosition,
    "\n\n\n------------\n\n\n")

    return CurrentCamera:WorldToScreenPoint(PredictedLocation)
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
                local res = get_prediction_pos(entry, character);

                if getgenv().AIMBOT_SETTINGS.PredictBulletDrop then
                    local distance = GetDistance(get_current_pos(), body_parts.head.Position);
                    local ballistic_pos = (get_bal_pos(player))
                    if ballistic_pos then
                        res = Vector2.new(res.X, ballistic_pos.Y - (ballistic_pos.Y - res.Y))
                        print("\n\n", "BALLISTIC POS = ", ballistic_pos, "\n\n", "RES = ", res, "\n\n", "DISTANCE = ",
                        distance, "\n\n")
                    end
                end
                targetPos = res;
                AimPoint.Position = Vector2.new(res.X, res.Y)

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
local circle = Drawing.new("Circle")
circle.Thickness = 2
circle.NumSides = 12
circle.Radius = 350
circle.Filled = false
circle.Transparency = 1
circle.Color = Color3.new(math.random(), math.random(), math.random())
circle.Visible = true

local margin = 20;
local screenWidth = game.Players.LocalPlayer:GetMouse().ViewSizeX
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
        if getgenv().AIMBOT_SETTINGS.PredictBulletDrop then
            createText("Bullet Drop Enabled", Vector2.new(screenWidth - 150, 0 * margin))
        else
            createText("Bullet Drop Disabled", Vector2.new(screenWidth - 150, 0 * margin))
        end
        circle.Position = mouseLocation(UserInputService)
        circle.Radius = getgenv().AIMBOT_SETTINGS.FOV
    end
end)

local uis = game:GetService("UserInputService")

uis.InputBegan:Connect(function(input)
    if (uis:GetFocusedTextBox() or id ~= getgenv().AIMBOT_SETTINGS.id) then
        return; -- make sure player's not chatting!
    end
    if input.KeyCode == Enum.KeyCode.LeftAlt then
        getgenv().AIMBOT_SETTINGS.PredictBulletDrop = not getgenv().AIMBOT_SETTINGS.PredictBulletDrop
    end
end)